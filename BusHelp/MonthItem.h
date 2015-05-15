//
//  MonthItem.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/12.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Month.h"

@interface MonthItem : NSObject

@property (nonatomic, strong) NSNumber * month;
@property (nonatomic, strong) NSNumber * number;

+ (MonthItem *)convertMonthToMonthItem:(Month *)month;

@end
