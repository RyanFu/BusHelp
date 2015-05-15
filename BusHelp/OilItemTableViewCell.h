//
//  OilItemTableViewCell.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/24.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataRequest.h"

@interface OilItemTableViewCell : UITableViewCell

@property (strong, nonatomic) Oil *oil;
@property (assign, nonatomic) BOOL isShowButton;

@property (copy, nonatomic) void (^editButtonPressedBlock)(Oil *oil);
@property (copy, nonatomic) void (^rubbishButtonPressedBlock)(NSString *oilID, NSString *vehicleId);
@property (copy, nonatomic) void (^attachmentButtonPressedBlock)(Oil *oil);

@end
