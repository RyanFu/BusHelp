//
//  MileageDataRequest.h
//  BusHelp
//
//  Created by Paul on 15/5/14.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MileageDataRequest : NSObject
@property(nonatomic,strong)NSDictionary *resultdic;
+(MileageDataRequest *)shareinstance;
-(void)fetchVehicleMonthList:(NSString *)vehicle_ids month:(NSString *)month org_id:(NSString *)org_id;

@end
