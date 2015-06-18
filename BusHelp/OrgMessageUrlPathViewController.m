//
//  OrgMessageUrlPathViewController.m
//  BusHelp
//
//  Created by Paul on 15/6/18.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "OrgMessageUrlPathViewController.h"
#import "DataFetcher.h"
#import "DataRequest.h"

@interface OrgMessageUrlPathViewController ()

@end

@implementation OrgMessageUrlPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url =[NSURL URLWithString:self.orgMessage.urlPath];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.TaskDetaiWebView loadRequest:request];
    [self setupMessageReadStatus];
}

- (void)setupMessageReadStatus {
    if (([self.orgMessage.action integerValue] == OrgMessageTypeCommon||[self.orgMessage.action integerValue]==OrgMessageTypeNormal || [self.orgMessage.action integerValue] == OrgMessageTypeManual) && [self.orgMessage.isRead isEqualToString:orgMessageNotRead]) {
        [DataFetcher updateOrgMessageStatusByOrgMessageID:self.orgMessage.orgMessageID completion:nil];
        
        [DataRequest joinOrgWithOrgID:self.orgMessage.belongsToOrg.orgID orgMessageID:self.orgMessage.orgMessageID action:OrgActionAgree messageType:[self.orgMessage.action integerValue] success:^{
            
        } failure:^(NSString *message) {
            
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:updateBadgeValueKey object:nil];
    }
}

- (void)setupNavigationBar
{
    [super setupNavigationBar];
    self.navigationItem.title=@"消息内容";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicatorView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.activityIndicatorView.hidesWhenStopped=YES;
    [self.activityIndicatorView stopAnimating];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
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
