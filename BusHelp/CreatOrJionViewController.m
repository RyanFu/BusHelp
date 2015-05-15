//
//  CreatOrJionViewController.m
//  BusHelp
//
//  Created by Paul on 15/5/10.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "CreatOrJionViewController.h"
#import "DataRequest.h"
#import "CommonFunctionController.h"
#import "OrgSearchTableViewController.h"

@interface CreatOrJionViewController ()
{
    Org *_org;
}
@end

@implementation CreatOrJionViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self setupNavigationBar];
    [CommonFunctionController showAnimateMessageHUD];
    [self setupOrgWithRequest:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cancelButton.layer.masksToBounds=YES;
    self.cancelButton.layer.cornerRadius=5;
}

- (void)setupOrgWithRequest:(BOOL)request {
    if (request && [CommonFunctionController checkNetworkWithNotify:NO]) {
        [DataRequest fetchOrgWithSuccess:^(NSArray *orgArray) {
            _org = [orgArray firstObject];
            NSLog(@"组织名称：%@",_org.name);
            
            if (_org.status.intValue == OrgStatusApplying) {
                self.CreateTeam.hidden=YES;
                self.JoinTeam.hidden=YES;
                self.ApplyingLabel.hidden=NO;
                self.ApplyingImage.hidden=NO;
                self.cancelButton.hidden=NO;
                self.ApplyingLabel.text = [NSString stringWithFormat:@"您已申请加入%@，正在审核中...", _org.name];

            }else if(_org.status.intValue == OrgStatusInviting)
            {
                self.CreateTeam.hidden=YES;
                self.JoinTeam.hidden=YES;
                self.ApplyingLabel.hidden=NO;
                self.ApplyingImage.hidden=NO;
                self.cancelButton.hidden=YES;
                self.ApplyingLabel.text = [NSString stringWithFormat:@"正在邀请你加入%@...", _org.name];
            }
            else
            {
                self.CreateTeam.hidden=NO;
                self.JoinTeam.hidden=NO;
                self.ApplyingLabel.hidden=YES;
                self.ApplyingImage.hidden=YES;
                self.cancelButton.hidden=YES;
            }
            
            [CommonFunctionController hideAllHUD];
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:@"服务器开小差了！" detail:nil];
        }];
    }
    else {
        [CommonFunctionController showHUDWithMessage:@"网络已断开" detail:nil];
    }
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    self.navigationItem.title = @"我的团队";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

//创建组织
- (IBAction)CreateOrgButtunPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建公司或团队" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"提交", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 1001;
    [alertView textFieldAtIndex:0].placeholder = @"请输入公司或团队名称";
    [alertView show];
    
}

- (IBAction)AddOrgButtonPressed:(id)sender {
    OrgSearchTableViewController *orgSearchTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([OrgSearchTableViewController class])];
    [self.navigationController pushViewController:orgSearchTableViewController animated:YES];

}

- (IBAction)cancelApplying:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要取消申请？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            NSString *orgName = [alertView textFieldAtIndex:0].text;
            if (orgName == nil || [orgName isEqualToString:@""]) {
                [CommonFunctionController showHUDWithMessage:@"公司或团队名称不能为空" success:NO];
                return;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [CommonFunctionController showAnimateMessageHUD];
                [DataRequest createOrgWithOrgName:orgName success:^{
                    [CommonFunctionController showHUDWithMessage:@"创建公司或团队成功！" success:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSString *message) {
                    [CommonFunctionController showHUDWithMessage:message success:NO];
                }];
            });
        }
    } //创建组织
    else {
        if (buttonIndex != 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [CommonFunctionController showAnimateMessageHUD];
                [DataRequest cancelOrgApplyingWithOrgID:_org.orgID success:^{
                    [CommonFunctionController showHUDWithMessage:@"取消申请成功！" success:YES];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } failure:^(NSString *message) {
                    [CommonFunctionController showHUDWithMessage:message success:NO];
                }];
            });
        }
    } //取消申请
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
