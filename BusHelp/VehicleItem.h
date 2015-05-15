//
//  VehicleItem.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/17.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vehicle.h"
#import "OilTotalItem.h"

@interface VehicleItem : NSObject

@property (nonatomic, strong) NSString * engineNumber;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * number;
@property (nonatomic, strong) NSString * numberType;
@property (nonatomic, strong) NSString * oilLastUpdateTime;
@property (nonatomic, strong) NSString * vehicleID;
@property (nonatomic, strong) NSString * vinNumber;
@property (nonatomic, retain) NSSet *hasOil;
@property (nonatomic, retain) OilTotalItem *hasOilTotal;
@property (nonatomic, retain) NSSet *hasViolation;

- (NSDictionary *)convertModelToDictionary;
+ (VehicleItem *)convertVehicleToVehicleItem:(Vehicle *)vehicle;

@end
