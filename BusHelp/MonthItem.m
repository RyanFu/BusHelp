//
//  MonthItem.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/12.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "MonthItem.h"

@implementation MonthItem

+ (MonthItem *)convertMonthToMonthItem:(Month *)month {
    MonthItem *monthItem = [[MonthItem alloc] init];
    monthItem.month = month.month;
    monthItem.number = month.number;
    
    return monthItem;
}

@end
