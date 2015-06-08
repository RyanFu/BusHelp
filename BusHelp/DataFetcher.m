//
//  DataFetcher.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/17.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "RequestInfo.h"
#import "NSDate+custom.h"
#import "DataFetcher.h"
#import "ErrorHandler.h"

@interface DataFetcher ()

+ (RequestInfo *)fetchRequestInfo;

@end

@implementation DataFetcher

+ (void)setupCoreDataStackWithStoreNamed:(NSString *)storeName {
    [MagicalRecord cleanUp];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:storeName];
    [MagicalRecord setErrorHandlerTarget:[ErrorHandler sharedInstance] action:@selector(handlerError:)];
}

+ (RequestInfo *)fetchRequestInfo {
    RequestInfo *requestInfo = nil;
    if ([RequestInfo MR_findAll].count > 0) {
        requestInfo = [RequestInfo MR_findFirst];
    }
    else {
        requestInfo = [RequestInfo MR_createEntity];
    }
    
    return requestInfo;
}

+ (void)importVehicleFromArray:(NSArray *)dataArray completion:(void(^)(void))completion {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT(vehicleID IN %@)", [dataArray valueForKeyPath:@"vehicle_id"]];
    [Vehicle MR_deleteAllMatchingPredicate:predicate];
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        [Vehicle MR_importFromArray:dataArray inContext:localContext];
    } completion:completion];
}

+ (void)addVehicleByVehicleItem:(VehicleItem *)vehicleItem completion:(void(^)(void))completion {
    NSString *vehicleID = vehicleItem.vehicleID;
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        Vehicle *vehicle = [Vehicle MR_createInContext:localContext];
        vehicle.vehicleID = vehicleItem.vehicleID;
        vehicle.numberType = vehicleItem.numberType;
        vehicle.engineNumber = vehicleItem.engineNumber;
        vehicle.name = vehicleItem.name;
        vehicle.number = vehicleItem.number;
        vehicle.vinNumber = vehicleItem.vinNumber;
        vehicle.oilLastUpdateTime = vehicleItem.oilLastUpdateTime;
    } completion:^{
        [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
            NSMutableSet *hasOilSet = [NSMutableSet setWithCapacity:vehicleItem.hasOil.count];
            for (OilItem *oilItem in vehicleItem.hasOil) {
                Oil *localOil = [Oil MR_createInContext:localContext];
                localOil.attachmentList = oilItem.attachmentList;
                localOil.avgNumber = oilItem.avgNumber;
                localOil.mileage = oilItem.mileage;
                localOil.money = oilItem.money;
                localOil.number = oilItem.number;
                localOil.oilID = oilItem.oilID;
                localOil.price = oilItem.price;
                localOil.time = oilItem.time;
                localOil.typeName = oilItem.typeName;
                localOil.updateTime = oilItem.updateTime;
                localOil.stationName = oilItem.stationName;
                localOil.isSubmit = oilItem.isSubmit;
                localOil.dataType = oilItem.dataType;
                [hasOilSet addObject:localOil];
            }
            Vehicle *loaclVehicle = [Vehicle MR_findFirstByAttribute:@"vehicleID" withValue:vehicleID inContext:localContext];
            loaclVehicle.hasOil = hasOilSet;
        } completion:^{
            [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
                if (vehicleItem.hasOilTotal != nil) {
                    OilTotal *oilTotal = [OilTotal MR_createInContext:localContext];
                    oilTotal.avgNumber = vehicleItem.hasOilTotal.avgNumber;
                    oilTotal.mileageSumNumber = vehicleItem.hasOilTotal.mileageSumNumber;
                    oilTotal.vehicleID = vehicleItem.hasOilTotal.vehicleID;
                    Vehicle *loaclVehicle = [Vehicle MR_findFirstByAttribute:@"vehicleID" withValue:vehicleID inContext:localContext];
                    loaclVehicle.hasOilTotal = oilTotal;
                }
            } completion:^{
                [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
                    OilTotal *loaclOilTotal = [OilTotal MR_findFirstByAttribute:@"vehicleID" withValue:vehicleID inContext:localContext];
                    NSMutableOrderedSet *monthSet = [NSMutableOrderedSet orderedSetWithCapacity:vehicleItem.hasOilTotal.hasMonth.count];
                    for (MonthItem *monthItem in vehicleItem.hasOilTotal.hasMonth) {
                        Month *month = [Month MR_createInContext:localContext];
                        month.month = monthItem.month;
                        month.number = monthItem.number;
                        [monthSet addObject:month];
                    }
                    loaclOilTotal.hasMonth = monthSet;
                } completion:^{
                    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
                        NSMutableSet *violationSet = [NSMutableSet setWithCapacity:vehicleItem.hasViolation.count];
                        for (ViolationItem *violationItem in vehicleItem.hasViolation) {
                            Violation *violation = [Violation MR_createInContext:localContext];
                            violation.address = violationItem.address;
                            violation.money = violationItem.money;
                            violation.reason = violationItem.reason;
                            violation.score = violationItem.score;
                            violation.time = violationItem.time;
                            violation.violationID = violationItem.violationID;
                            
                            [violationSet addObject:violation];
                        }
                        Vehicle *loaclVehicle = [Vehicle MR_findFirstByAttribute:@"vehicleID" withValue:vehicleID inContext:localContext];
                        loaclVehicle.hasViolation = violationSet;
                    } completion:completion];
                }];
            }];
        }];
    }];
}

