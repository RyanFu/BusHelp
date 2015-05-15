//
//  OilTotalItem.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/12.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "OilTotalItem.h"
#import "MonthItem.h"

@implementation OilTotalItem

+ (OilTotalItem *)convertOilTotalToOilTotalItem:(OilTotal *)oilTotal {
    OilTotalItem *oilTotalItem = [[OilTotalItem alloc] init];
    oilTotalItem.avgNumber = oilTotal.avgNumber;
    oilTotalItem.mileageSumNumber = oilTotal.mileageSumNumber;
    oilTotalItem.vehicleID = oilTotal.vehicleID;
    
    NSMutableOrderedSet *monthOrderSet = [NSMutableOrderedSet orderedSetWithCapacity:oilTotal.hasMonth.count];
    for (Month *month in oilTotal.hasMonth) {
        MonthItem *monthItem = [MonthItem convertMonthToMonthItem:month];
        [monthOrderSet addObject:monthItem];
    }
    
    oilTotalItem.hasMonth = monthOrderSet;
    
    return oilTotalItem;
}

@end
