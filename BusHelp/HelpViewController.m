//
//  HelpViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/25.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "HelpViewController.h"
#import <SwipeView/SwipeView.h>
#import "CustomAnimator.h"

static CGFloat const duration = 1.0f;

@interface HelpViewController () <SwipeViewDataSource, SwipeViewDelegate, UIViewControllerTransitioningDelegate> {
    CustomAnimator *_animator;
    NSMutableArray *_imageNameArray;
}

@property (weak, nonatomic) IBOutlet SwipeView *helpSwipeView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)backButtonPressed:(UIButton *)sender;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _animator = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
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
    self.helpSwipeView.bounces = NO;
    self.helpSwipeView.wrapEnabled = YES;
    _imageNameArray = [NSMutableArray arrayWithCapacity:2];
    for (NSInteger i = 1; i <= 8; i++) {
        [_imageNameArray addObject:[NSString stringWithFormat:@"help-%@", @(i)]];
    }
    self.pageControl.numberOfPages = _imageNameArray.count;
    [self.helpSwipeView reloadData];
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma - SwipeView datasource and delegate
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return _imageNameArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (view == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        view = imageView;
    }
    ((UIImageView *)view).image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_imageNameArray[index] ofType:@"png"]];
    
    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return self.view.bounds.size;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    self.pageControl.currentPage = swipeView.currentPage;
}

#pragma mark - Transitioning Delegate (Modal)

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _animator.dismiss = NO;
    _animator.animateDuration = duration;
    _animator.type = CustomAnimatorTypeFromFadeOutToFadeIn;
    return _animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _animator.dismiss = YES;
    _animator.animateDuration = duration;
    _animator.type = CustomAnimatorTypeFromFadeOutToFadeIn;
    return _animator;
}


@end