+ (void)removeVehicleFromArray:(NSArray *)vehicleArray completion:(void(^)(void))completion {
    [self removeVehicleByVehicelIDArray:[vehicleArray valueForKeyPath:@"vehicleID"] completion:completion];
}

+ (void)removeVehicleByVehicelIDArray:(NSArray *)vehicleIDArray completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"vehicleID IN %@", vehicleIDArray];
        [Vehicle MR_deleteAllMatchingPredicate:predicate inContext:localContext];
    } completion:completion];
}

+ (void)removeVehicleByVehicelID:(NSString *)vehicleID completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        Vehicle *vehicle = [Vehicle MR_findFirstByAttribute:@"vehicleID" withValue:vehicleID inContext:localContext];
        [vehicle MR_deleteInContext:localContext];
    } completion:completion];
}

+ (void)updateVehicleByVehicleItem:(VehicleItem *)vehicleItem completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        Vehicle *localVehicle = [Vehicle MR_findFirstByAttribute:@"vehicleID" withValue:vehicleItem.vehicleID];
        localVehicle.numberType = vehicleItem.numberType;
        localVehicle.engineNumber = vehicleItem.engineNumber;
        localVehicle.name = vehicleItem.name;
        localVehicle.number = vehicleItem.number;
        localVehicle.vinNumber = vehicleItem.vinNumber;
        localVehicle.oilLastUpdateTime = vehicleItem.oilLastUpdateTime;
    } completion:completion];
}

+ (NSArray *)fetchAllVehicle:(BOOL)ascending {
    return [Vehicle MR_findAllSortedBy:@"number" ascending:ascending];
}

+ (NSArray *)fetchVehicelByVehicleIDArray:(NSArray *)vehicleIDArray {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"vehicleID IN %@", vehicleIDArray];
    return [Vehicle MR_findAllWithPredicate:predicate];
}

+ (Vehicle *)fetchVehicelByVehicleID:(NSString *)vehicleID {
    return [Vehicle MR_findFirstByAttribute:@"vehicleID" withValue:vehicleID];
}

+ (Vehicle *)fetchVehicelByVehicleNumber:(NSString *)numeber {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"number ==[cd] %@", numeber];
    return [Vehicle MR_findFirstWithPredicate:predicate];
}

+ (void)importViolationFromArray:(NSArray *)dataArray completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dataDictionary = (NSDictionary *)obj;
            NSString *vehicleID = [dataDictionary objectForKey:@"vehicle_id"];
            NSArray *violationArray = [dataDictionary objectForKey:@"violation_list"];
            
            NSArray *importedArray = [Violation MR_importFromArray:violationArray inContext:localContext];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT(violationID IN %@) AND belongsToVehicle.vehicleID == %@", [violationArray valueForKeyPath:@"violation_id"], vehicleID];
            [Violation MR_deleteAllMatchingPredicate:predicate inContext:localContext];
            
            Vehicle *localVehicle = [Vehicle MR_findFirstByAttribute:@"vehicleID" withValue:vehicleID inContext:localContext];
            localVehicle.hasViolation = [NSSet setWithArray:importedArray];
        }];
    } completion:completion];
}

