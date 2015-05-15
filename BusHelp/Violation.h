//
//  Violation.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/5.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Vehicle;

@interface Violation : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSString * reason;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * violationID;
@property (nonatomic, retain) Vehicle *belongsToVehicle;

@end
