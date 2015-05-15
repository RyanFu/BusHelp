//
//  OilItem.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/17.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Oil.h"

@interface OilItem : NSObject

@property (nonatomic, strong) NSArray * attachmentList;
@property (nonatomic, strong) NSNumber * avgNumber;
@property (nonatomic, strong) NSNumber * mileage;
@property (nonatomic, strong) NSNumber * money;
@property (nonatomic, strong) NSNumber * number;
@property (nonatomic, strong) NSString * oilID;
@property (nonatomic, strong) NSNumber * price;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * typeName;
@property (nonatomic, strong) NSString * stationName;
@property (nonatomic, strong) NSString * updateTime;
@property (nonatomic, strong) NSNumber * isSubmit;
@property (nonatomic, strong) NSNumber * dataType;
@property (nonatomic, strong) NSString * vehicleID;

- (NSDictionary *)convertModelToDictionary;
+ (OilItem *)convertOilToOilItem:(Oil *)oil;

@end