+ (void)removeAllViolation:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        [Violation MR_deleteAllMatchingPredicate:nil inContext:localContext];
    } completion:completion];
}

+ (NSArray *)fetchAllViolation:(BOOL)ascending {
    return [Violation MR_findAllSortedBy:@"time" ascending:ascending];
}

+ (Violation *)fetchViolationByViolationID:(NSString *)violationID {
    return [Violation MR_findFirstByAttribute:@"violationID" withValue:violationID];
}

+ (NSArray *)fetchViolationByVehicleID:(NSString *)vehicleID ascending:(BOOL)ascending {
    Vehicle *vehicle = [self fetchVehicelByVehicleID:vehicleID];
    NSArray *violationArray = [NSArray arrayWithArray:vehicle.hasViolation.allObjects];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:ascending];
    violationArray = [violationArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    return violationArray;
}

+ (void)importOilFromArray:(NSArray *)dataArray vehicleID:(NSString *)vehicleID completion:(void(^)(void))completion {
    //NSString *vehicleID = [[dataArray valueForKeyPath:@"vehicle_id"] firstObject];
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        NSArray *importedArray = [Oil MR_importFromArray:dataArray inContext:localContext];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT(oilID IN %@) AND belongsToVehicle.vehicleID == %@ AND isSubmit == %@", [dataArray valueForKeyPath:@"oil_id"], vehicleID, [NSNumber numberWithBool:YES]];
        [Oil MR_deleteAllMatchingPredicate:predicate inContext:localContext];
        
        Vehicle *localVehicle = [Vehicle MR_findFirstByAttribute:@"vehicleID" withValue:vehicleID inContext:localContext];
        NSMutableSet *oilSet = nil;
        if (localVehicle.hasOil == nil) {
            oilSet = [NSMutableSet setWithCapacity:1];
        }
        else {
            oilSet = [NSMutableSet setWithSet:localVehicle.hasOil];
        }
        [oilSet addObjectsFromArray:importedArray];
        localVehicle.hasOil = oilSet;
        
        NSString *lastUpdateTime = [localVehicle.hasOil.allObjects valueForKeyPath:@"@max.updateTime"];
        localVehicle.oilLastUpdateTime = lastUpdateTime;
        
        for (Oil *oil in importedArray) {
            Oil *localOil = [oil MR_inContext:localContext];
            localOil.isSubmit = [NSNumber numberWithBool:YES];
            localOil.dataType = [NSNumber numberWithInteger:OilDataTypeCommitted];
        }
    } completion:completion];
}

+ (void)addOilByOilItem:(OilItem *)oilItem completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        Oil *oil = [Oil MR_createInContext:localContext];
        oil.attachmentList = oilItem.attachmentList;
        oil.avgNumber = oilItem.avgNumber;
        oil.mileage = oilItem.mileage;
        oil.money = oilItem.money;
        oil.number = oilItem.number;
        oil.oilID = oilItem.oilID;
        oil.price = oilItem.price;
        oil.time = oilItem.time;
        oil.typeName = oilItem.typeName;
        oil.updateTime = oilItem.updateTime;
        oil.stationName = oilItem.stationName;
        oil.isSubmit = oilItem.isSubmit;
        oil.dataType = oilItem.dataType;
        
        Vehicle *localVehicle = [Vehicle MR_findFirstByAttribute:@"vehicleID" withValue:oilItem.vehicleID inContext:localContext];
        NSMutableSet *oilSet = nil;
        if (localVehicle.hasOil == nil) {
            oilSet = [NSMutableSet setWithCapacity:1];
        }
        else {
            oilSet = [NSMutableSet setWithSet:localVehicle.hasOil];
        }
        [oilSet addObject:oil];
        localVehicle.hasOil = oilSet;
    } completion:completion];
}

+ (void)removeOilFromArray:(NSArray *)oilArray completion:(void(^)(void))completion {
    [self removeOilByOilIDArray:[oilArray valueForKeyPath:@"oilID"] completion:completion];
}

