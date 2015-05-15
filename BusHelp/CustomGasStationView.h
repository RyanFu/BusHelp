//
//  CustomGasStationView.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/2.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ViewTypeStation,
    ViewTypeOil,
    ViewTypeOrgSearch,
} ViewType;

@interface CustomGasStationView : UIView

@property (nonatomic, assign) ViewType type;

@property (copy, nonatomic) void (^confirmButtonPressedBlock)(NSString *stationName, ViewType type);

- (void)showInView:(UIView *)view;

@end
