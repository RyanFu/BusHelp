//
//  UIView+Screenshot.m
//  BookIntroduction
//
//  Created by 夜枫尘 on 15/1/12.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "UIView+custom.h"
#import "FileOwner.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MBProgressHUDOwner.h"

static NSInteger const max_message_length = 15;

@implementation UIView (custome)

- (UIImage *)convertViewToImage {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)removeAllSubLayer {
    for (CALayer *subLayer in [self.layer sublayers]) {
        [subLayer removeFromSuperlayer];
    }
}

- (CGFloat)frameX {
    return self.frame.origin.x;
}

- (CGFloat)frameY {
    return self.frame.origin.y;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (CGFloat)width {
    return CGRectGetWidth(self.bounds);
}

- (CGFloat)height {
    return CGRectGetHeight(self.bounds);
}

- (CGFloat)minWidthAndHeight {
    return MIN(self.width, self.height);
}

- (CGFloat)maxWidthAndHeight {
    return MAX(self.width, self.height);
}

+ (id)loadFromNib {
    return [self loadFromNibNamed:NSStringFromClass(self)];
}

+ (id)loadFromNibNamed:(NSString *)nibName {
    return [FileOwner viewFromNibNamed:nibName];
}

+ (id)loadFromNibNoOwner {
    UIView *result = nil;
    NSArray *results = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    for (id anObject in results) {
        if ([anObject isKindOfClass:self]) {
            result = anObject;
            break;
        }
    }
    return result;
}

- (void)showHUDWithMessage:(NSString *)message success:(BOOL)success {
    if (message.length > max_message_length) {
        [self showHUDWithMessage:@"提示" detail:message];
    }
    else {
        runOnMainQueueWithoutDeadlocking(^{
            [self hideAllHUD];
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
            [[MBProgressHUDOwner sharedInstance] setHud:hud];
            [self addSubview:hud];
            NSString *imageName = success ? @"hud-right" : @"hud-error";
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = message;
            hud.removeFromSuperViewOnHide = YES;
            [hud show:YES];
            [hud hide:YES afterDelay:1.5];
        });
    }
}

- (void)showHUDWithMessage:(NSString *)message detail:(NSString *)detail {
    runOnMainQueueWithoutDeadlocking(^{
        [self hideAllHUD];
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
        [[MBProgressHUDOwner sharedInstance] setHud:hud];
        [self addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        hud.detailsLabelText = detail;
        hud.removeFromSuperViewOnHide = YES;
        [hud show:YES];
        [hud hide:YES afterDelay:1.5];
    });
}

- (void)showAnimateHUDWithMessage:(NSString *)message {
    runOnMainQueueWithoutDeadlocking(^{
        [self hideAllHUD];
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
        [[MBProgressHUDOwner sharedInstance] setHud:hud];
        [self addSubview:hud];
        hud.labelText = message;
        hud.removeFromSuperViewOnHide = YES;
        [hud show:YES];
    });
}

- (void)hideAllHUD {
    runOnMainQueueWithoutDeadlocking(^{
        [[[MBProgressHUDOwner sharedInstance] hud] hide:YES];
    });
}

void runOnMainQueueWithoutDeadlocking(void (^block)(void)) {
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (UIViewController *)firstAvailableUIViewController {
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id)traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    }
    else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    }
    else {
        return nil;
    }
}

- (float)traverseViewChainForView:(UIView *)view toViewClass:(Class)class offset:(float)offset {
    if ([view.superview isKindOfClass:class]) {
        return view.superview.frame.origin.y + offset;
    }
    else if ([view.superview isKindOfClass:[UIView class]]) {
        return [self traverseViewChainForView:view.superview toViewClass:class offset:view.superview.frame.origin.y + offset];
    }
    else {
        return offset;
    }
}

@end
