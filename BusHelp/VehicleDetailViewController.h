//
//  VehicleDetailViewController.h
//  BusHelp
//
//  Created by Paul on 15/5/20.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Vehicle.h"
#import "BaseView.h"
#import "BatteryView.h"

@interface VehicleDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *NumberLabel;
@property (weak, nonatomic) IBOutlet BaseView *baseview1;
@property (weak, nonatomic) IBOutlet BaseView *BaseView2;
@property (weak, nonatomic) IBOutlet BatteryView *batteryView;
@property (weak, nonatomic) IBOutlet UIImageView *BatteryHead;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *ContinutionMile;
@property (weak, nonatomic) IBOutlet UILabel *TotalMile;
@property (weak, nonatomic) IBOutlet UILabel *UpdateTime;
@property (weak, nonatomic) IBOutlet UIImageView *statusBall;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property(nonatomic,weak)Vehicle *vehicle;
@end
