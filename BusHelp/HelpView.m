//
//  HelpView.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/26.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "HelpView.h"
#import <SwipeView/SwipeView.h>

static NSTimeInterval const duration = 1.0f;

@interface HelpView () <SwipeViewDataSource, SwipeViewDelegate>

@property (weak, nonatomic) IBOutlet SwipeView *helpSwipeView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *imageNameArray;

@end

@implementation HelpView

- (void)awakeFromNib {
    self.helpSwipeView.wrapEnabled = YES;
    self.helpSwipeView.bounces = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (void)showWithImageArray:(NSArray *)imageArray {
    if (![UserSettingInfo fetchHelpIsReadByKey:[imageArray firstObject]]) {
        HelpView *helpView = [HelpView loadFromNib];
        helpView.frame = [UIApplication sharedApplication].keyWindow.bounds;
        helpView.imageNameArray = imageArray;
        helpView.pageControl.numberOfPages = imageArray.count;
        helpView.tag = 10001;
        helpView.alpha = 0;
        [[UIApplication sharedApplication].keyWindow addSubview:helpView];
        [helpView.helpSwipeView reloadData];
        [UIView animateWithDuration:duration animations:^{
            helpView.alpha = 1;
        }];
    }
}

+ (void)hide {
    HelpView *helpView = (HelpView *)[[UIApplication sharedApplication].keyWindow viewWithTag:10001];
    if (helpView != nil) {
        for (NSString *imageName in helpView.imageNameArray) {
            [UserSettingInfo setupHelpReadByKey:imageName];
        }
        [UIView animateWithDuration:duration animations:^{
            helpView.alpha = 0;
        } completion:^(BOOL finished) {
            [CommonFunctionController removeAllSubviewByView:helpView];
            [helpView removeFromSuperview];
        }];
    }
}

#pragma - SwipeView datasource and delegate
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return self.imageNameArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (view == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        view = imageView;
    }
    ((UIImageView *)view).image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_imageNameArray[index] ofType:@"png"]];
    
    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return self.bounds.size;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    self.pageControl.currentPage = swipeView.currentPage;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    [HelpView hide];
}

@end
