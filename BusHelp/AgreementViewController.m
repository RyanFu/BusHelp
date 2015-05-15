//
//  AgreementViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/8.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation AgreementViewController

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
    UIViewController *viewController = nil;
    if (self.navigationController.tabBarController == nil) {
        viewController = self;
    }
    else {
        viewController = self.navigationController.tabBarController;
    }
    viewController.navigationItem.title = @"用户注册协议";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commonInit {
    [super commonInit];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"用户注册协议" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
}

@end
