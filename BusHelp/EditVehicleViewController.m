//
//  AddVehicleViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/21.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "EditVehicleViewController.h"
#import "RoundCornerButton.h"
#import "DataRequest.h"
#import <IQKeyboardManager/KeyboardManager.h>
#import "SettingViewController.h"
#import "ProvinceKeyboard.h"
#import "UIImageView+WebCache.h"

@interface EditVehicleViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet RoundCornerButton *checkButtonSmall;
@property (weak, nonatomic) IBOutlet RoundCornerButton *checkButtonLarge;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *engineNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *vinNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *licenseImage;

- (IBAction)provinceLableTapped:(UITapGestureRecognizer *)sender;
- (IBAction)checkSmallButtonPressed:(RoundCornerButton *)sender;
- (IBAction)checkLargeButtonPressed:(RoundCornerButton *)sender;
- (IBAction)helpButtonPressed:(UIButton *)sender;

@end

@implementation EditVehicleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.vehicleItem = nil;
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.checkButtonSmall.buttonSelected = NO;
    self.checkButtonLarge.buttonSelected = YES;
    [self setupData];
}

- (void)setupData {
    if (self.vehicleItem != nil) {
        self.provinceLabel.text = [self.vehicleItem.number substringToIndex:1];
        self.numberTextField.text = [self.vehicleItem.number substringFromIndex:1];;
        self.engineNumberTextField.text = self.vehicleItem.engineNumber;
        self.vinNumberTextField.text = self.vehicleItem.vinNumber;
        self.nameTextField.text = self.vehicleItem.name;
        if ([self.vehicleItem.numberType integerValue] == VehicleNumberTypeSmall) {
            self.checkButtonSmall.buttonSelected = YES;
            self.checkButtonLarge.buttonSelected = NO;
        }
        else {
            self.checkButtonSmall.buttonSelected = NO;
            self.checkButtonLarge.buttonSelected = YES;
        }
        //显示行驶证图片
        if ([CommonFunctionController checkNetworkWithNotify:NO]) {
            [DataRequest fetchVehicleDrivingLicense:self.vehicleItem.vehicleID success:^(id data){
                NSArray *array=[NSArray arrayWithArray:data];
                if (array.lastObject) {
                    [self.licenseImage sd_setImageWithURL:[[data objectAtIndex:0] objectForKey:@"attach_url"]];
                }
                [CommonFunctionController hideAllHUD];
            }failure:^(NSString *message){
                NSLog(@"%@",message);
            }];
        }

    }
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    self.navigationItem.title = @"添加车辆";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBarButtonItemPressed:)];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
}

- (void)saveVehicleItemWithSuccess:(void(^)())success {
    [ProvinceKeyboard hide];
    [CommonFunctionController resignFirstResponderByView:self.view];
    BOOL update = NO;
    VehicleItem *vehicleItem = nil;
    if (self.vehicleItem != nil) {
        update = YES;
        vehicleItem = self.vehicleItem;
    }
    else {
        vehicleItem = [[VehicleItem alloc] init];
        vehicleItem.vehicleID = [[NSUUID UUID] UUIDString];
    }
    vehicleItem.engineNumber = self.engineNumberTextField.text;
    vehicleItem.name = self.nameTextField.text;
    vehicleItem.number = [[NSString stringWithFormat:@"%@%@", self.provinceLabel.text, self.numberTextField.text] uppercaseString];
    vehicleItem.numberType = [NSString stringWithFormat:@"%lu", (unsigned long)(self.checkButtonSmall.buttonSelected ? VehicleNumberTypeSmall : VehicleNumberTypeLarge)];
    vehicleItem.vinNumber = self.vinNumberTextField.text;
    if (vehicleItem.vinNumber == nil) {
        vehicleItem.vinNumber = @"";
    }
    if (vehicleItem.engineNumber == nil) {
        vehicleItem.engineNumber = @"";
    }
    
    if ([CommonFunctionController checkValueValidate:vehicleItem.number] == nil) {
        [CommonFunctionController showHUDWithMessage:@"车牌号不能为空!" success:NO];
    }
    else if (![CommonFunctionController validateCarNo:vehicleItem.number]) {
        [CommonFunctionController showHUDWithMessage:@"请输入正确的车牌号!" success:NO];
    }
    else if ([DataFetcher fetchVehicelByVehicleNumber:vehicleItem.number] != nil && !update) {
        [CommonFunctionController showHUDWithMessage:@"该车牌号已存在!" success:NO];
    }
//    else if ([CommonFunctionController checkValueValidate:vehicleItem.vinNumber] == nil) {
//        [CommonFunctionController showHUDWithMessage:@"车架号不能为空!" success:NO];
//    }
//    else if ([CommonFunctionController checkValueValidate:vehicleItem.engineNumber] == nil) {
//        [CommonFunctionController showHUDWithMessage:@"发动机号不能为空!" success:NO];
//    }
    else {
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest saveVehicleWithVehicleItem:vehicleItem update:update success:^{
            NSString *message = @"添加成功！";
            if (update) {
                message = @"更新成功！";
            }
            [CommonFunctionController showHUDWithMessage:message success:YES];
            success();
        } failure:^(NSString *message) {
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [ProvinceKeyboard hide];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    __weak EditVehicleViewController *weakSelf = self;
    [CommonFunctionController showAnimateMessageHUD];
    [self saveVehicleItemWithSuccess:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}


- (IBAction)checkSmallButtonPressed:(RoundCornerButton *)sender {
    self.checkButtonSmall.buttonSelected = YES;
    self.checkButtonLarge.buttonSelected = NO;
}

- (IBAction)checkLargeButtonPressed:(RoundCornerButton *)sender {
    self.checkButtonSmall.buttonSelected = NO;
    self.checkButtonLarge.buttonSelected = YES;
}

- (IBAction)helpButtonPressed:(UIButton *)sender {
    UIImageView *driverLicenseImageView = [[UIImageView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    driverLicenseImageView.image = [UIImage imageNamed:@"driver-license"];
    driverLicenseImageView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:driverLicenseImageView];
    [UIView animateWithDuration:0.5 animations:^{
        driverLicenseImageView.alpha = 1.0f;
    }];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    driverLicenseImageView.userInteractionEnabled = YES;
    [driverLicenseImageView addGestureRecognizer:tapGesture];
}

- (void)tapped:(UITapGestureRecognizer *)gesture {
    UIView *view = gesture.view;
    [UIView animateWithDuration:0.5 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (IBAction)provinceLableTapped:(UITapGestureRecognizer *)sender {
    [CommonFunctionController resignFirstResponderByView:self.view];
    [ProvinceKeyboard showWithBlock:^(NSString *name) {
        self.provinceLabel.text = name;
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [ProvinceKeyboard hide];
}

@end
