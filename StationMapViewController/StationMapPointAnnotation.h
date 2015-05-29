//
//  StationMapPointAnnotation.h
//  HigerStation
//
//  Created by KevinMao on 15/3/18.
//  Copyright (c) 2015年 Higer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseInfo.h"
#import <MapKit/MapKit.h>

@interface StationMapPointAnnotation : MKPointAnnotation

@property (nonatomic, strong) m_station *station;

@end
