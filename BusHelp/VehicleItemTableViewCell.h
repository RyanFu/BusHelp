//
//  VehicleItemTableViewCell.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/23.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataRequest.h"

@interface VehicleItemTableViewCell : UITableViewCell

@property (strong, nonatomic) Vehicle *vehicle;
@property (copy, nonatomic) void (^editButtonPressedBlock)(Vehicle *vehicle);
@property (copy, nonatomic) void (^rubbishButtonPressedBlock)(NSString *vehicleID);
@property (copy, nonatomic) void (^AuthenticationButtonPressedBlock)(Vehicle *vehicle);

@end
