//
//  Org.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/5.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OrgMessage, Task;

@interface Org : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * orgID;
@property (nonatomic, retain) id vehicleList;
@property (nonatomic, retain) NSSet *hasOrgMessage;
@property (nonatomic, retain) NSSet *hasTask;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *userType;

@end

@interface Org (CoreDataGeneratedAccessors)

- (void)addHasOrgMessageObject:(OrgMessage *)value;
- (void)removeHasOrgMessageObject:(OrgMessage *)value;
- (void)addHasOrgMessage:(NSSet *)values;
- (void)removeHasOrgMessage:(NSSet *)values;

- (void)addHasTaskObject:(Task *)value;
- (void)removeHasTaskObject:(Task *)value;
- (void)addHasTask:(NSSet *)values;
- (void)removeHasTask:(NSSet *)values;

@end
