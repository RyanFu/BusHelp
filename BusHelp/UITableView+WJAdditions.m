//
//  UITableView+WJAdditions.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/30.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "UITableView+WJAdditions.h"

@implementation UITableView (WJAdditions)

- (void)wjZeroSeparatorInset {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector: @selector(setSeparatorInset:)]) {
        self.separatorInset = UIEdgeInsetsZero;
    }
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        self.layoutMargins = UIEdgeInsetsZero;
    }
#endif
}

- (void)clearMultipleSeparator {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
}

@end
