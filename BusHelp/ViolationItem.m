//
//  ViolationItem.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/12.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ViolationItem.h"

@implementation ViolationItem

+ (ViolationItem *)convertVehicleToVehicleItem:(Violation *)violation {
    ViolationItem *violationItem = [[ViolationItem alloc] init];
    violationItem.address = violation.address;
    violationItem.money = violation.money;
    violationItem.reason = violation.reason;
    violationItem.score = violation.score;
    violationItem.time = violation.time;
    violationItem.violationID = violation.violationID;
    
    return violationItem;
}

@end
