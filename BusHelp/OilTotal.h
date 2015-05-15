//
//  OilTotal.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/6.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Month, Vehicle;

@interface OilTotal : NSManagedObject

@property (nonatomic, retain) NSNumber * avgNumber;
@property (nonatomic, retain) NSNumber * mileageSumNumber;
@property (nonatomic, retain) NSString * vehicleID;
@property (nonatomic, retain) Vehicle *belongsToVehicle;
@property (nonatomic, retain) NSOrderedSet *hasMonth;
@end

@interface OilTotal (CoreDataGeneratedAccessors)

- (void)insertObject:(Month *)value inHasMonthAtIndex:(NSUInteger)idx;
- (void)removeObjectFromHasMonthAtIndex:(NSUInteger)idx;
- (void)insertHasMonth:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeHasMonthAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInHasMonthAtIndex:(NSUInteger)idx withObject:(Month *)value;
- (void)replaceHasMonthAtIndexes:(NSIndexSet *)indexes withHasMonth:(NSArray *)values;
- (void)addHasMonthObject:(Month *)value;
- (void)removeHasMonthObject:(Month *)value;
- (void)addHasMonth:(NSOrderedSet *)values;
- (void)removeHasMonth:(NSOrderedSet *)values;
@end
