//
//  UrlInfo.m
//  HigerGbos
//
//  Created by KevinMao on 14-6-5.
//  Copyright (c) 2014年 Jijesoft. All rights reserved.
//

#import "UrlInfo.h"

static NSString *URL_BASE = @"http://www.g-bos.cn/system/chargingStation";
//static NSString *URL_BASE = @"http://www.g-bos.cn:7071/system/chargingStation";

@implementation UrlInfo

+ (NSString *)getStationList
{
    NSString *method = @"/getStationList";
    return [NSString stringWithFormat:@"%@%@", URL_BASE, method];
}

+ (NSString *)getStationDetails
{
    NSString *method = @"/getStationDetails";
    return [NSString stringWithFormat:@"%@%@", URL_BASE, method];
}

@end
