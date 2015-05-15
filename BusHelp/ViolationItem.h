//
//  ViolationItem.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/12.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Violation.h"

@interface ViolationItem : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSNumber * money;
@property (nonatomic, strong) NSString * reason;
@property (nonatomic, strong) NSNumber * score;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * violationID;

+ (ViolationItem *)convertVehicleToVehicleItem:(Violation *)violation;

@end
