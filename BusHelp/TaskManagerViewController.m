//
//  TaskManagerViewController.m
//  BusHelp
//
//  Created by Tony Zeng on 15/2/27.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "TaskManagerViewController.h"
#import <SwipeView/SwipeView.h>
#import "TaskTableView.h"
#import "DataRequest.h"
#import "TaskDetailView.h"
#import "HelpView.h"

@interface TaskManagerViewController () <SwipeViewDataSource, SwipeViewDelegate> {
    TaskDetailView *_taskDetailView;
    UIView *_currentSelectedView;
    Org *_org;

}

@property (weak, nonatomic) IBOutlet UILabel *spotTaskCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *underWayTaskCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *allTaskCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineImageViewWidthConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineImageViewLeadingConstaint;
@property (weak, nonatomic) IBOutlet SwipeView *taskSwipeView;
@property (weak, nonatomic) IBOutlet UIView *spotView;
@property (weak, nonatomic) IBOutlet UIView *underWayView;
@property (weak, nonatomic) IBOutlet UIView *allView;
@property (weak, nonatomic) IBOutlet UILabel *tipMessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cryImageView;


- (IBAction)topViewTappedGesture:(UITapGestureRecognizer *)sender;

@end

@implementation TaskManagerViewController

-(void)viewWillAppear:(BOOL)animated
{
    if ([DataFetcher fetchAllOrg].count) {
        _org=[[DataFetcher fetchAllOrg] firstObject];
        [self setupNavigationBar];
        
    }else
    {
        [self setupOrgWithRequest:YES];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _taskDetailView = nil;
    _currentSelectedView = nil;
    self.referenceID = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:refreshDataKey object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupNavigationBar {
    [super setupNavigationBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:refreshDataKey object:nil];
    
    self.navigationItem.title = @"任务";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBarButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    if (_org.userType.integerValue==OrgUserTypeCreater||_org.userType.integerValue==OrgUserTypeAdmin) {
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    }else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }

    
    if (self.isNotification && self.referenceID != nil) {
        [self showDetailViewWithReferenceID:self.referenceID];
    }
    else {
        [self setupData];
    }
    [HelpView showWithImageArray:@[@"help-8"]];
}

- (void)showDetailViewWithReferenceID:(NSString *)referenceID {
    for (UIView *subView in [[UIApplication sharedApplication].keyWindow subviews]) {
        if ([subView isKindOfClass:[TaskDetailView class]]) {
            [subView removeFromSuperview];
        }
    }
    if (_taskDetailView != nil) {
        [_taskDetailView removeFromSuperview];
        _taskDetailView = nil;
    }
    _taskDetailView = [TaskDetailView loadFromNib];
    _taskDetailView.referenceID = referenceID;
    [_taskDetailView showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)refreshData:(NSNotification *)notification {
    [self setupData];
}

- (void)setupData {
    self.cryImageView.hidden = NO;
    self.tipMessageLabel.hidden = NO;
    self.tipMessageLabel.text = @"您没有新任务!";
    [self reloadDataWithTaskCountDictionary:[DataFetcher fetchTaskCountDictionary]];
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest fetchTaskCountWithSuccess:^(NSDictionary *taskCountDictionary) {
            [self reloadDataWithTaskCountDictionary:taskCountDictionary];
            [CommonFunctionController hideAllHUD];
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
}

- (void)reloadDataWithTaskCountDictionary:(NSDictionary *)taskCountDictionary {
    self.spotTaskCountLabel.text = [NSString stringWithFormat:@"(%@)", [taskCountDictionary objectForKey:[NSNumber numberWithInteger:TaskStatusSpot]]];
    if (![self.spotTaskCountLabel.text isEqualToString:@"(0)"]) {
        self.cryImageView.hidden = YES;
        self.tipMessageLabel.hidden = YES;
    }
    self.underWayTaskCountLabel.text = [NSString stringWithFormat:@"(%@)", [taskCountDictionary objectForKey:[NSNumber numberWithInteger:TaskStatusUnderWay]]];
    self.allTaskCountLabel.text = [NSString stringWithFormat:@"(%@)", [taskCountDictionary objectForKey:[NSNumber numberWithInteger:TaskStatusAll]]];
    [self.taskSwipeView reloadData];
    [self setupTopView];
}

- (void)setupTopView {
    if (_currentSelectedView == nil) {
        _currentSelectedView = self.spotView;
    }
    [self changeSelectedByTapView:_currentSelectedView];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self performSegueWithIdentifier:@"TaskManagerToAddTask" sender:self];
}

- (IBAction)topViewTappedGesture:(UITapGestureRecognizer *)sender {
    UIView *tapView = sender.view;
    [self changeSelectedByTapView:tapView];
    [self.taskSwipeView scrollToPage:tapView.tag duration:0.5f];
    self.cryImageView.hidden = YES;
    self.tipMessageLabel.hidden = YES;
    if (tapView.tag == 1) {
        if ([self.spotTaskCountLabel.text isEqualToString:@"(0)"]) {
            self.cryImageView.hidden = NO;
            self.tipMessageLabel.hidden = NO;
            self.tipMessageLabel.text = @"您没有新任务!";
        }
    }
    else if (tapView.tag == 2) {
        if ([self.underWayTaskCountLabel.text isEqualToString:@"(0)"]) {
            self.cryImageView.hidden = NO;
            self.tipMessageLabel.hidden = NO;
            self.tipMessageLabel.text = @"您没有进行中的任务!";
        }
    }
}

- (void)changeSelectedByTapView:(UIView *)tapView {
    _currentSelectedView = tapView;
    self.lineImageViewLeadingConstaint.constant = tapView.frameX;
    self.lineImageViewWidthConstaint.constant = tapView.width;
    [UIView animateWithDuration:0.5f animations:^{
        [self.lineImageView.superview layoutIfNeeded];
    }];
}

#pragma - SwipeView datasource and delegate
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return 3;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (view == nil) {
        view = [TaskTableView loadFromNib];
    }
    TaskStatus status = TaskStatusSpot;
    if (index == 1) {
        status = TaskStatusUnderWay;
    }
    else if (index == 2) {
        status = TaskStatusAll;
    }
    
    [(TaskTableView *)view setStatus:status];
    
    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return self.taskSwipeView.bounds.size;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    UIView *tapView = nil;
    self.cryImageView.hidden = YES;
    self.tipMessageLabel.hidden = YES;
    switch (swipeView.currentPage) {
        case 0:
            tapView = self.spotView;
            if ([self.spotTaskCountLabel.text isEqualToString:@"(0)"]) {
                self.cryImageView.hidden = NO;
                self.tipMessageLabel.hidden = NO;
                self.tipMessageLabel.text = @"您没有新任务!";
            }
            break;
        case 1:
            tapView = self.underWayView;
            if ([self.underWayTaskCountLabel.text isEqualToString:@"(0)"]) {
                self.cryImageView.hidden = NO;
                self.tipMessageLabel.hidden = NO;
                self.tipMessageLabel.text = @"您没有进行中的任务!";
            }
            break;
        case 2:
            tapView = self.allView;
            break;
        default:
            break;
    }
    [self changeSelectedByTapView:tapView];
}

- (void)setupOrgWithRequest:(BOOL)request {
    [CommonFunctionController showAnimateMessageHUD];
    if (request && [CommonFunctionController checkNetworkWithNotify:NO]) {
        [DataRequest fetchOrgWithSuccess:^(NSArray *orgArray) {
            _org = [orgArray firstObject];
            NSLog(@"组织名称：%@",_org.name);
            [self setupNavigationBar];
            [CommonFunctionController hideAllHUD];
        } failure:^(NSString *message){
            [CommonFunctionController hideAllHUD];
            
        }];
    }
    else {
        [CommonFunctionController showHUDWithMessage:@"网络已断开" detail:nil];
    }
}

@end
