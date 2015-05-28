//
//  BaseInfo.m
//  SaicMotorSystem
//
//  Created by KevinMao on 14/12/18.
//  Copyright (c) 2014年 SaicMotor. All rights reserved.
//

#import "BaseInfo.h"

@implementation BaseInfo

+ (BOOL)isDebug
{
    return YES;
}

+ (double)calculateDistance:(double)srcLng srcLat:(double)srcLat desLng:(double)desLng desLat:(double)desLat
{
    CLLocation *srcLocation=[[CLLocation alloc] initWithLatitude:srcLat longitude:srcLng];
    CLLocation *desLocation=[[CLLocation alloc] initWithLatitude:desLat longitude:desLng];
    CLLocationDistance distance = [srcLocation distanceFromLocation:desLocation];
    return distance;
}

+ (NSArray *)getMapAppList:(CLLocationCoordinate2D)startCoordinate endCoor:(CLLocationCoordinate2D)endCoordinate addressName:(NSString *)addressName
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=driving&src=海格汽车|E动无忧", startCoordinate.latitude, startCoordinate.longitude, endCoordinate.latitude, endCoordinate.longitude, addressName];
        NSDictionary *dictionary = @{@"name": @"百度地图", @"url": urlString};
        [array addObject:dictionary];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=E动无忧&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=3", endCoordinate.latitude, endCoordinate.longitude];
        NSDictionary *dictionary = @{@"name": @"高德地图", @"url": urlString};
        [array addObject:dictionary];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%f,%f¢er=%f,%f&directionsmode=transit", endCoordinate.latitude, endCoordinate.longitude, startCoordinate.latitude, startCoordinate.longitude];
        NSDictionary *dictionary = @{@"name": @"谷歌地图", @"url": urlString};
        [array addObject:dictionary];
    }
    
    return array;
}

@end
