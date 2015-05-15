//
//  LoginViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/25.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "LoginViewController.h"
#import "RoundCornerButton.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "DataRequest.h"
#import "Sql_Utils.h"

@interface LoginViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)loginButtonPressed:(RoundCornerButton *)sender;
- (IBAction)forgetPasswordButtonPressed:(UIButton *)sender;
- (IBAction)registerButtonPressed:(RoundCornerButton *)sender;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.loginSuccessBlock = nil;
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

- (void)setupNavigationBar {
    [super setupNavigationBar];
    self.backgroundImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"main-bg" ofType:@"png"]];
    if (self.navigationController.tabBarController == nil) {
        self.navigationItem.title = @"登录";
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];


    }
    else {
        self.navigationController.tabBarController.navigationItem.title = @"登录";
        self.navigationController.tabBarController.navigationItem.hidesBackButton = YES;
        self.navigationController.tabBarController.navigationItem.leftBarButtonItem = nil;

    }
    [self.phoneNumberTextField becomeFirstResponder];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginButtonPressed:(RoundCornerButton *)sender {
    //self.phoneNumberTextField.text = @"15015015099";
    //self.passwordTextField.text = @"15015015099";
    
    [CommonFunctionController resignFirstResponderByView:self.view];
    if ([CommonFunctionController checkValueValidate:self.phoneNumberTextField.text] == nil) {
        [CommonFunctionController showHUDWithMessage:@"用户名不能为空!" success:NO];
    }
    else if ([CommonFunctionController checkValueValidate:self.passwordTextField.text] == nil) {
        [CommonFunctionController showHUDWithMessage:@"密码不能为空!" success:NO];
    }
    else {
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest loginWithUsername:self.phoneNumberTextField.text password:self.passwordTextField.text success:^(BOOL needBindVehicle){
            [CommonFunctionController showHUDWithMessage:@"登录成功！" success:YES];
            if (needBindVehicle) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否绑定车辆至该用户？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
            else {
                [self backToPreviousPage];
            }
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
}

- (IBAction)forgetPasswordButtonPressed:(UIButton *)sender {
    ForgetPasswordViewController *forgetPasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ForgetPasswordViewController class])];
    [self.navigationController pushViewController:forgetPasswordViewController animated:YES];
}

- (IBAction)registerButtonPressed:(UIButton *)sender {
    RegisterViewController *registerViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([RegisterViewController class])];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)backToPreviousPage {
    [UserSettingInfo setupDatabase];
    if (self.isNotification && self.loginSuccessBlock != nil) {
        self.loginSuccessBlock();
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:updateBadgeValueKey object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:dismissLoginKey object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self backToPreviousPage];
    }
    else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CommonFunctionController showAnimateMessageHUD];
            [DataRequest bindVehicleWithSuccess:^{
                [CommonFunctionController showHUDWithMessage:@"绑定成功！" success:YES];
                [self backToPreviousPage];
            } failure:^(NSString *message){
                [CommonFunctionController showHUDWithMessage:message success:NO];
                [self backToPreviousPage];
            }];
        });
    }
}

@end
