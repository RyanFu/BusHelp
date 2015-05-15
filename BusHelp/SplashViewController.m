//
//  SplashViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/20.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "SplashViewController.h"
#import "SplashViewOne.h"
#import "SplashViewTwo.h"
#import "SplashViewThree.h"
#import "CustomAnimator.h"

static CGFloat const duration = 1.0f;

@interface SplashViewController () <UIScrollViewDelegate, UIViewControllerTransitioningDelegate> {
    CustomAnimator *_animator;
}

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *splashScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) NSArray *splashArray;

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _animator = nil;
    self.splashArray = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self resetScrollViewSize];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.backgroundImageView.image = nil;
    [CommonFunctionController removeAllSubviewByView:self.view];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)commonInit {
    [super commonInit];
    _animator = [[CustomAnimator alloc] init];
    self.transitioningDelegate = self;
    self.backgroundImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"main-bg" ofType:@"png"]];
    
    SplashViewOne *splashViewOne = [SplashViewOne loadFromNib];
    [self.splashScrollView addSubview:splashViewOne];
    SplashViewTwo *splashViewTwo = [SplashViewTwo loadFromNib];
    [self.splashScrollView addSubview:splashViewTwo];
    SplashViewThree *splashViewThree = [SplashViewThree loadFromNib];
    [splashViewThree setDismissButtonPressedBlock:^{
        [UserSettingInfo setupSplashHasShown];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.splashScrollView addSubview:splashViewThree];
    
    self.splashArray = @[splashViewOne ,splashViewTwo, splashViewThree];
    [self resetScrollViewSize];
}

- (void)resetScrollViewSize {
    //page view reset frame
    self.pageControl.numberOfPages = self.splashArray.count;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.splashScrollView.contentSize = CGSizeMake(keyWindow.width * self.splashArray.count, keyWindow.height);
    for (NSInteger i = 0; i < self.splashArray.count; i++) {
        UIView *splashView = [self.splashArray objectAtIndex:i];
        splashView.frame = CGRectMake(splashView.width * i, 0, splashView.width, splashView.height);
    }
}

#pragma - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollViewWidth = scrollView.width;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    NSInteger pageIndex = self.pageControl.currentPage;
    if ((NSInteger)currentOffsetX % (NSInteger)scrollViewWidth == 0) {
        pageIndex = currentOffsetX / scrollViewWidth;
    }
    self.pageControl.currentPage = pageIndex;
}

#pragma mark - Transitioning Delegate (Modal)

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _animator.dismiss = YES;
    _animator.animateDuration = duration;
    _animator.type = CustomAnimatorTypeFromFadeOutToFadeIn;
    return _animator;
}

@end
