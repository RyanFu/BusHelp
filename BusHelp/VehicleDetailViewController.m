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

@interface VehicleDetailViewController ()
{
    int len;
    int percent;
    NSTimer *mytimer;
    NSTimer *percentTimer;

}
@end

@implementation VehicleDetailViewController
@synthesize vehicle;

- (void)viewWillAppear:(BOOL)animated
{
    len=0;
    percent=0;
    
    self.statusBall.highlighted=YES;
    self.percentLabel.text=[NSString stringWithFormat:@"%i%%",percent];
    
    mytimer=[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(animate) userInfo:nil repeats:YES];
    percentTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updatepercent) userInfo:nil repeats:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NumberLabel.text=vehicle.number;
    self.BatteryHead.layer.masksToBounds=YES;
    self.BatteryHead.layer.cornerRadius=2;
    [self setupNavigationBar];
   
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

-(void)updatepercent
{
    if (percent<100) {
        percent=percent+10;
        self.percentLabel.text=[NSString stringWithFormat:@"%i%%",percent];
        if (percent==100) {
            [mytimer invalidate];
            self.batteryView.percent=[[NSString stringWithFormat:@"%i",100] floatValue]/100;
            [self.batteryView setNeedsDisplay];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if ([mytimer isValid]) {
        [mytimer invalidate];
    }
    if ([percentTimer isValid]) {
        [percentTimer invalidate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"VehicleDetailToHigerVehicleList"]) {
        HigerVehicleListViewController *higerVehicle=segue.destinationViewController;
        higerVehicle.dismiss=^(Vehicle *selectVehicle){
            vehicle=selectVehicle;
            self.NumberLabel.text=vehicle.number;
        };
    }
}


@end
