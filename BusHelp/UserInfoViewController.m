//
//  UserInfoViewController.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/5.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "UserInfoViewController.h"
#import "RoundCornerButton.h"
#import "DataRequest.h"

@interface UserInfoViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

- (IBAction)logoutButtonPressed:(RoundCornerButton *)sender;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)setupNavigationBar {
    [super setupNavigationBar];
    self.navigationItem.title = @"用户信息";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self setupData];
}

- (void)setupData {
    self.phoneNumberLabel.text = [UserSettingInfo fetchLoginUsername];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoutButtonPressed:(RoundCornerButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要注销当前账号?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CommonFunctionController showAnimateMessageHUD];
            [DataRequest logoutWithSuccess:^{
                [CommonFunctionController showHUDWithMessage:@"注销成功！" success:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:updateBadgeValueKey object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *message){
                [CommonFunctionController showHUDWithMessage:message success:NO];
                
            }];
        });
    }
}

@end
