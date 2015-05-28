//
//  BaseInfo.h
//  SaicMotorSystem
//
//  Created by KevinMao on 14/12/18.
//  Copyright (c) 2014年 SaicMotor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MessageInfo.h"
#import "m_station.h"
#import "m_column.h"
#import "NetStationService.h"

@interface BaseInfo : NSObject

+ (BOOL)isDebug;

+ (double)calculateDistance:(double)srcLng srcLat:(double)srcLat desLng:(double)desLng desLat:(double)desLat;

+ (NSArray *)getMapAppList:(CLLocationCoordinate2D)startCoordinate endCoor:(CLLocationCoordinate2D)endCoordinate addressName:(NSString *)addressName;

@end
