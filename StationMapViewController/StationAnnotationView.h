//
//  StationAnnotationView.h
//  HigerStation
//
//  Created by KevinMao on 15/3/18.
//  Copyright (c) 2015年 Higer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface StationAnnotationView : MKAnnotationView

@property (nonatomic, strong) UIView *contentView;

- (void)drawInContext:(CGContextRef)context;
- (void)getDrawPath:(CGContextRef)context;

@end
