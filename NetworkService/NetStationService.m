//
//  NetStationService.m
//  HigerStation
//
//  Created by KevinMao on 15/3/18.
//  Copyright (c) 2015年 Higer. All rights reserved.
//

#import "NetStationService.h"
#import "MessageInfo.h"
#import "UrlInfo.h"
#import "UrlParaInfo.h"

@implementation NetStationService

- (void)requestGetStationList:(NSString *)user_lng user_lat:(NSString *)user_lat success:(void (^)(int, NSString *, NSArray *))success error:(void (^)(int, NSString *))error
{
    NSString *url = [UrlInfo getStationList];
    NSMutableDictionary *parameters = [UrlParaInfo getStationList:user_lng user_lat:user_lat];
    
    [self post:url parameters:parameters success:^(int code, NSString *msg, id data) {
        NSArray *list = [m_station convertJsonToList:data];
        success(code, msg, list);
    } error:^(int code, NSString *msg) {
        error(code, msg);
    } failure:^(NSError *failure) {
        error(1, MSG_ALERT_NET_FAILURE);
    }];
}

- (void)requestGetStationDetails:(NSString *)station_id success:(void (^)(int, NSString *, m_station *))success error:(void (^)(int, NSString *))error
{
    NSString *url = [UrlInfo getStationDetails];
    NSMutableDictionary *parameters = [UrlParaInfo getStationDetails:station_id];
    
    [self post:url parameters:parameters success:^(int code, NSString *msg, id data) {
        m_station *model = [m_station convertJsonToModel:data];
        success(code, msg, model);
    } error:^(int code, NSString *msg) {
        error(code, msg);
    } failure:^(NSError *failure) {
        error(1, MSG_ALERT_NET_FAILURE);
    }];
}

@end
