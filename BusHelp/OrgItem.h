//
//  OrgItem.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/13.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrgItem : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * orgID;
@property (nonatomic, strong) id vehicleList;
@property (nonatomic, strong) NSSet *hasOrgMessage;
@property (nonatomic, strong) NSSet *hasTask;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *orgDescription;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *userType;

@end
