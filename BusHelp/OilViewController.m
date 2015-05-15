//
//  OilViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/21.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "OilViewController.h"
#import <SwipeView/SwipeView.h>
#import "DataRequest.h"
#import "OilTotalPageView.h"
#import "EditOilViewController.h"
#import "OilManagerViewController.h"
#import "EditVehicleViewController.h"

@interface OilViewController () <SwipeViewDataSource, SwipeViewDelegate> {
    NSArray *_vehicleArray;
    Vehicle *_currentVehicle;
}

@property (weak, nonatomic) IBOutlet SwipeView *oilTotalPageSwipeView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *addCarButton;
@property (weak, nonatomic) IBOutlet UILabel *tipMessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet UIButton *showlistBarButton;
@property (weak, nonatomic) IBOutlet UIView *navTitleView;

- (IBAction)addCarButtonPressed:(UIButton *)sender;
- (IBAction)listButtonPressed:(id)sender;

@end

@implementation OilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitle.text=@"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _vehicleArray = nil;
    _currentVehicle = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.backgroundImageView.image = nil;
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
    
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    self.backgroundImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"main-bg" ofType:@"png"]];
    [self setupData];
}

- (void)setupData {
    self.pageControl.hidden = YES;
    self.addCarButton.hidden = NO;
    self.tipMessageLabel.hidden = NO;
    self.showlistBarButton.hidden=YES;
    
    _vehicleArray = [DataFetcher fetchAllVehicle:YES];
    [self setupAddCarButton];
    [self reloadData:NO];
    
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest fetchVehicleWithSuccess:^(NSArray *vehicleArray) {
            _vehicleArray = vehicleArray;
            [self setupAddCarButton];
            [self reloadData:YES];
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
}

- (void)setupAddCarButton {
    if (_vehicleArray.count > 0) {
        self.addCarButton.hidden = YES;
        self.tipMessageLabel.hidden = YES;
        self.showlistBarButton.hidden=NO;
    }
}

- (void)reloadData:(BOOL)request {
    self.pageControl.hidden = !(_vehicleArray.count > 1);
    _currentVehicle = nil;
    if (_vehicleArray.count > 0) {
        self.pageControl.numberOfPages = _vehicleArray.count;
        if (self.oilTotalPageSwipeView.currentPage > _vehicleArray.count - 1) {
            self.oilTotalPageSwipeView.currentPage = 0;
        }
        _currentVehicle = _vehicleArray[self.oilTotalPageSwipeView.currentPage];
        if (request && [CommonFunctionController checkNetworkWithNotify:NO]) {
            [DataRequest importOilTotalWithVehicleIDArray:[_vehicleArray valueForKeyPath:@"vehicleID"] success:^{
                [self.oilTotalPageSwipeView reloadData];
                [CommonFunctionController hideAllHUD];
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
        [self.oilTotalPageSwipeView reloadData];
    }
    [self setupNavigationItem];
}

- (void)setupNavigationItem {
    if (_currentVehicle != nil) {
        self.title = _currentVehicle.number;
        self.navTitle.text=_currentVehicle.number;
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"oil-add"] style:UIBarButtonItemStylePlain target:self action:@selector(addBarButtonItemPressed:)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAnimated)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        
    }
    else {
        self.navTitle.text=@"油耗";
        self.navigationItem.title = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.hidesBackButton = YES;
        
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
    EditOilViewController *editOilViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([EditOilViewController class])];
    editOilViewController.navigationTitle = [(Vehicle *)[_vehicleArray objectAtIndex:self.oilTotalPageSwipeView.currentPage] number];
    editOilViewController.vehicleID = [(Vehicle *)[_vehicleArray objectAtIndex:self.oilTotalPageSwipeView.currentPage] vehicleID];
    [self.navigationController pushViewController:editOilViewController animated:YES];
}

- (void)listBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    OilManagerViewController *oilManagerViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([OilManagerViewController class])];
    oilManagerViewController.navigationTitle = [(Vehicle *)[_vehicleArray objectAtIndex:self.oilTotalPageSwipeView.currentPage] number];
    oilManagerViewController.vehicleID = [(Vehicle *)[_vehicleArray objectAtIndex:self.oilTotalPageSwipeView.currentPage] vehicleID];
    [self.navigationController pushViewController:oilManagerViewController animated:YES];
    
}

- (IBAction)addCarButtonPressed:(UIButton *)sender {
    EditVehicleViewController *vehicleViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([EditVehicleViewController class])];
    vehicleViewController.hiddenSearchButton = YES;
    [self.navigationController pushViewController:vehicleViewController animated:YES];
}

- (IBAction)listButtonPressed:(id)sender {
    
    OilManagerViewController *oilManagerViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([OilManagerViewController class])];
    oilManagerViewController.navigationTitle = [(Vehicle *)[_vehicleArray objectAtIndex:self.oilTotalPageSwipeView.currentPage] number];
    oilManagerViewController.vehicleID = [(Vehicle *)[_vehicleArray objectAtIndex:self.oilTotalPageSwipeView.currentPage] vehicleID];
    [self.navigationController pushViewController:oilManagerViewController animated:YES];
}

#pragma - SwipeView datasource and delegate
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return _vehicleArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (view == nil) {
        @autoreleasepool {
            view = [OilTotalPageView loadFromNib];
        }
    }
    [(OilTotalPageView *)view setVehicleID:[(Vehicle *)[_vehicleArray objectAtIndex:index] vehicleID]];
    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return self.oilTotalPageSwipeView.bounds.size;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    self.pageControl.currentPage = swipeView.currentPage;
    _currentVehicle = nil;
    if (_vehicleArray.count > 0) {
        _currentVehicle = (Vehicle *)_vehicleArray[swipeView.currentPage];
    }
    [self setupNavigationItem];
}


@end
