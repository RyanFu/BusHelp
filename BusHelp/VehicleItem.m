//
//  VehicleItem.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/17.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "VehicleItem.h"
#import "OilItem.h"
#import "OilTotalItem.h"
#import "ViolationItem.h"

@implementation VehicleItem

- (NSDictionary *)convertModelToDictionary {
    return @{@"vehicle_id" : self.vehicleID, @"vehicle_number_type" : self.numberType, @"vehicle_name" : self.name, @"vehicle_number" : self.number, @"vehicle_vin_number" : self.vinNumber, @"vehicle_engine_number" : self.engineNumber};
}

+ (VehicleItem *)convertVehicleToVehicleItem:(Vehicle *)vehicle {
    VehicleItem *vehicleItem = [[VehicleItem alloc] init];
    vehicleItem.engineNumber = vehicle.engineNumber;
    vehicleItem.name = vehicle.name;
    vehicleItem.number = vehicle.number;
    vehicleItem.numberType = vehicle.numberType;
    vehicleItem.oilLastUpdateTime = vehicle.oilLastUpdateTime;
    vehicleItem.vehicleID = vehicle.vehicleID;
    vehicleItem.vinNumber = vehicle.vinNumber;
    
    NSMutableSet *oilSet = [NSMutableSet setWithCapacity:vehicle.hasOil.count];
    for (Oil *oil in vehicle.hasOil) {
        OilItem *oilItem = [OilItem convertOilToOilItem:oil];
        [oilSet addObject:oilItem];
    }
    vehicleItem.hasOil = oilSet;

    vehicleItem.hasOilTotal = [OilTotalItem convertOilTotalToOilTotalItem:vehicle.hasOilTotal];
    
    NSMutableSet *violationSet = [NSMutableSet setWithCapacity:vehicle.hasViolation.count];
    for (Violation *violation in vehicle.hasViolation) {
        ViolationItem *violationItem = [ViolationItem convertVehicleToVehicleItem:violation];
        [violationSet addObject:violationItem];
    }
    vehicleItem.hasViolation = violationSet;
    
    return vehicleItem;
}

@end
