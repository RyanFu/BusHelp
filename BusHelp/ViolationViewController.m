//
//  ViolationViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/21.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ViolationViewController.h"
#import "DataRequest.h"
#import "EditVehicleViewController.h"
#import <SwipeView/SwipeView.h>
#import "ViolationPageView.h"
#import "CustomGasStationViewController.h"


@interface ViolationViewController () <SwipeViewDataSource, SwipeViewDelegate> {
    NSArray *_vehicleArray;
    BOOL _isSearchViolation;
    NSInteger _index;
}

@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;
@property (weak, nonatomic) IBOutlet UIButton *addCarButton;
@property (weak, nonatomic) IBOutlet SwipeView *violationPageSwipeView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)addCarButtonPressed:(UIButton *)sender;

@end

@implementation ViolationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _vehicleArray = nil;
    self.referenceID = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.backgroundImageView.image = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:searchNotificationKey object:nil];
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
    self.violationPageSwipeView.pagingEnabled = YES;
    _index = NSNotFound;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchNotification:) name:searchNotificationKey object:nil];
}

- (void)searchNotification:(NSNotification *)notification {
    _isSearchViolation = YES;
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    self.backgroundImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"main-bg" ofType:@"png"]];
    self.pageControl.hidden = YES;
    if ([UserSettingInfo fetchSplashHasShown]) {
        [self setupData];
    }
}

- (void)setReferenceID:(NSString *)referenceID {
    if (![referenceID isEqualToString:_referenceID] && referenceID != nil) {
        _referenceID = referenceID;
        _index = NSNotFound;
        [self setupData];
    }
}

- (void)setupData {
    _vehicleArray = [DataFetcher fetchAllVehicle:YES];
    [self reloadData:NO];
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest fetchVehicleWithSuccess:^(NSArray *vehicleArray) {
            _vehicleArray = vehicleArray;
            NSLog(@"%@",_vehicleArray);
            [self reloadData:YES];
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
}

- (void)reloadData:(BOOL)request {
    self.pageControl.hidden = !(_vehicleArray.count > 1);
    if (_vehicleArray.count > 0) {
        if (self.referenceID != nil) {
            NSArray *vehicleIDArray = [_vehicleArray valueForKeyPath:@"vehicleID"];
            if ([vehicleIDArray containsObject:self.referenceID]) {
                _index = [vehicleIDArray indexOfObject:self.referenceID];
            }
        }
        self.pageControl.numberOfPages = _vehicleArray.count;
        if (_isSearchViolation || (self.referenceID != nil && _index != NSNotFound)) {
            if (_isSearchViolation) {
                _index = _vehicleArray.count - 1;
            }
            [self.violationPageSwipeView scrollToPage:_index duration:0];
            _isSearchViolation = NO;
            self.referenceID = nil;
            _index = NSNotFound;
        }
        if (self.violationPageSwipeView.currentPage > _vehicleArray.count - 1) {
            self.violationPageSwipeView.currentPage = 0;
        }
        if (request && [CommonFunctionController checkNetworkWithNotify:NO]) {
            [DataRequest importAllViolationWithVehicleIDArray:[_vehicleArray valueForKeyPath:@"vehicleID"] success:^{
                [CommonFunctionController hideAllHUD];
                [self.violationPageSwipeView reloadData];
            } failure:^(NSString *message){
                [CommonFunctionController showHUDWithMessage:message success:NO];
            }];
        }
    }
    else {
        if (request) {
            [CommonFunctionController hideAllHUD];
        }
    }
    if (!request) {
        [self.violationPageSwipeView reloadData];
    }
    [self setupEmptyMessage];
    [self setupNavigationItem];
}

- (void)setupEmptyMessage {
    BOOL hidden = YES;
    if ([CommonFunctionController checkValueValidate:_vehicleArray] == nil) {
        hidden = NO;
    }
    self.emptyLabel.hidden = hidden;
    self.addCarButton.hidden = hidden;
    self.violationPageSwipeView.hidden = !hidden;
}

- (void)setupNavigationItem {
    if ([CommonFunctionController checkValueValidate:_vehicleArray] == nil) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.title = @"违章";
        
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAnimated)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    }
    else {
        Vehicle *currentVehicle = _vehicleArray[self.violationPageSwipeView.currentPage];
        self.title= currentVehicle.number;
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-add"] style:UIBarButtonItemStylePlain target:self action:@selector(addBarButtonItemPressed:)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAnimated)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    }
}

-(void)popViewControllerAnimated
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self addVehicleList];
}

- (IBAction)addCarButtonPressed:(UIButton *)sender {
    [self addVehicleList];
}

- (void)addVehicleList {
    EditVehicleViewController *vehicleViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([EditVehicleViewController class])];
    [self.navigationController pushViewController:vehicleViewController animated:YES];
}

#pragma - SwipeView datasource and delegate
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return _vehicleArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (view == nil) {
        view = [ViolationPageView loadFromNib];
    }
    [(ViolationPageView *)view setVehicle:[_vehicleArray objectAtIndex:index]];
    
    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return self.violationPageSwipeView.bounds.size;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    self.pageControl.currentPage = swipeView.currentPage;
    [self setupNavigationItem];
    [self setupEmptyMessage];
}

@end
