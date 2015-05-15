//
//  ForgetPasswordViewController.m
//  BusHelp
//
//  Created by Tony Zeng on 15/2/27.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "RoundCornerButton.h"
#import "DataRequest.h"

static NSInteger const timerCount = 60;

@interface ForgetPasswordViewController () {
    NSInteger _count;
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet RoundCornerButton *codeButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)codeButtonPressed:(RoundCornerButton *)sender;
- (IBAction)submitButtonPressed:(RoundCornerButton *)sender;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _timer = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
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
    UIViewController *viewController = nil;
    if (self.navigationController.tabBarController == nil) {
        viewController = self;
    }
    else {
        viewController = self.navigationController.tabBarController;
    }
    viewController.navigationItem.title = @"找回密码";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.phoneNumberTextField becomeFirstResponder];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)codeButtonPressed:(RoundCornerButton *)sender {
    [CommonFunctionController resignFirstResponderByView:self.view];
    if ([CommonFunctionController checkValueValidate:self.phoneNumberTextField.text] == nil) {
        [CommonFunctionController showHUDWithMessage:@"手机号不能为空!" success:NO];
    }
    else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[0-9]{1,20}"] evaluateWithObject:self.phoneNumberTextField.text]) {
        [CommonFunctionController showHUDWithMessage:@"请输入正确的手机号!" success:NO];
    }
    else {
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest sendRegisterCodeWithPhoneNumber:self.phoneNumberTextField.text isRegister:NO success:^{
            [CommonFunctionController showHUDWithMessage:@"发送成功！" success:YES];
            _count = timerCount;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(codeTimer:) userInfo:nil repeats:YES];
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
}

- (IBAction)submitButtonPressed:(RoundCornerButton *)sender {
    [CommonFunctionController resignFirstResponderByView:self.view];
    if ([CommonFunctionController checkValueValidate:self.phoneNumberTextField.text] == nil) {
        [CommonFunctionController showHUDWithMessage:@"手机号不能为空!" success:NO];
    }
    else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[0-9]{1,20}"] evaluateWithObject:self.phoneNumberTextField.text]) {
        [CommonFunctionController showHUDWithMessage:@"请输入正确的手机号!" success:NO];
    }
    else if ([CommonFunctionController checkValueValidate:self.codeTextField.text] == nil) {
        [CommonFunctionController showHUDWithMessage:@"验证码不能为空!" success:NO];
    }
    else if (self.passwordTextField.text.length < 6 || self.passwordTextField.text.length > 20) {
        [CommonFunctionController showHUDWithMessage:@"密码长度为6~20位!" success:NO];
    }
    else if ([CommonFunctionController checkValueValidate:self.confirmPasswordTextField.text] == nil) {
        [CommonFunctionController showHUDWithMessage:@"确认密码不能为空!" success:NO];
    }
    else if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [CommonFunctionController showHUDWithMessage:@"两次密码输入不一致!" success:NO];
    }
    else {
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest findPasswordWithPhoneNumber:self.phoneNumberTextField.text password:self.passwordTextField.text registerCode:self.codeTextField.text success:^{
            [CommonFunctionController showHUDWithMessage:@"修改成功！" success:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
}

- (void)codeTimer:(NSTimer *)timer {
    if (_count <= 0) {
        [_timer invalidate];
        _timer = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.codeButton setUserInteractionEnabled:YES];
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.codeButton setTitle:[NSString stringWithFormat:@"%@", @(_count)] forState:UIControlStateNormal];
            [self.codeButton setUserInteractionEnabled:NO];
        });
    }
    _count--;
}

@end
