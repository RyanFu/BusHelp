//
//  Vehicle.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/5.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Oil, OilTotal, Violation;

@interface Vehicle : NSManagedObject

@property (nonatomic, retain) NSString * engineNumber;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * numberType;
@property (nonatomic, retain) NSString * oilLastUpdateTime;
@property (nonatomic, retain) NSString * vehicleID;
@property (nonatomic, retain) NSString * vinNumber;
@property (nonatomic, retain) NSSet *hasOil;
@property (nonatomic, retain) OilTotal *hasOilTotal;
@property (nonatomic, retain) NSSet *hasViolation;
@end

@interface Vehicle (CoreDataGeneratedAccessors)

- (void)addHasOilObject:(Oil *)value;
- (void)removeHasOilObject:(Oil *)value;
- (void)addHasOil:(NSSet *)values;
- (void)removeHasOil:(NSSet *)values;

- (void)addHasViolationObject:(Violation *)value;
- (void)removeHasViolationObject:(Violation *)value;
- (void)addHasViolation:(NSSet *)values;
- (void)removeHasViolation:(NSSet *)values;

@end
