//
//  VehicleDetailViewController.m
//  BusHelp
//
//  Created by Paul on 15/5/20.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "VehicleDetailViewController.h"
#import <UIKit/UIKit.h>
#import "HigerVehicleListViewController.h"
#import "DataRequest.h"
#import "Vehicle.h"

@interface VehicleDetailViewController ()
{
    int len;
    int percent;
    NSTimer *animatetimer;
    NSTimer *updateTimer;
    NSArray *_vehicleArray;
    Vehicle *_vehicle;
    NSMutableArray *higerVehicle;
    NSDictionary *vehicleinfo;

}
@end

@implementation VehicleDetailViewController
@synthesize vehicle;


- (void)viewWillAppear:(BOOL)animated
{
    len=0;
    percent=0;
    
    self.percentLabel.text=@"--%";
    self.TotalMile.text=@"--";
    self.ContinutionMile.text=@"--";
    
    
//    animatetimer=[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(animate) userInfo:nil repeats:YES];
//    percentTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updatepercent) userInfo:nil repeats:YES];
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(updateVehicleInfo) userInfo:nil repeats:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    higerVehicle=[[NSMutableArray alloc]init];
    vehicleinfo=[[NSDictionary alloc]init];
    
    self.NumberLabel.text=vehicle.number;
    self.BatteryHead.layer.masksToBounds=YES;
    self.BatteryHead.layer.cornerRadius=2;
    [self setupNavigationBar];
    if (!vehicle.number) {
        [self setupData];
    }else
    {
        [self getVehicleInfo];
    }
   
}

-(void)setupNavigationBar
{
    self.navigationItem.title=@"车辆监测";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"换车" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self performSegueWithIdentifier:@"VehicleDetailToHigerVehicleList" sender:self];
}

-(void)setupData
{
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest fetchVehicleWithSuccess:^(NSArray *vehicleArray) {
            _vehicleArray = [NSMutableArray arrayWithArray:vehicleArray];
            [higerVehicle removeAllObjects];
            for (int i=0; i<_vehicleArray.count; i++) {
                _vehicle=[_vehicleArray objectAtIndex:i];
                if ([_vehicle.identify_status isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)AuthenticationTypeHiger]]) {
                    [higerVehicle addObject:_vehicle];
                }
            }
            if ([higerVehicle firstObject]) {
                vehicle=[higerVehicle firstObject];
                self.NumberLabel.text=vehicle.number;
                NSLog(@"%@",vehicle.number);
                [CommonFunctionController hideAllHUD];
                [self getVehicleInfo];

            }else
            {
                [self hidesubviews];
                [CommonFunctionController hideAllHUD];
                if ([updateTimer isValid]) {
                    [updateTimer invalidate];
                }
                
            }
            
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
    
}

- (void)getVehicleInfo
{
    if ([CommonFunctionController checkNetworkWithNotify:NO]&&[CommonFunctionController checkValueValidate:vehicle.number]) {
        [CommonFunctionController showAnimateHUDWithMessage:@"监测信息获取中.."];
        [DataRequest getVehicleDetectionInfo:vehicle.vehicleID success:^(id data){
            NSLog(@"%@",data);
            if ([data firstObject]) {
                vehicleinfo=[data firstObject];
                self.percentLabel.text=[NSString stringWithFormat:@"%@%%",[vehicleinfo objectForKey:@"batteryVoltage"]];
                self.ContinutionMile.text=[vehicleinfo objectForKey:@"enduranceMileage"];
                self.TotalMile.text=[vehicleinfo objectForKey:@"totalMileage"];
                self.UpdateTime.text=[NSString stringWithFormat:@"更新于: %@",[vehicleinfo objectForKey:@"updateTime"]];
                NSString *status=[vehicleinfo objectForKey:@"stateCharge"];
                if ([status isEqualToString:@"1"]) {
                    [self startanimate];
                }else if ([status isEqualToString:@"0"])
                {
                    self.batteryView.percent=[[NSString stringWithFormat:@"%@",[vehicleinfo objectForKey:@"batteryVoltage"]] floatValue]/100;
                    [self.batteryView setNeedsDisplay];
                }else if([status isEqualToString:@"--"])
                {
                    self.batteryView.percent=0;
                    [self.batteryView setNeedsDisplay];
                    
                }
                [CommonFunctionController hideAllHUD];
            }
            
        }failure:^(NSString *message){
            NSLog(@"%@",message);
            [CommonFunctionController showHUDWithMessage:message success:NO];

        }];
    }
}

