//
//  MTHCustomAnimator.h
//  TransitionController
//
//  Created by Tony Zeng on 15/2/9.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CustomAnimatorTypeFromTopToBottom,
    CustomAnimatorTypeFromBottomToTop,
    CustomAnimatorTypeFromLeftToRight,
    CustomAnimatorTypeFromRightToLeft,
    CustomAnimatorTypeFromFadeOutToFadeIn,
} CustomAnimatorType;

@interface CustomAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter=isCovered) BOOL covered;
@property (nonatomic, assign, getter=isDismiss) BOOL dismiss;
@property (nonatomic, assign) CustomAnimatorType type;
@property (nonatomic, assign) CGFloat animateDuration;

@end
