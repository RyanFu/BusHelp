//
//  Month.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/5.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OilTotal;

@interface Month : NSManagedObject

@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) OilTotal *belongsToOilTotal;

@end
