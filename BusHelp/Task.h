//
//  Task.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/6.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Org;

@interface Task : NSManagedObject

@property (nonatomic, retain) id attachmentList;
@property (nonatomic, retain) NSString * beginTime;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) NSString * helper;
@property (nonatomic, retain) NSString * manager;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * taskID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * updateTime;
@property (nonatomic, retain) Org *belongsToOrg;

@end