+ (void)removeOilByOilIDArray:(NSArray *)oilIDArray completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"oilID IN %@", oilIDArray];
        [Oil MR_deleteAllMatchingPredicate:predicate inContext:localContext];
    } completion:completion];
}

+ (void)updateOilByOilItem:(OilItem *)oilItem completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        Oil *localOil = [Oil MR_findFirstByAttribute:@"oilID" withValue:oilItem.oilID inContext:localContext];
        localOil.attachmentList = oilItem.attachmentList;
        localOil.avgNumber = oilItem.avgNumber;
        localOil.mileage = oilItem.mileage;
        localOil.money = oilItem.money;
        localOil.number = oilItem.number;
        localOil.oilID = oilItem.oilID;
        localOil.price = oilItem.price;
        localOil.time = oilItem.time;
        localOil.typeName = oilItem.typeName;
        localOil.updateTime = oilItem.updateTime;
        localOil.stationName = oilItem.stationName;
        localOil.isSubmit = oilItem.isSubmit;
        localOil.dataType = oilItem.dataType;
    } completion:completion];
}

+ (NSArray *)fetchAllOil:(BOOL)ascending {
    return [Oil MR_findAllSortedBy:@"time" ascending:ascending];
}

+ (Oil *)fetchOilByOilID:(NSString *)oilID {
    return [Oil MR_findFirstByAttribute:@"oilID" withValue:oilID];
}

+ (NSArray *)fetchOilByOilSubmit:(BOOL)isSubmit {
    return [Oil MR_findByAttribute:@"isSubmit" withValue:[NSNumber numberWithBool:isSubmit]];
}

+ (NSArray *)fetchOilByVehicleID:(NSString *)vehicleID ascending:(BOOL)ascending {
    Vehicle *vehicle = [self fetchVehicelByVehicleID:vehicleID];
    NSArray *oilArray = [NSArray arrayWithArray:vehicle.hasOil.allObjects];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:ascending];
    oilArray = [oilArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    return oilArray;
}

+ (NSArray *)fetchOilByVehicleID:(NSString *)vehicleID isSubmit:(BOOL)isSubmit ascending:(BOOL)ascending {
    Vehicle *vehicle = [self fetchVehicelByVehicleID:vehicleID];
    NSArray *oilArray = [NSArray arrayWithArray:vehicle.hasOil.allObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSubmit == %@", [NSNumber numberWithBool:isSubmit]];
    oilArray = [oilArray filteredArrayUsingPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:ascending];
    oilArray = [oilArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    return oilArray;
}

+ (void)importOilTotalFromArray:(NSArray *)dataArray completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        [OilTotal MR_deleteAllMatchingPredicate:nil inContext:localContext];
        [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dataDictionary = (NSDictionary *)obj;
            NSString *vehicleID = [dataDictionary objectForKey:@"vehicle_id"];
            Vehicle *localVehicle = [Vehicle MR_findFirstByAttribute:@"vehicleID" withValue:vehicleID inContext:localContext];
            [localVehicle.hasOilTotal MR_deleteInContext:localContext];
            OilTotal *oilTotal = [OilTotal MR_importFromObject:dataDictionary inContext:localContext];
            localVehicle.hasOilTotal = oilTotal;
        }];
    } completion:completion];
}

+ (NSArray *)fetchAllOilTotal {
    return [OilTotal MR_findAll];
}

+ (OilTotal *)fetchOilTotalByVehicleID:(NSString *)vehicleID {
    return [OilTotal MR_findFirstByAttribute:@"vehicleID" withValue:vehicleID];
}

+ (void)importOrgFromArray:(NSArray *)dataArray completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        [Org MR_importFromArray:dataArray inContext:localContext];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT(orgID IN %@)", [dataArray valueForKeyPath:@"org_id"]];
        [Org MR_deleteAllMatchingPredicate:predicate inContext:localContext];
    } completion:completion];
}

+ (NSArray *)fetchAllOrg {
    return [Org MR_findAll];
}

+ (Org *)fetchOrgByOrgID:(NSString *)orgID {
    return [Org MR_findFirstByAttribute:@"orgID" withValue:orgID];
}

