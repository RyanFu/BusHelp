//
//  NetStationService.h
//  HigerStation
//
//  Created by KevinMao on 15/3/18.
//  Copyright (c) 2015年 Higer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetBaseService.h"
#import "m_station.h"
#import "m_column.h"

@interface NetStationService : NetBaseService

- (void)requestGetStationList:(NSString *)user_lng
                     user_lat:(NSString *)user_lat
                      success:(void (^)(int code, NSString *msg, NSArray *station_list))success
                        error:(void (^)(int code, NSString *msg))error;

- (void)requestGetStationDetails:(NSString *)station_id
                         success:(void (^)(int code, NSString *msg, m_station *station))success
                           error:(void (^)(int code, NSString *msg))error;


@end
