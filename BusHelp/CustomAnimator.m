//
//  MTHCustomAnimator.m
//  TransitionController
//
//  Created by Tony Zeng on 15/2/9.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "ALDBlurImageProcessor.h"
#import "CustomAnimator.h"

static CGFloat const defaultDuration = .8f;

@implementation CustomAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.animateDuration != 0) {
        return self.animateDuration;
    }
    
    return defaultDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if (self.type == CustomAnimatorTypeFromFadeOutToFadeIn) {
        [[transitionContext containerView] addSubview:toViewController.view];
        toViewController.view.alpha = 0;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.alpha = 0;
            toViewController.view.alpha = 1.0f;
        } completion:^(BOOL finished) {
            if (![transitionContext transitionWasCancelled]) {
                [fromViewController.view removeFromSuperview];
            }
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    else {
        CGAffineTransform travel = CGAffineTransformIdentity;
        switch (self.type) {
            case CustomAnimatorTypeFromTopToBottom:
                travel = CGAffineTransformMakeTranslation(0, CGRectGetHeight([transitionContext containerView].bounds));
                break;
            case CustomAnimatorTypeFromBottomToTop:
                travel = CGAffineTransformMakeTranslation(0, -CGRectGetHeight([transitionContext containerView].bounds));
                break;
            case CustomAnimatorTypeFromLeftToRight:
                travel = CGAffineTransformMakeTranslation(CGRectGetWidth([transitionContext containerView].bounds), 0);
                break;
            default:
                travel = CGAffineTransformMakeTranslation(-CGRectGetWidth([transitionContext containerView].bounds), 0);
                break;
        }
        UIImage *screenShotImage = nil;
        if (!self.isDismiss) {
            screenShotImage = [toViewController.view convertViewToImage];
        }
        else {
            screenShotImage = [fromViewController.view convertViewToImage];
        }
        ALDBlurImageProcessor *blurImageProcessor = [[ALDBlurImageProcessor alloc] initWithImage:screenShotImage];
        NSNumber *errorCode = nil;
        UIImageView *blurImageView = nil;
        UIImage *blurImage = [blurImageProcessor syncBlurWithRadius:10 iterations:10 errorCode:&errorCode];
        if (errorCode != nil) {
            DLog(@"%s error = %@", __FUNCTION__, errorCode);
        }
        else {
            blurImageView = [[UIImageView alloc] initWithImage:blurImage];
            blurImageView.frame = !self.isDismiss ? toViewController.view.bounds : fromViewController.view.bounds;
            if (!self.isDismiss) {
                [toViewController.view addSubview:blurImageView];
            }
            else {
                [fromViewController.view addSubview:blurImageView];
            }
        }
        if (!(self.isDismiss && self.isCovered)) {
            [[transitionContext containerView] addSubview:toViewController.view];
            toViewController.view.transform = CGAffineTransformInvert(travel);
        }
        else {
            [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
        }
        blurImageView.alpha = !self.isDismiss ? 1 : 0;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            if (!self.isCovered || (self.isDismiss && self.isCovered)) {
                fromViewController.view.transform = travel;
            }
            blurImageView.alpha = !self.isDismiss ? 0 : 1;
            toViewController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            fromViewController.view.transform = CGAffineTransformIdentity;
            if (![transitionContext transitionWasCancelled]) {
                [fromViewController.view removeFromSuperview];
            }
            [blurImageView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
