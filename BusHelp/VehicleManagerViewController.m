//
//  VehicleManagerViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/23.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "VehicleManagerViewController.h"
#import "EditVehicleViewController.h"
#import "VehicleItemTableViewCell.h"
#import "DataRequest.h"
#import <MJRefresh/MJRefresh.h>

@interface VehicleManagerViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_vehicleArray;
    BOOL _isHeaderRefresh;
}

@property (weak, nonatomic) IBOutlet UIButton *addCarButton;

@property (weak, nonatomic) IBOutlet UITableView *itemTableView;
- (IBAction)addCarButtonPressed:(UIButton *)sender;

@end

@implementation VehicleManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _vehicleArray = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupData];
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
    [self.itemTableView addLegendHeaderWithRefreshingBlock:^{
        _isHeaderRefresh = YES;
        [self setupData];
    }];
}

- (void)setupData {
    self.addCarButton.hidden = NO;
    _vehicleArray = [NSMutableArray arrayWithArray:[DataFetcher fetchAllVehicle:YES]];
    [self.itemTableView reloadData];
    [self setupAddCarButton];
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        if (!_isHeaderRefresh) {
            [CommonFunctionController showAnimateMessageHUD];
        }
        [DataRequest fetchVehicleWithSuccess:^(NSArray *vehicleArray) {
            _vehicleArray = [NSMutableArray arrayWithArray:vehicleArray];
            [self.itemTableView reloadData];
            [self setupAddCarButton];
            [CommonFunctionController hideAllHUD];
            [self endRefresh];
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
            [self endRefresh];
        }];
    }
}

- (void)setupAddCarButton {
    if (_vehicleArray.count > 0) {
        self.addCarButton.hidden = YES;
        [self addRightBarButtonItem];
    }
    else {
        [self removeRightBarButtonItem];
    }
}

- (void)endRefresh {
    [self.itemTableView.header endRefreshing];
    _isHeaderRefresh = NO;
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    self.navigationItem.title = @"车辆管理";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)addRightBarButtonItem {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-add"] style:UIBarButtonItemStylePlain target:self action:@selector(addBarButtonItemPressed:)];
    self.tabBarController.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.tabBarController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)removeRightBarButtonItem {
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    EditVehicleViewController *vehicleViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([EditVehicleViewController class])];
    vehicleViewController.hiddenSearchButton = YES;
    [self.navigationController pushViewController:vehicleViewController animated:YES];
}

- (IBAction)addCarButtonPressed:(UIButton *)sender {
    EditVehicleViewController *vehicleViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([EditVehicleViewController class])];
    vehicleViewController.hiddenSearchButton = YES;
    [self.navigationController pushViewController:vehicleViewController animated:YES];
}

#pragma - UITableView datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _vehicleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VehicleItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VehicleItemTableViewCell class])];
    if (cell == nil) {
        cell = [VehicleItemTableViewCell loadFromNib];
    }
    cell.vehicle = [_vehicleArray objectAtIndex:indexPath.row];
    [cell setEditButtonPressedBlock:^(Vehicle *vehicle){
        EditVehicleViewController *vehicleViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([EditVehicleViewController class])];
        vehicleViewController.vehicleItem = [VehicleItem convertVehicleToVehicleItem:vehicle];
        vehicleViewController.hiddenSearchButton = YES;
        [self.navigationController pushViewController:vehicleViewController animated:YES];
    }];
    __weak VehicleItemTableViewCell *weakCell = cell;
    [cell setRubbishButtonPressedBlock:^(NSString *vehicleID){
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest removeVehicleWithVehicleID:vehicleID success:^{
            [CommonFunctionController showHUDWithMessage:@"删除成功！" success:YES];
            NSIndexPath *cellIndexPath = [tableView indexPathForCell:weakCell];
            [_vehicleArray removeObjectAtIndex:cellIndexPath.row];
            [tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (_vehicleArray.count == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

@end
