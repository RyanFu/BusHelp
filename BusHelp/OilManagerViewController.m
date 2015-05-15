//
//  OilManagerViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/24.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "OilManagerViewController.h"
#import "EditOilViewController.h"
#import "OilItemTableViewCell.h"
#import "DataRequest.h"
#import "NSDate+custom.h"
#import "FSImageViewerViewController.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import <MJRefresh/MJRefresh.h>

@interface OilManagerViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_oilArray;
    NSIndexPath *_selectedIndexPath;
    BOOL _isHeaderRefresh;
}

@property (weak, nonatomic) IBOutlet UITableView *oilTableView;

@end

@implementation OilManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _oilArray = nil;
    _selectedIndexPath = nil;
    self.navigationTitle = nil;
    self.vehicleID = nil;
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
    [self.oilTableView addLegendHeaderWithRefreshingBlock:^{
        _isHeaderRefresh = YES;
        [self setupData];
    }];
}

- (void)setupData {
    _oilArray = [NSMutableArray arrayWithArray:[DataFetcher fetchOilByVehicleID:self.vehicleID ascending:NO]];
    [self.oilTableView reloadData];
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        if (!_isHeaderRefresh) {
            [CommonFunctionController showAnimateMessageHUD];
        }
        [DataRequest fetchOilWithVehicleID:self.vehicleID success:^(NSArray *oilArray) {
            _oilArray = [NSMutableArray arrayWithArray:oilArray];
            [self.oilTableView reloadData];
            [CommonFunctionController hideAllHUD];
            [self endRefresh];
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
            [self endRefresh];
        }];
    }
}

- (void)endRefresh {
    [self.oilTableView.header endRefreshing];
    _isHeaderRefresh = NO;
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    self.navigationItem.title = self.navigationTitle;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"oil-add"] style:UIBarButtonItemStylePlain target:self action:@selector(addBarButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:22.0f / 255.0f green:164.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    EditOilViewController *editOilViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([EditOilViewController class])];
    editOilViewController.navigationTitle = self.navigationTitle;
    editOilViewController.vehicleID = self.vehicleID;
    [self.navigationController pushViewController:editOilViewController animated:YES];
}

#pragma - UITableView datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _oilArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OilItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OilItemTableViewCell class])];
    if (cell == nil) {
        cell = [OilItemTableViewCell loadFromNib];
    }
    [cell setEditButtonPressedBlock:^(Oil *oil) {
        EditOilViewController *editOilViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([EditOilViewController class])];
        editOilViewController.navigationTitle = self.navigationTitle;
        editOilViewController.vehicleID = self.vehicleID;
        
        OilItem *oilItem = [OilItem convertOilToOilItem:oil];
        editOilViewController.oilItem = oilItem;
        [self.navigationController pushViewController:editOilViewController animated:YES];
    }];
    
    __weak OilItemTableViewCell *weakCell = cell;
    [cell setRubbishButtonPressedBlock:^(NSString *oilID, NSString *vehicleID) {
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest removeOilWithOilID:oilID vehicleID:vehicleID success:^{
            [CommonFunctionController showHUDWithMessage:@"删除成功！" success:YES];
            _selectedIndexPath = nil;
            NSIndexPath *cellIndexPath = [tableView indexPathForCell:weakCell];
            [_oilArray removeObjectAtIndex:cellIndexPath.row];
            [tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (_oilArray.count == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }];
    [cell setAttachmentButtonPressedBlock:^(Oil *oil) {
        NSArray *attachmentArray = oil.attachmentList;
        if ([CommonFunctionController checkValueValidate:attachmentArray] != nil) {
            NSMutableArray *photoArray = [NSMutableArray arrayWithCapacity:attachmentArray.count];
            for (NSString *url in attachmentArray) {
                FSBasicImage *photo = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString:url] name:nil];
                [photoArray addObject:photo];
            }
            FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:photoArray];
            FSImageViewerViewController *photoController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
            photoController.sharingDisabled = YES;
            photoController.backgroundColorVisible = [UIColor whiteColor];
            photoController.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
            [self.navigationController pushViewController:photoController animated:YES];
        }
        else {
            [CommonFunctionController showHUDWithMessage:@"没有附件！" success:YES];
        }
    }];
    if ([indexPath isEqual:_selectedIndexPath]) {
        cell.isShowButton = YES;
    }
    else {
        cell.isShowButton = NO;
    }
    cell.oil = [_oilArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_selectedIndexPath isEqual:indexPath]) {
        return 70.0f;
    }
    else {
        return 35.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *orginalIndexPath = _selectedIndexPath;
    if ([_selectedIndexPath isEqual:indexPath]) {
        _selectedIndexPath = nil;
    }
    else {
        _selectedIndexPath = indexPath;
    }
    if (orginalIndexPath != nil && ![orginalIndexPath isEqual:indexPath]) {
        [tableView reloadRowsAtIndexPaths:@[orginalIndexPath, indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
