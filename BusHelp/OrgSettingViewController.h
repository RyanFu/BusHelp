//
//  OrgSettingViewController.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/12.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "BaseViewController.h"

@interface OrgSettingViewController : BaseViewController

@property (nonatomic, strong) NSArray *vehicleListArray;
@property (nonatomic, strong) NSString *orgID;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *orgName;
@property (copy, nonatomic) void (^updateVehicleListArrayBlock)(NSArray *listArray);

@end
