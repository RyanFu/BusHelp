//
//  ShieldVehicleTableViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/5.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ShieldVehicleTableViewController.h"
#import "ShieldVehicleTableViewCell.h"
#import "DataRequest.h"
#import "HelpView.h"

@interface ShieldVehicleTableViewController () {
    NSArray *_totalVehicleArray;
}

@end

@implementation ShieldVehicleTableViewController

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _totalVehicleArray = nil;
    self.vehicleListArray = nil;
    self.orgID = nil;
    self.updateVehicleListArrayBlock = nil;
    self.navigationTitle = nil;
}

- (void)commonInit {
    self.tableView.rowHeight = 44.0f;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = backgroundView;
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipLabel.textColor = [UIColor lightGrayColor];
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [tipLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    tipLabel.text = @"不想让所在的公司或团队看到车辆的油耗、违章信息？让我们“悄悄”的帮你--被你屏蔽的车辆不会向公司或团队传送消息";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tipLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:4.0f];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tipLabel.text length])];
    tipLabel.attributedText = attributedString;
    [backgroundView addSubview:tipLabel];
    NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem:tipLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:tipLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:tipLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:270.0f];
    [backgroundView addConstraints:@[constraintCenterX, constraintCenterY, constraintWidth]];
}

- (void)setupNavigationBar {
    self.navigationItem.title = self.navigationTitle;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self setupData];
}

- (void)setupData {
    _totalVehicleArray = [DataFetcher fetchAllVehicle:YES];
    [self.tableView reloadData];
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest fetchVehicleWithSuccess:^(NSArray *vehicleArray) {
            _totalVehicleArray = vehicleArray;
            [self.tableView reloadData];
            [CommonFunctionController hideAllHUD];
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
    [HelpView showWithImageArray:@[@"help-5"]];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _totalVehicleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShieldVehicleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShieldVehicleTableViewCell class])];
    Vehicle *vehicle = [_totalVehicleArray objectAtIndex:indexPath.row];
    NSString *vehicleID = vehicle.vehicleID;
    __weak ShieldVehicleTableViewCell *weakCell = cell;
    cell.textLabel.text = vehicle.number;
    [cell setSwitchValueChangedBlock:^(BOOL isShield) {
        ShieldAction action = ShieldActionConfirm;
        if (!isShield) {
            action = ShieldActionCancle;
        }
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest shieldOrgVehicleWithOrgID:self.orgID vehicleID:vehicleID action:action success:^{
            NSString *message = @"屏蔽成功！";
            if (action == ShieldActionCancle) {
                message = @"取消屏蔽成功！";
            }
            [CommonFunctionController showHUDWithMessage:message success:YES];
            NSMutableArray *listArray = [NSMutableArray arrayWithArray:self.vehicleListArray];
            if (action == ShieldActionCancle) {
                [listArray addObject:vehicleID];
            }
            else {
                [listArray removeObject:vehicleID];
            }
            self.vehicleListArray = listArray;
            if (self.updateVehicleListArrayBlock != nil) {
                self.updateVehicleListArrayBlock(listArray);
            }
        } failure:^(NSString *message){
            weakCell.isShield = !weakCell.isShield;
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }];
    
    if ([self.vehicleListArray containsObject:vehicleID]) {
        cell.isShield = NO;
    }
    else {
        cell.isShield = YES;
    }
    
    return cell;
}

@end
