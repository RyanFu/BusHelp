//
//  OrgMessage.h
//  BusHelp
//
//  Created by Paul on 15/6/18.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Org;

@interface OrgMessage : NSManagedObject

@property (nonatomic, retain) NSString * action;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * isRead;
@property (nonatomic, retain) NSString * orgMessageID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * updateTime;
@property (nonatomic, retain) NSString * urlPath;
@property (nonatomic, retain) Org *belongsToOrg;

@end
