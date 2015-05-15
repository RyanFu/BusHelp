//
//  BDUGpsCorrect.m
//  BusQuery
//
//  Created by Tony Zeng on 6/17/14.
//  Copyright (c) 2014 Tony. All rights reserved.
//

#import "BDUGpsCorrect.h"

#define pi 3.14159265358979324
#define a 6378245.0
#define ee 0.00669342162296594323

@implementation BDUGpsCorrect

+ (NSDictionary *)transformWithOriLat:(double)oriLat withOriLon:(double)oriLon {
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    if ([self outOfChinaWithOriLat:oriLat withOriLon:oriLon]){
        [dict setObject:[NSNumber numberWithDouble:oriLat] forKey:BDUGPSCORRECT_KEY_DICT_RESULT_LAT];
        [dict setObject:[NSNumber numberWithDouble:oriLon] forKey:BDUGPSCORRECT_KEY_DICT_RESULT_LON];
        return dict;
    }
    
    
    double dLat = [self transformLatWithOriLat:oriLat-35.0 withOriLon:oriLon-105.0];
    double dLon = [self transformLonWithOriLat:oriLat-35.0 withOriLon:oriLon-105.0];
    double radLat = oriLat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    [dict setObject:[NSNumber numberWithDouble:oriLat+dLat] forKey:BDUGPSCORRECT_KEY_DICT_RESULT_LAT];
    [dict setObject:[NSNumber numberWithDouble:oriLon+dLon] forKey:BDUGPSCORRECT_KEY_DICT_RESULT_LON];
    return dict;
}

+ (BOOL)outOfChinaWithOriLat:(double)oriLat withOriLon:(double)oriLon {
    if (oriLon<72.004 || oriLon>137.8347){
        return YES;
    }
    if (oriLat < 0.8293 || oriLat > 55.8271)
        return YES;
    return NO;
}

+ (double)transformLatWithOriLat:(double)oriLat withOriLon:(double)oriLon {
    
    double ret = -100.0 + 2.0 * oriLon + 3.0 * oriLat + 0.2 * oriLat * oriLat + 0.1 * oriLon * oriLat + 0.2 * sqrt(abs(oriLon));
    ret += (20.0 * sin(6.0 * oriLon * pi) + 20.0 * sin(2.0 * oriLon * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(oriLat * pi) + 40.0 * sin(oriLat / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(oriLat / 12.0 * pi) + 320 * sin(oriLat * pi / 30.0)) * 2.0 / 3.0;
    return ret;
}

+ (double)transformLonWithOriLat:(double)oriLat withOriLon:(double)oriLon {
    
    double ret = 300.0 + oriLon + 2.0 * oriLat + 0.1 * oriLon * oriLon + 0.1 * oriLon * oriLat + 0.1 * sqrt(abs(oriLon));
    ret += (20.0 * sin(6.0 * oriLon * pi) + 20.0 * sin(2.0 * oriLon * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(oriLon * pi) + 40.0 * sin(oriLon / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(oriLon / 12.0 * pi) + 300.0 * sin(oriLon / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
}

@end