+ (void)addVehicleIDToOrgByOrgID:(NSString *)orgID vehicleID:(NSString *)vehicleID completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        Org *localOrg = [Org MR_findFirstByAttribute:@"orgID" withValue:orgID inContext:localContext];
        NSMutableArray *vehicleArray = [NSMutableArray arrayWithArray:localOrg.vehicleList];
        [vehicleArray addObject:vehicleID];
        localOrg.vehicleList = vehicleArray;
    } completion:completion];
}

+ (void)removeVehicleIDToOrgByOrgID:(NSString *)orgID vehicleID:(NSString *)vehicleID completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        Org *localOrg = [Org MR_findFirstByAttribute:@"orgID" withValue:orgID inContext:localContext];
        NSMutableArray *vehicleArray = [NSMutableArray arrayWithArray:localOrg.vehicleList];
        [vehicleArray removeObject:vehicleID];
        localOrg.vehicleList = vehicleArray;
    } completion:completion];
}

+ (void)importOrgMessageFromArray:(NSArray *)dataArray completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        //[OrgMessage MR_deleteAllMatchingPredicate:nil inContext:localContext];
        NSArray *orgMessageArray = [OrgMessage MR_findByAttribute:@"isRead" withValue:orgMessageHasRead inContext:localContext];
        NSArray *orgMessageIDArray = [orgMessageArray valueForKeyPath:@"orgMessageID"];
        [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dataDictionary = (NSDictionary *)obj;
            NSString *orgID = [dataDictionary objectForKey:@"org_id"];
            
            Org *localOrg = [Org MR_findFirstByAttribute:@"orgID" withValue:orgID inContext:localContext];
            OrgMessage *orgMessage = [OrgMessage MR_importFromObject:dataDictionary inContext:localContext];
            if ([orgMessageIDArray containsObject:orgMessage.orgMessageID]) {
                orgMessage.isRead = orgMessageHasRead;
            }
            NSMutableSet *orgMessageSet = nil;
            if (localOrg.hasOrgMessage == nil) {
                orgMessageSet = [NSMutableSet setWithCapacity:1];
            }
            else {
                orgMessageSet = [NSMutableSet setWithSet:localOrg.hasOrgMessage];
            }
            [orgMessageSet addObject:orgMessage];
            localOrg.hasOrgMessage = orgMessageSet;
        }];
        
        NSString *lastUpdateTime = [[OrgMessage MR_findAllInContext:localContext] valueForKeyPath:@"@max.updateTime"];
        RequestInfo *localRequestInfo = [[self fetchRequestInfo] MR_inContext:localContext];
        localRequestInfo.orgMessageLastUpdateTime = lastUpdateTime;
    } completion:completion];
}

+ (NSArray *)fetchAllOrgMessage:(BOOL)ascending {
    NSArray *orgMessageArray = [OrgMessage MR_findAll];
    NSSortDescriptor *orgMessageSort = [NSSortDescriptor sortDescriptorWithKey:@"updateTime" ascending:ascending];
    orgMessageArray = [orgMessageArray sortedArrayUsingDescriptors:@[orgMessageSort]];
    
    return orgMessageArray;
}

+ (void)removeAllOrgMessage:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        [OrgMessage MR_deleteAllMatchingPredicate:nil inContext:localContext];
    } completion:completion];
}

+ (OrgMessage *)fetchOrgMessageByOrgMessageID:(NSString *)orgMessageID {
    return [OrgMessage MR_findFirstByAttribute:@"orgMessageID" withValue:orgMessageID];
}

+ (NSArray *)fetchOrgMessageByOrgID:(NSString *)orgID ascending:(BOOL)ascending {
    Org *org = [self fetchOrgByOrgID:orgID];
    NSArray *orgMessageArray = [NSArray arrayWithArray:org.hasOrgMessage.allObjects];
    NSSortDescriptor *orgMessageSort = [NSSortDescriptor sortDescriptorWithKey:@"updateTime" ascending:ascending];
    orgMessageArray = [orgMessageArray sortedArrayUsingDescriptors:@[orgMessageSort]];
    return orgMessageArray;
}

+ (NSInteger)fetchNotReadOrgMessageCount {
    return [[OrgMessage MR_findByAttribute:@"isRead" withValue:orgMessageNotRead] count];
}

