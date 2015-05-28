//
//  UrlParaInfo.h
//  HigerGbos
//
//  Created by KevinMao on 14-6-11.
//  Copyright (c) 2014年 Jijesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlParaInfo : NSObject

+ (NSMutableDictionary *)getStationList:(NSString *)user_lng user_lat:(NSString *)user_lat; //获取充电站列表

+ (NSMutableDictionary *)getStationDetails:(NSString *)station_id; //获取充电站详情

@end
