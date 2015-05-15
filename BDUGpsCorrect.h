//
//  BDUGpsCorrect.h
//  BusQuery
//
//  Created by Tony Zeng on 6/17/14.
//  Copyright (c) 2014 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BDUGPSCORRECT_KEY_DICT_RESULT_LAT @"BDUGpsCorrect_Key_Dict_Result_Lat"
#define BDUGPSCORRECT_KEY_DICT_RESULT_LON @"BDUGpsCorrect_Key_Dict_Result_Lon"

@interface BDUGpsCorrect : NSObject

+ (NSDictionary *)transformWithOriLat:(double)oriLat withOriLon:(double)oriLon;

@end
