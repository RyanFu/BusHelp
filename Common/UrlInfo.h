//
//  UrlInfo.h
//  HigerGbos
//
//  Created by KevinMao on 14-6-5.
//  Copyright (c) 2014年 Jijesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlInfo : NSObject

+ (NSString *)getStationList; //获取充电站列表
+ (NSString *)getStationDetails; //获取充电站详情

@end
