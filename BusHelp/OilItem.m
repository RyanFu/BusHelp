//
//  OilItem.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/17.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "OilItem.h"
#import "Vehicle.h"

@implementation OilItem

- (NSDictionary *)convertModelToDictionary {
    return @{@"vehicle_id" : self.vehicleID, @"oil_id" : self.oilID,  @"oil_time" : self.time, @"oil_mileage" : self.mileage, @"oil_type_name" : self.typeName, @"oil_price" : self.price, @"oil_money" : self.money, @"oil_number" : self.number, @"station_name" : self.stationName, @"attachment_key_list" : self.attachmentList};
}

+ (OilItem *)convertOilToOilItem:(Oil *)oil {
    OilItem *oilItem = [[OilItem alloc] init];
    oilItem.attachmentList = oil.attachmentList;
    oilItem.avgNumber = oil.avgNumber;
    oilItem.mileage = oil.mileage;
    oilItem.money = oil.money;
    oilItem.number = oil.number;
    oilItem.oilID = oil.oilID;
    oilItem.price = oil.price;
    oilItem.time = oil.time;
    oilItem.typeName = oil.typeName;
    oilItem.vehicleID = oil.belongsToVehicle.vehicleID;
    oilItem.stationName = oil.stationName;
    oilItem.dataType = oil.dataType;
    oilItem.isSubmit = oil.isSubmit;
    oilItem.updateTime = oil.updateTime;
    
    return oilItem;
}


@end
