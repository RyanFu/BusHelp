//
//  UIView+Screenshot.h
//  BookIntroduction
//
//  Created by 夜枫尘 on 15/1/12.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (custome)

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)frameX;
- (CGFloat)frameY;
- (CGFloat)centerX;
- (CGFloat)centerY;
- (CGFloat)minWidthAndHeight;
- (CGFloat)maxWidthAndHeight;

- (UIImage *)convertViewToImage;
- (void)removeAllSubLayer;

+ (id)loadFromNib;
+ (id)loadFromNibNamed:(NSString *)nibName;
+ (id)loadFromNibNoOwner;

- (void)showHUDWithMessage:(NSString *)message success:(BOOL)success;
- (void)showAnimateHUDWithMessage:(NSString *)message;
- (void)showHUDWithMessage:(NSString *)message detail:(NSString *)detail;
- (void)hideAllHUD;

- (UIViewController *)firstAvailableUIViewController;

@end
