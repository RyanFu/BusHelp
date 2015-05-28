//
//  BaseViewController.m
//  HigerGbos
//
//  Created by KevinMao on 14-5-21.
//  Copyright (c) 2014年 Jijesoft. All rights reserved.
//

#import "StationBaseViewController.h"

@interface StationBaseViewController ()

@end

@implementation StationBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;

}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//    //return UIInterfaceOrientationMaskPortrait ^ UIInterfaceOrientationMaskPortraitUpsideDown;
//}
//
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 公共处理方法

- (void)alert:(NSString *)message view:(UIView *)view
{
    [self alert:message view:view animated:YES afterDelay:1.0 completion:nil];
}
- (void)alert:(NSString *)message view:(UIView *)view animated:(BOOL)animated
{
    [self alert:message view:view animated:animated afterDelay:1.0 completion:nil];
}
- (void)alert:(NSString *)message view:(UIView *)view animated:(BOOL)animated afterDelay:(float)afterDelay
{
    [self alert:message view:view animated:animated afterDelay:afterDelay completion:nil];
}
- (void)alert:(NSString *)message view:(UIView *)view animated:(BOOL)animated afterDelay:(float)afterDelay completion:(void (^)(void))completion
{
    if (!self.hud) {
        self.hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
        self.hud.delegate = self;
    }
    self.hud.mode = MBProgressHUDModeText;
    self.hud.labelText = message;
    [self.hud hide:animated afterDelay:afterDelay];
}

- (void)alertSuccess:(NSString *)message view:(UIView *)view
{
    [self alertSuccess:message view:view animated:YES afterDelay:1.0 completion:nil];
}
- (void)alertSuccess:(NSString *)message view:(UIView *)view animated:(BOOL)animated
{
    [self alertSuccess:message view:view animated:animated afterDelay:1.0 completion:nil];
}
- (void)alertSuccess:(NSString *)message view:(UIView *)view animated:(BOOL)animated afterDelay:(float)afterDelay
{
    [self alertSuccess:message view:view animated:animated afterDelay:afterDelay completion:nil];
}
- (void)alertSuccess:(NSString *)message view:(UIView *)view animated:(BOOL)animated afterDelay:(float)afterDelay completion:(void (^)(void))completion
{
    if (!self.hud) {
        self.hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
        self.hud.delegate = self;
    }
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.customView = [self getSuccessMessageView];
    self.hud.labelText = message;
    [self.hud hide:animated afterDelay:afterDelay];
}

- (void)alertError:(NSString *)message view:(UIView *)view
{
    [self alertError:message view:view animated:YES afterDelay:1.0 completion:nil];
}
- (void)alertError:(NSString *)message view:(UIView *)view animated:(BOOL)animated
{
    [self alertError:message view:view animated:animated afterDelay:1.0 completion:nil];
}
- (void)alertError:(NSString *)message view:(UIView *)view animated:(BOOL)animated afterDelay:(float)afterDelay
{
    [self alertError:message view:view animated:animated afterDelay:afterDelay completion:nil];
}
- (void)alertError:(NSString *)message view:(UIView *)view animated:(BOOL)animated afterDelay:(float)afterDelay completion:(void (^)(void))completion
{
    if (!self.hud) {
        self.hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
        self.hud.delegate = self;
    }
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.customView = [self getErrorMessageView];
    self.hud.labelText = message;
    [self.hud hide:animated afterDelay:afterDelay];
}

- (void)showWait:(NSString *)message view:(UIView *)view
{
    [self showWait:message view:view animated:YES completion:nil];
}
- (void)showWait:(NSString *)message view:(UIView *)view animated:(BOOL)animated
{
    [self showWait:message view:view animated:animated completion:nil];
}
- (void)showWait:(NSString *)message view:(UIView *)view animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (!self.hud) {
        self.hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
        self.hud.delegate = self;
    }
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = message;
    if (completion) {
        completion();
    }
}

- (void)hideWait
{
    [self hideWait:YES afterDelay:0.0 completion:nil];
}
- (void)hideWait:(BOOL)animated afterDelay:(float)afterDelay
{
    [self hideWait:animated afterDelay:afterDelay completion:nil];
}
- (void)hideWait:(BOOL)animated afterDelay:(float)afterDelay completion:(void (^)(void))completion
{
    if (self.hud) {
        [self.hud hide:animated afterDelay:afterDelay];
    }
}

- (UIImageView *)getSuccessMessageView
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg-success"]];
}

- (UIImageView *)getErrorMessageView
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg-prompt"]];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if (self.hud) {
        [self.hud removeFromSuperview];
        self.hud.delegate = nil;
        self.hud = nil;
    }
}

@end





