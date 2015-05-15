//
//  ShieldVehicleTableViewController.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/5.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShieldVehicleTableViewController : UITableViewController

@property (nonatomic, strong) NSString *navigationTitle;
@property (nonatomic, strong) NSArray *vehicleListArray;
@property (nonatomic, strong) NSString *orgID;
@property (copy, nonatomic) void (^updateVehicleListArrayBlock)(NSArray *listArray);

@end