+ (OrgMessage *)fetchLastestOrgMessageByOrgID:(NSString *)orgID {
    NSArray *orgMessageArray = [self fetchOrgMessageByOrgID:orgID ascending:NO];
    if (orgMessageArray.count > 0) {
        return [orgMessageArray firstObject];
    }
    return nil;
}

+ (void)updateOrgMessageStatusByOrgMessageID:(NSString *)orgMessageID completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        OrgMessage *localOrgMessage = [OrgMessage MR_findFirstByAttribute:@"orgMessageID" withValue:orgMessageID inContext:localContext];
        localOrgMessage.isRead = orgMessageHasRead;
    } completion:completion];
}

+ (void)importTaskFromArray:(NSArray *)dataArray completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        //[Task MR_deleteAllMatchingPredicate:nil inContext:localContext];
        [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dataDictionary = (NSDictionary *)obj;
            NSString *orgID = [dataDictionary objectForKey:@"org_id"];
            
            Task *task = [Task MR_importFromObject:dataDictionary inContext:localContext];
            Org *localOrg = [Org MR_findFirstByAttribute:@"orgID" withValue:orgID inContext:localContext];
            NSMutableSet *taskSet = nil;
            if (localOrg.hasTask == nil) {
                taskSet = [NSMutableSet setWithCapacity:1];
            }
            else {
                taskSet = [NSMutableSet setWithSet:localOrg.hasTask];
            }
            [taskSet addObject:task];
            localOrg.hasTask = taskSet;
        }];
        NSString *lastUpdateTime = [[Task MR_findAllInContext:localContext] valueForKeyPath:@"@max.updateTime"];
        RequestInfo *localRequestInfo = [[self fetchRequestInfo] MR_inContext:localContext];
        localRequestInfo.taskLastUpdateTime = lastUpdateTime;
    } completion:completion];
}

+ (NSDictionary *)fetchTaskCountDictionary {
    NSDictionary *countDictionary = @{[NSNumber numberWithInteger:TaskStatusSpot] : [DataFetcher fetchTaskNumberByStatus:TaskStatusSpot], [NSNumber numberWithInteger:TaskStatusUnderWay] : [DataFetcher fetchTaskNumberByStatus:TaskStatusUnderWay], [NSNumber numberWithInteger:TaskStatusFinished] : [DataFetcher fetchTaskNumberByStatus:TaskStatusFinished], [NSNumber numberWithInteger:TaskStatusCancle] : [DataFetcher fetchTaskNumberByStatus:TaskStatusCancle], [NSNumber numberWithInteger:TaskStatusAll] : [DataFetcher fetchTaskNumberByStatus:TaskStatusAll]};
    
    return countDictionary;
}

+ (void)removeAllTask:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        [Task MR_deleteAllMatchingPredicate:nil inContext:localContext];
    } completion:completion];
}

+ (Task *)fetchLastestTask {
    NSArray *allTask = [self fetchAllTask:NO];
    if (allTask.count > 0) {
        return [allTask firstObject];
    }
    return nil;
}

+ (void)updateTaskStatusByTaskID:(NSString *)taskID status:(TaskStatus)status completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        Task *localTask = [Task MR_findFirstByAttribute:@"taskID" withValue:taskID inContext:localContext];
        localTask.status = [NSString stringWithFormat:@"%@", @(status).stringValue];
    } completion:completion];
}

+ (NSArray *)fetchAllTask:(BOOL)ascending {
    NSArray *resultSpot=nil;
    NSArray *resultUnderway=nil;
    NSArray *resultFinished=nil;
    NSMutableArray *resultArray=nil;
    resultArray=[[NSMutableArray alloc]init];
    resultSpot = [Task MR_findByAttribute:@"status" withValue:[NSNumber numberWithInteger:TaskStatusSpot] andOrderBy:@"updateTime" ascending:ascending];
    resultUnderway = [Task MR_findByAttribute:@"status" withValue:[NSNumber numberWithInteger:TaskStatusUnderWay] andOrderBy:@"updateTime" ascending:ascending];
    resultFinished = [Task MR_findByAttribute:@"status" withValue:[NSNumber numberWithInteger:TaskStatusFinished] andOrderBy:@"updateTime" ascending:ascending];
    [resultArray addObjectsFromArray:resultSpot];
    [resultArray addObjectsFromArray:resultUnderway];
    [resultArray addObjectsFromArray:resultFinished];

    return resultArray;
//    return [Task MR_findAllSortedBy:@"status" ascending:ascending];
}

