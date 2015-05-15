//
//  OilTotalItem.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/12.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OilTotal.h"

@interface OilTotalItem : NSObject

@property (nonatomic, strong) NSNumber * avgNumber;
@property (nonatomic, strong) NSNumber * mileageSumNumber;
@property (nonatomic, strong) NSString * vehicleID;
@property (nonatomic, strong) NSOrderedSet *hasMonth;

+ (OilTotalItem *)convertOilTotalToOilTotalItem:(OilTotal *)oilTotal;

@end
