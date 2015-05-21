//
//  CoreDataConfig.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/4.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

static NSString * const orgMessageHasRead = @"Y";
static NSString * const orgMessageNotRead = @"N";
static NSString * const responseNotificationKey = @"responseNotificationKey";
static NSString * const updateBadgeValueKey = @"updateBadgeValueKey";
static NSString * const dismissLoginKey = @"dismissLoginKey";
static NSString * const refreshDataKey = @"refreshDataKey";
static NSString * const searchNotificationKey = @"searchNotificationKey";
static NSString * const againNeedLoginKey = @"againNeedLoginKey";

typedef enum : NSUInteger {
    OrgUserTypeCreater = 1001,
    OrgUserTypeAdmin = 1002,
    OrgUserTypeUser = 1003,
} OrgUserType;

typedef enum : NSUInteger {
    TaskStatusSpot = 1001,
    TaskStatusUnderWay = 1002,
    TaskStatusFinished = 1003,
    TaskStatusCancle = 1004,
    TaskStatusAll,
} TaskStatus;

typedef enum : NSUInteger {
    OrgActionAgree = 200101,
    OrgActionDisagree = 200102,
    OrgApplyActionAgree = 300101,
    OrgApplyActionDisagree = 300102,
} OrgAction;

typedef enum : NSUInteger {
    ShieldActionConfirm = 1001,
    ShieldActionCancle = 1002,
} ShieldAction;

typedef enum : NSUInteger {
    OilDataTypeCommitted = 1000,
    OilDataTypeAddUncommitted = 1001,
    OilDataTypeModifyUncommitted = 1002,
} OilDataType;

typedef enum : NSUInteger {
    VehicleNumberTypeSmall = 1001,
    VehicleNumberTypeLarge = 1002,
} VehicleNumberType;

typedef enum : NSUInteger {
    OrgMessageTypeCommon = 1001,
    OrgMessageTypeInvite = 2001,
    OrgMessageTypeApply = 3001,
    OrgMessageTypeManual = 4001,
} OrgMessageType;

typedef enum : NSUInteger {
    OrgStatusInviting = 1001,
    OrgStatusJoined = 1002,
    OrgStatusApplying = 1003,
} OrgStatus;

typedef enum : NSUInteger {
    NotificationContentTypeViolation = 1001,
    NotificationContentTypeTask = 1002,
    NotificationContentTypeMessage = 1003,
} NotificationContentType;

typedef enum : NSUInteger {
    AuthenticationTypeIn = 2001,
    AuthenticationTypeAlready = 3001,
    AuthenticationTypeHiger = 4001,
} AuthenticationType;