+ (Task *)fetchTaskByTaskID:(NSString *)taskID {
    return [Task MR_findFirstByAttribute:@"taskID" withValue:taskID];
}

+ (NSArray *)fetchTaskByStatus:(TaskStatus)status ascending:(BOOL)ascending {
    NSArray *resultArray = nil;
    if (status == TaskStatusAll) {
        resultArray = [self fetchAllTask:ascending];
    }
    else {
        resultArray = [Task MR_findByAttribute:@"status" withValue:[NSNumber numberWithInteger:status] andOrderBy:@"updateTime" ascending:ascending];
    }
    return resultArray;
}

+ (NSUInteger)fetchTaskCountByStatus:(TaskStatus)status {
    NSUInteger count = 0;
    if (status == TaskStatusAll) {
        count = [Task MR_countOfEntities];
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status == %d", status];
        count = [Task MR_countOfEntitiesWithPredicate:predicate];
    }
    return count;
}

+ (NSNumber *)fetchTaskNumberByStatus:(TaskStatus)status {
    NSNumber *number = nil;
    if (status == TaskStatusAll) {
        number = [Task MR_numberOfEntities];
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status == %d", status];
        number = [Task MR_numberOfEntitiesWithPredicate:predicate];
    }
    return number;
}

+ (NSString *)fetchTaskLastUpdateTime {
    NSString *time = [[self fetchRequestInfo] taskLastUpdateTime];
    if (time == nil) {
        time = DEFAULT_UPDATE_TIME;
    }
    return time;
}

+ (NSString *)fetchOrgMessageLastUpdateTime {
    NSString *time = [[self fetchRequestInfo] orgMessageLastUpdateTime];
    if (time == nil) {
        time = DEFAULT_UPDATE_TIME;
    }
    return time;
}

+ (NSString *)fetchOilLastUpdateTimeByVehicleID:(NSString *)vehicleID {
    NSString *time = [[self fetchVehicelByVehicleID:vehicleID] oilLastUpdateTime];
    if (time == nil) {
        time = DEFAULT_UPDATE_TIME;
    }
    return time;
}

+ (void)addStationByStationItem:(StationItem *)stationItem completion:(void(^)(void))completion {
    Station *station = [Station MR_findFirstByAttribute:@"name" withValue:stationItem.name];
    if (station == nil && [CommonFunctionController checkValueValidate:stationItem.name] != nil) {
        [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
            Station *localStation = [Station MR_createInContext:localContext];
            localStation.name = stationItem.name;
            localStation.lat = stationItem.lat;
            localStation.lng = stationItem.lng;
        } completion:completion];
    }
    else {
        completion();
    }
}

+ (NSArray *)fetchAllStation {
    return [Station MR_findAll];
}

+ (void)removeStationByStation:(Station *)station completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        Station *localStation = [station MR_inContext:localContext];
        [localStation MR_deleteInContext:localContext];
    } completion:completion];
}

+ (void)addOilTypeByOilTypeItem:(OilTypeItem *)oilTypeItem completion:(void(^)(void))completion {
    OilType *oilType = [OilType MR_findFirstByAttribute:@"name" withValue:oilTypeItem.name];
    if (oilType == nil && [CommonFunctionController checkValueValidate:oilTypeItem.name] != nil) {
        [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
            OilType *localOilType = [OilType MR_createInContext:localContext];
            localOilType.name = oilTypeItem.name;
        } completion:completion];
    }
    else {
        completion();
    }
}

+ (NSArray *)fetchAllOilType {
    return [OilType MR_findAll];
}

+ (void)removeOilTypeByOilType:(OilType *)oilType completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        OilType *localOilType = [oilType MR_inContext:localContext];
        [localOilType MR_deleteInContext:localContext];
    } completion:completion];
}

+ (void)removeOrgByOrgID:(NSString *)orgID completion:(void(^)(void))completion {
    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orgID == %@", orgID];
        [Org MR_deleteAllMatchingPredicate:predicate inContext:localContext];
    } completion:completion];
}

@end
