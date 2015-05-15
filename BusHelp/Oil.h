//
//  Oil.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/5.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Vehicle;

@interface Oil : NSManagedObject

@property (nonatomic, retain) id attachmentList;
@property (nonatomic, retain) NSNumber * avgNumber;
@property (nonatomic, retain) NSNumber * dataType;
@property (nonatomic, retain) NSNumber * isSubmit;
@property (nonatomic, retain) NSNumber * mileage;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * oilID;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * stationName;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * typeName;
@property (nonatomic, retain) NSString * updateTime;
@property (nonatomic, retain) Vehicle *belongsToVehicle;

@end
