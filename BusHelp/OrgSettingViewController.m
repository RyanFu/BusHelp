//
//  OrgSettingViewController.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/12.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "OrgSettingViewController.h"
#import "RoundCornerButton.h"
#import "OrgTableViewCell.h"
#import "ShieldVehicleTableViewController.h"
#import "DataRequest.h"
#import <ShareSDK/ShareSDK.h>

@interface OrgSettingViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet RoundCornerButton *btnOutOrg;
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

- (IBAction)outOrgButtonPressed:(RoundCornerButton *)sender;

@end

@implementation OrgSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.userType.integerValue == OrgUserTypeCreater) {
        self.btnOutOrg.tag = 1001;
        [self.btnOutOrg setTitle:@"解散公司或团队" forState:UIControlStateNormal];
    }
    else {
        self.btnOutOrg.tag = 1002;
        [self.btnOutOrg setTitle:@"退出公司或团队" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.vehicleListArray = nil;
    self.orgID = nil;
    self.userType = nil;
    self.orgName = nil;
    self.updateVehicleListArrayBlock = nil;
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
    self.settingTableView.rowHeight = 44.0f;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupNavigationBar {
    self.navigationItem.title = _orgName;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)outOrgButtonPressed:(RoundCornerButton *)sender {
    if (sender.tag == 1001) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要解散公司或团队？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 101;
        [alert show];
    } //解散公司或团队
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要退出公司或团队？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 102;
        [alert show];
    } //退出公司或团队
}

#pragma - UITableView delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    //if (self.userType.integerValue == OrgUserTypeCreater) {
    //    return 2;
    //} //组织创建者
    //else {
    //    return 1;
    //}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        OrgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrgTableViewCell"];
        cell.arrowButton.hidden = NO;
        cell.textLabel.text = @"屏蔽公司或团队车辆";
        return cell;
    }
    else {
        OrgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrgTableViewCell"];
        cell.arrowButton.hidden = NO;
        cell.textLabel.text = @"邀请加入公司或团队";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ShieldVehicleTableViewController *tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ShieldVehicleTableViewController class])];
        tableViewController.navigationTitle = @"屏蔽公司或团队车辆";
        tableViewController.vehicleListArray = self.vehicleListArray;
        tableViewController.orgID = self.orgID;
        [tableViewController setUpdateVehicleListArrayBlock:^(NSArray *listArray) {
            self.vehicleListArray = listArray;
            if (self.updateVehicleListArrayBlock != nil) {
                self.updateVehicleListArrayBlock(listArray);
            }
        }];
        [self.navigationController pushViewController:tableViewController animated:YES];
    }
    else {
        
    }
}

#pragma - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 101) {
        if (buttonIndex != 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [CommonFunctionController showAnimateMessageHUD];
                [DataRequest dissolveOrgWithOrgID:self.orgID success:^{
                    [CommonFunctionController showHUDWithMessage:@"解散公司或团队成功！" success:YES];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } failure:^(NSString *message){
                    [CommonFunctionController showHUDWithMessage:message success:NO];
                }];
            });
        }
    } //解散
    else {
        if (buttonIndex != 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [CommonFunctionController showAnimateMessageHUD];
                [DataRequest outOrgByOrgID:self.orgID success:^{
                    [CommonFunctionController showHUDWithMessage:@"退出公司或团队成功！" success:YES];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } failure:^(NSString *message){
                    [CommonFunctionController showHUDWithMessage:message success:NO];
                }];
            });
        }
    }
}

@end
