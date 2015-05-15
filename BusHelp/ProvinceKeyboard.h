//
//  ProvinceKeyboard.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/13.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvinceKeyboard : UIView

+ (void)showWithBlock:(void(^)(NSString *name))block;
+ (void)hide;

@end
