//
//  OrgMessageDetailViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/8.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "OrgMessageDetailViewController.h"
#import "RoundCornerButton.h"
#import "DataRequest.h"

@interface OrgMessageDetailViewController () <UIAlertViewDelegate> {
    OrgAction _action;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet RoundCornerButton *joinOrgButton;
@property (weak, nonatomic) IBOutlet RoundCornerButton *disagreeOrgButton;

- (IBAction)joinOrgButtonPressed:(RoundCornerButton *)sender;
- (IBAction)disagreeOrgButtonPressed:(RoundCornerButton *)sender;

@end

@implementation OrgMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.orgMessage = nil;
    self.referenceID = nil;
    self.refreshOrgBlock = nil;
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
    if (self.referenceID == nil) {
        [self setupData];
    }
    else {
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest fetchOrgMessageWithOrgMessageID:self.referenceID success:^(OrgMessage *orgMessage) {
            self.orgMessage = orgMessage;
            [self setupData];
            [CommonFunctionController hideAllHUD];
        } failure:^(NSString *message) {
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
}

- (void)setupData {
    self.joinOrgButton.hidden = YES;
    self.disagreeOrgButton.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.orgMessage.action integerValue] == OrgMessageTypeInvite && self.status == OrgStatusInviting) {
        self.joinOrgButton.hidden = NO;
        self.disagreeOrgButton.hidden = NO;
    } //审核别人的邀请
    else if ([self.orgMessage.action integerValue] == OrgMessageTypeApply) {
        [self.joinOrgButton setTitle:@"同意" forState:UIControlStateNormal];
        [self.disagreeOrgButton setTitle:@"拒绝" forState:UIControlStateNormal];
        self.joinOrgButton.hidden = NO;
        self.disagreeOrgButton.hidden = NO;
    } //审核别人的申请
    [self setupMessageReadStatus];
    self.titleLabel.text = self.orgMessage.title;
    self.contentLabel.text = self.orgMessage.content;
}

- (void)setupMessageReadStatus {
    if (([self.orgMessage.action integerValue] == OrgMessageTypeCommon||[self.orgMessage.action integerValue]==OrgMessageTypeNormal || [self.orgMessage.action integerValue] == OrgMessageTypeManual) && [self.orgMessage.isRead isEqualToString:orgMessageNotRead]) {
        [DataFetcher updateOrgMessageStatusByOrgMessageID:self.orgMessage.orgMessageID completion:nil];
        
        [DataRequest joinOrgWithOrgID:self.orgMessage.belongsToOrg.orgID orgMessageID:self.orgMessage.orgMessageID action:OrgActionAgree messageType:[self.orgMessage.action integerValue] success:^{
            
        } failure:^(NSString *message) {
            
        }];
        
//        [DataRequest joinOrgWithOrgID:self.orgMessage.belongsToOrg.orgID orgMessageID:self.orgMessage.orgMessageID action:OrgApplyActionAgree messageType:[self.orgMessage.action integerValue] success:^{
//            
//        } failure:^(NSString *message) {
//            
//        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:updateBadgeValueKey object:nil];
    }
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"消息内容";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)joinOrgButtonPressed:(RoundCornerButton *)sender {
    if ([self.orgMessage.action integerValue] == OrgMessageTypeInvite) {
        [self handlerOrgMessageWithAction:OrgActionAgree];
    } //同意别人的邀请
    else if ([self.orgMessage.action integerValue] == OrgMessageTypeApply) {
        [self handlerOrgMessageWithAction:OrgApplyActionAgree];
    } //同意别人的申请
}

- (IBAction)disagreeOrgButtonPressed:(RoundCornerButton *)sender {
    if ([self.orgMessage.action integerValue] == OrgMessageTypeInvite) {
        [self handlerOrgMessageWithAction:OrgActionDisagree];
    } //拒绝别人的邀请
    else if ([self.orgMessage.action integerValue] == OrgMessageTypeApply) {
        [self handlerOrgMessageWithAction:OrgApplyActionDisagree];
    } //拒绝别人的申请
}

- (void)handlerOrgMessageWithAction:(OrgAction)action {
    NSString *message = @"你确定拒绝加入公司或团队？";
    if (action == OrgActionAgree) {
        message = @"你确定加入公司或团队？";
    }
    else if (action == OrgApplyActionAgree) {
        message = @"你确定同意该用户加入公司或团队？";
    } //拒绝别人的邀请
    else if (action == OrgApplyActionDisagree) {
        message = @"你确定拒绝该用户加入公司或团队？";
    } //拒绝别人的申请
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    _action = action;
}

#pragma - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CommonFunctionController showAnimateMessageHUD];
            [DataRequest joinOrgWithOrgID:self.orgMessage.belongsToOrg.orgID orgMessageID:self.orgMessage.orgMessageID action:_action messageType:[self.orgMessage.action integerValue] success:^{
                if (self.refreshOrgBlock) {
                    self.refreshOrgBlock();
                }
                [CommonFunctionController hideAllHUD];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *message){
                [CommonFunctionController showHUDWithMessage:message success:NO];
            }];
        });
    }
}

@end
