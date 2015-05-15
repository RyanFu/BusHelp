//
//  FeedbackViewController.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/2.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "FeedbackViewController.h"
#import "RoundCornerButton.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>
#import "DataRequest.h"

@interface FeedbackViewController ()

@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;

- (IBAction)submitButtonPressed:(RoundCornerButton *)sender;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.feedbackTextView becomeFirstResponder];
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
    self.feedbackTextView.layer.borderWidth = 1.0f;
    self.feedbackTextView.layer.borderColor = [UIColor colorWithRed:210.0f / 255.0f green:210.0f / 255.0f blue:210.0f / 255.0f alpha:1.0f].CGColor;
    self.feedbackTextView.placeholder = @"请输入您的意见...";
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    self.navigationItem.title = @"意见反馈";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButtonPressed:(RoundCornerButton *)sender {
    [CommonFunctionController resignFirstResponderByView:self.view];
    if ([CommonFunctionController checkValueValidate:self.feedbackTextView.text] == nil || [[self.feedbackTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [CommonFunctionController showHUDWithMessage:@"请写点什么吧！" success:NO];
    }
    else {
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest submitFeedbackByContent:self.feedbackTextView.text success:^{
            [CommonFunctionController showHUDWithMessage:@"反馈成功！" success:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
}

@end
