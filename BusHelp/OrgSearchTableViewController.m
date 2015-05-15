//
//  SearchTableViewController.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/13.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "OrgSearchTableViewController.h"
#import "OrgSearchTableViewCell.h"
#import "OrgItem.h"
#import "DataRequest.h"
#import "HelpView.h"

@interface OrgSearchTableViewController () <UISearchBarDelegate> {
    UISearchBar *_searchBar;
    NSArray *_dataArray;
}


@end

@implementation OrgSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _searchBar = nil;
    _dataArray = nil;
}

- (void)commonInit {
    self.tableView.rowHeight = 44.0f;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.width - 60, 30)];
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.placeholder = @"输入公司或团队编号/名称查找";
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = _searchBar;
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"公司或团队搜索";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    if (![UserSettingInfo fetchHelpIsReadByKey:@"help-2"]) {
        [HelpView showWithImageArray:@[@"help-2", @"help-3"]];
    }
    else {
        [_searchBar becomeFirstResponder];
    }
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [_searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrgSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrgSearchTableViewCell class])];
    OrgItem *orgItem = [_dataArray objectAtIndex:indexPath.row];
    cell.OrgName.text = [NSString stringWithFormat:@"%@(%@)", orgItem.name, orgItem.number];
    cell.detailTextLabel.text = orgItem.orgDescription;
    cell.orgID = orgItem.orgID;
    [cell setJoinButtonPressed:^{        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.0f;
}

#pragma - UISearchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //[_searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [_searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [CommonFunctionController showAnimateMessageHUD];
    [DataRequest fetchOrgByOrgInfo:searchBar.text success:^(NSArray *orgItemArray) {
        _dataArray = orgItemArray;
        [self.tableView reloadData];
        if (_dataArray.count == 0) {
            [CommonFunctionController showHUDWithMessage:@"您所查询的公司或团队不存在！" success:YES];
        }
        else {
            [CommonFunctionController hideAllHUD];
        }
    } failure:^(NSString *message){
        [CommonFunctionController showHUDWithMessage:message success:NO];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
