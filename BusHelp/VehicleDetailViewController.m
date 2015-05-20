//
//  VehicleDetailViewController.m
//  BusHelp
//
//  Created by Paul on 15/5/20.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "VehicleDetailViewController.h"
#import <UIKit/UIKit.h>

@interface VehicleDetailViewController ()
{
    int per;
    NSTimer *mytimer;
}
@end

@implementation VehicleDetailViewController
@synthesize vehicle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NumberLabel.text=vehicle.number;
    self.BatteryHead.layer.masksToBounds=YES;
    self.BatteryHead.layer.cornerRadius=2;
    per=0;
    
    mytimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animate) userInfo:nil repeats:YES];
    
    self.statusBall.highlighted=YES;
}

-(void)setupNavigationBar
{
    self.navigationItem.title=@"车辆";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)animate
{
    if (per<100) {
        per=per+1;
        self.percentLabel.text=[NSString stringWithFormat:@"%i%%",per];
        self.batteryView.percent=[[NSString stringWithFormat:@"%i",per] floatValue]/100;
        [self.batteryView setNeedsDisplay];
    }else
    {
        [mytimer invalidate];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    mytimer=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
