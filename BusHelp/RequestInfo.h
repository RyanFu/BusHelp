//
//  RequestInfo.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/5.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RequestInfo : NSManagedObject

@property (nonatomic, retain) NSString * orgLastUpdateTime;
@property (nonatomic, retain) NSString * orgMessageLastUpdateTime;
@property (nonatomic, retain) NSString * taskLastUpdateTime;

@end
