//
//  AboutViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/5.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController () <UIActionSheetDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction)phoneNumberButtonPressed:(UIButton *)sender;
- (IBAction)urlButtonPressed:(UIButton *)sender;


@end

@implementation AboutViewController

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

- (void)commonInit {
    [super commonInit];
    self.detailTextView.text = @"此版本适合于iOS操作系统系列手机，对于在其他操作系统平台使用本软件出现的任何问题，上海创程不承担任何责任。\n本软件的下载，安装和使用完全免费，使用过程中产生的数据流量费用，由运营商收取。";
    self.versionLabel.text = [NSString stringWithFormat:@"易管车 for iPhone V%@", [UserSettingInfo fetchAppVersion]];
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    self.navigationItem.title = @"关于我们";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)phoneNumberButtonPressed:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否要拨打易管车客服电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"400-021-9018" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

- (IBAction)urlButtonPressed:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"是否要跳转到ygc.g-bos.cn"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-021-9018"]];
    }
}

#pragma - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SHARE_REDIRECT_URL]];
    }
}

@end
