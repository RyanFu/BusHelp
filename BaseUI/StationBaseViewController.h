//
//  BaseViewController.h
//  HigerGbos
//
//  Created by KevinMao on 14-5-21.
//  Copyright (c) 2014年 Jijesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface StationBaseViewController : UIViewController<MBProgressHUDDelegate>

@property (nonatomic, strong) MBProgressHUD *hud;

- (void)alert:(NSString *)message view:(UIView *)view;
- (void)alert:(NSString *)message view:(UIView *)view animated:(BOOL)animated;
- (void)alert:(NSString *)message view:(UIView *)view animated:(BOOL)animated afterDelay:(float)afterDelay;
- (void)alert:(NSString *)message view:(UIView *)view animated:(BOOL)animated afterDelay:(float)afterDelay completion:(void (^)(void))completion;

- (void)alertSuccess:(NSString *)message view:(UIView *)view;
- (void)alertSuccess:(NSString *)message view:(UIView *)view animated:(BOOL)animated;
- (void)alertSuccess:(NSString *)message view:(UIView *)view animated:(BOOL)animated afterDelay:(float)afterDelay;
- (void)alertSuccess:(NSString *)message view:(UIView *)view animated:(BOOL)animated afterDelay:(float)afterDelay completion:(void (^)(void))completion;

- (void)alertError:(NSString *)message view:(UIView *)view;
- (void)alertError:(NSString *)message view:(UIView *)view animated:(BOOL)animated;
- (void)alertError:(NSString *)message view:(UIView *)view animated:(BOOL)animated afterDelay:(float)afterDelay;
- (void)alertError:(NSString *)message view:(UIView *)view animated:(BOOL)animated afterDelay:(float)afterDelay completion:(void (^)(void))completion;

- (void)showWait:(NSString *)message view:(UIView *)view;
- (void)showWait:(NSString *)message view:(UIView *)view animated:(BOOL)animated;
- (void)showWait:(NSString *)message view:(UIView *)view animated:(BOOL)animated completion:(void (^)(void))completion;

- (void)hideWait;
- (void)hideWait:(BOOL)animated afterDelay:(float)afterDelay;
- (void)hideWait:(BOOL)animated afterDelay:(float)afterDelay completion:(void (^)(void))completion;

@end
