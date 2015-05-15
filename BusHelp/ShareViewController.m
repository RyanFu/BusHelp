//
//  ShareViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/15.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ShareViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <ShareSDK/ShareSDK.h>

@interface ShareViewController () <UITextViewDelegate> {
    UIImageView *_fullImageView;
}

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *shareImageView;
@property (weak, nonatomic) IBOutlet UILabel *wordCountLabel;

- (IBAction)shareImageViewTapped:(UITapGestureRecognizer *)sender;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _fullImageView = nil;
    self.navigationTitle = nil;
    self.content = nil;
    self.shareImage = nil;
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
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    [self updateWordCount];
    self.shareImageView.image = self.shareImage;
    self.contentTextView.text = self.content;
}

- (void)dealloc {
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
    self.shareImage = nil;
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    [self.contentTextView becomeFirstResponder];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.navigationTitle;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share-submit"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.contentTextView resignFirstResponder];
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@【%@】", self.contentTextView.text, SHARE_TITLE]
                                       defaultContent:[NSString stringWithFormat:@"%@【%@】", SHARE_CONTENT, SHARE_TITLE]
                                                image:[ShareSDK jpegImageWithImage:self.shareImageView.image quality:0.4]
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    BOOL needAuth = NO;
    ShareType shareType = ShareTypeTencentWeibo;
    if ([self.navigationTitle isEqualToString:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]]) {
        shareType = ShareTypeSinaWeibo;
    }
    if (![ShareSDK hasAuthorizedWithType:shareType]) {
        needAuth = YES;
        [ShareSDK getUserInfoWithType:shareType
                          authOptions:nil
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                   if (result) {
                                       //分享内容
                                       [CommonFunctionController showAnimateHUDWithMessage:nil];
                                       [ShareSDK shareContent:publishContent
                                                         type:shareType
                                                  authOptions:nil
                                                statusBarTips:NO
                                                       result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                           if (state == SSResponseStateSuccess) {
                                                               [CommonFunctionController showHUDWithMessage:@"分享成功！" success:YES];
                                                               [self.navigationController popViewControllerAnimated:YES];
                                                           }
                                                           else if (state == SSResponseStateFail) {
                                                               DLog(@"error = %@,--%@", @([error errorCode]), [error errorDescription]);
                                                               [CommonFunctionController showHUDWithMessage:@"分享失败！" success:NO];
                                                               [self.contentTextView becomeFirstResponder];
                                                           }
                                                           else if (state == SSResponseStateCancel) {
                                                               [CommonFunctionController showHUDWithMessage:@"分享已取消！" success:YES];
                                                               [self.contentTextView becomeFirstResponder];
                                                           }
                                                           else {
                                                               
                                                           }
                                       }];
                                   }
                                   else {
                                       DLog(@"error = %@,--%@", @([error errorCode]), [error errorDescription]);
                                       [CommonFunctionController showHUDWithMessage:@"用户绑定失败！" success:NO];
                                   }
                               }];
    }
    
    if (!needAuth) {
        //分享内容
        [CommonFunctionController showAnimateHUDWithMessage:nil];
        [ShareSDK shareContent:publishContent
                          type:shareType
                   authOptions:nil
                 statusBarTips:NO
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            if (state == SSResponseStateSuccess) {
                                [CommonFunctionController showHUDWithMessage:@"分享成功！" success:YES];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            else if (state == SSResponseStateFail) {
                                DLog(@"error = %@,--%@", @([error errorCode]), [error errorDescription]);
                                [CommonFunctionController showHUDWithMessage:@"分享失败！" success:NO];
                                [self.contentTextView becomeFirstResponder];
                            }
                            else if (state == SSResponseStateCancel) {
                                [CommonFunctionController showHUDWithMessage:@"分享已取消！" success:YES];
                                [self.contentTextView becomeFirstResponder];
                            }
                            else {
                                
                            }
                        }];
    }
}

- (void)updateWordCount {
    NSInteger count = 108 - [self.contentTextView.text length];
    self.wordCountLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    if (count < 0) {
        self.wordCountLabel.textColor = [UIColor redColor];
    }
    else {
        self.wordCountLabel.textColor = [UIColor colorWithRed:192.0 / 255.0 green:192.0 / 255.0 blue:192.0 / 255.0 alpha:1.0f];
    }
}

- (IBAction)shareImageViewTapped:(UITapGestureRecognizer *)sender {
    [self.contentTextView resignFirstResponder];
    _fullImageView = [[UIImageView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    _fullImageView.image = self.shareImageView.image;
    [[UIApplication sharedApplication].keyWindow addSubview:_fullImageView];
    _fullImageView.alpha = 0;
    _fullImageView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.5 animations:^{
        _fullImageView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [_fullImageView addGestureRecognizer:tap];
    }];
}

- (void)tapped:(UITapGestureRecognizer *)gesture {
    if (_fullImageView != nil) {
        [UIView animateWithDuration:0.5 animations:^{
            _fullImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [_fullImageView removeFromSuperview];
            _fullImageView = nil;
            [self.contentTextView becomeFirstResponder];
        }];
    }
}

#pragma mark - UITextView delegate
- (void)textViewDidChange:(UITextView *)textView {
    [self updateWordCount];
}

@end
