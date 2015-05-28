//
//  UrlParaInfo.m
//  HigerGbos
//
//  Created by KevinMao on 14-6-11.
//  Copyright (c) 2014年 Jijesoft. All rights reserved.
//

#import "UrlParaInfo.h"

@implementation UrlParaInfo

+ (NSMutableDictionary *)getStationList:(NSString *)user_lng user_lat:(NSString *)user_lat
{
    return [[NSMutableDictionary alloc] initWithObjectsAndKeys:
            user_lng, @"user_lng",
            user_lat, @"user_lat", nil];
}

+ (NSMutableDictionary *)getStationDetails:(NSString *)station_id
{
    return [[NSMutableDictionary alloc] initWithObjectsAndKeys:
            station_id, @"station_id", nil];
}

@end