- (void)updateVehicleInfo
{
    if ([CommonFunctionController checkNetworkWithNotify:NO]&&[CommonFunctionController checkValueValidate:vehicle.number]) {
//        [CommonFunctionController showAnimateHUDWithMessage:@"监测信息获取中.."];
        [DataRequest getVehicleDetectionInfo:vehicle.vehicleID success:^(id data){
            NSLog(@"%@",data);
            if ([data firstObject]) {
                vehicleinfo=[data firstObject];
                self.percentLabel.text=[NSString stringWithFormat:@"%@%%",[vehicleinfo objectForKey:@"batteryVoltage"]];
                self.ContinutionMile.text=[vehicleinfo objectForKey:@"enduranceMileage"];
                self.TotalMile.text=[vehicleinfo objectForKey:@"totalMileage"];
                self.UpdateTime.text=[NSString stringWithFormat:@"更新于: %@",[vehicleinfo objectForKey:@"updateTime"]];
                NSString *status=[vehicleinfo objectForKey:@"stateCharge"];
                if ([status isEqualToString:@"1"]) {
                    [self startanimate];
                }else if ([status isEqualToString:@"0"])
                {
                    self.batteryView.percent=[[NSString stringWithFormat:@"%@",[vehicleinfo objectForKey:@"batteryVoltage"]] floatValue]/100;
                    [self.batteryView setNeedsDisplay];
                }else if([status isEqualToString:@"--"])
                {
                    self.batteryView.percent=0;
                    [self.batteryView setNeedsDisplay];
                    
                }
            }

//            [CommonFunctionController hideAllHUD];
        }failure:^(NSString *message){
            NSLog(@"%@",message);
            [CommonFunctionController showHUDWithMessage:message success:NO];
            
        }];
    }

}

- (void)startanimate
{
    if ([animatetimer isValid]) {
        [animatetimer invalidate];
        animatetimer=[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(animate) userInfo:nil repeats:YES];
    }else
    {
        animatetimer=[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(animate) userInfo:nil repeats:YES];
    }
   
}

-(void)animate
{
    if (len<100) {
        len=len+1;
        self.batteryView.percent=[[NSString stringWithFormat:@"%i",len] floatValue]/100;
        [self.batteryView setNeedsDisplay];
        if (len==100) {
            len=0;
            self.batteryView.percent=[[NSString stringWithFormat:@"%i",len] floatValue]/100;
            [self.batteryView setNeedsDisplay];
        }
    }
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    if ([animatetimer isValid]) {
        [animatetimer invalidate];
    }
    if ([updateTimer isValid]) {
        [updateTimer invalidate];
    }
}

- (void)hidesubviews
{
    self.NumberLabel.hidden=YES;
    self.baseview1.hidden=YES;
    self.BaseView2.hidden=YES;
    self.UpdateTime.hidden=YES;
    self.lineimage.hidden=YES;
    self.tipLabel.hidden=NO;
    self.tipLabel.text=@"尊敬的用户，您好！目前系统只支持海格电动车，若您账号下无电动车或您的电动车正在审核中，监测信息功能暂不展示，敬请谅解。";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"VehicleDetailToHigerVehicleList"]) {
        HigerVehicleListViewController *higerVehicleVC=segue.destinationViewController;
        higerVehicleVC.dismiss=^(Vehicle *selectVehicle){
            vehicle=selectVehicle;
            self.NumberLabel.text=vehicle.number;
            [self getVehicleInfo];
        };
    }
}


@end
