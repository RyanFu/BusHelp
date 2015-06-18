//
//  ManagerViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/21.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ManagerViewController.h"
#import "LoginViewController.h"
#import "ManagerTableViewCell.h"
#import "TaskManagerViewController.h"
#import "DataRequest.h"
#import "NSDate+custom.h"
#import "NSString+custom.h"
#import "OrgSearchTableViewController.h"
#import "OrgMessageDetailViewController.h"
#import "OrgSettingViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "HelpView.h"
#import "UITableView+WJAdditions.h"
#import <ShareSDK/ShareSDK.h>
#import "OrgMessageUrlPathViewController.h"

static NSInteger const listCount = 20;

@interface ManagerViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    NSNumber *_taskBagdgeNumber;
    NSArray *_orgMessageArray;
    BOOL _isShowTask;
    Task *_lastestTask;
    Org *_org;
    NSArray *_orgArray;
    LoginViewController *_loginViewController;
    BOOL _isHeaderRefresh;
    BOOL _isEnd;
    NSString *_lastMessageID;
    BOOL _isAddFooterRefresh;
    BOOL _isAddHeaderRefresh;
    BOOL _isFooterRefresh;
    NSInteger _requestCount;
    BOOL _isDetailBack;
    BOOL _isLoaded;
}

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *tipMessageLabel;
@property (weak, nonatomic) IBOutlet UITableView *managerTableView;
@property (weak, nonatomic) IBOutlet UILabel *applyingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *applyingImageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)addButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;

@end

@implementation ManagerViewController
@synthesize MessageCategory;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _taskBagdgeNumber = nil;
    _orgMessageArray = nil;
    _lastestTask = nil;
    _org = nil;
    _orgArray = nil;
    _loginViewController = nil;
    _lastMessageID = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_isLoaded) {
        _isLoaded = YES;
        [super setupNavigationBar];
        [self reloadAllData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _isLoaded = NO;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.managerTableView wjZeroSeparatorInset];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dismissLoginKey object:nil];
}

- (void)commonInit {
    [super commonInit];
    _isAddHeaderRefresh = NO;
    _isAddFooterRefresh = NO;
    _isHeaderRefresh = NO;
    _isFooterRefresh = NO;
    
    [self.managerTableView clearMultipleSeparator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLoginNotification:) name:dismissLoginKey object:nil];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)reloadAllData {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    if (![UserSettingInfo checkIsLogin]) {
        _loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginViewController class])];
        [self.navigationController pushViewController:_loginViewController animated:YES];
    }
    else {
//        [self setupOrgWithRequest:NO];
        [self setupOrgWithRequest:YES];
        if (!_isAddHeaderRefresh) {
            _isAddHeaderRefresh = YES;
            [self.managerTableView addLegendHeaderWithRefreshingBlock:^{
                if ([CommonFunctionController checkNetworkWithNotify:NO]) {
                    _isHeaderRefresh = YES;
                    [self setupOrgWithRequest:YES];
                }
                else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self endRefreshWithMessage:ERROR_MESSAGE_1];
                    });
                }
            }];
        }
    }
    _isDetailBack = NO;
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];

}

//创建组织
- (void)createOrgBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建公司或团队" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"提交", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 1001;
    [alertView textFieldAtIndex:0].placeholder = @"请输入公司或团队名称";
    [alertView show];
}

//邀请组织
- (void)applyOrgBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    //设置分享内容
    NSString *message = [NSString stringWithFormat:@"易管车，让车辆管理更轻松。 ygc.g-bos.cn/download/android 下载后，请加入公司：%@", _org.name];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:message
                                       defaultContent:message
                                                image:nil
                                                title:@"邀请加入公司"
                                                  url:nil
                                          description:@"邀请加入公司"
                                            mediaType:SSPublishContentMediaTypeText];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //[container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeSMS),
                          nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                         if (state == SSResponseStateSuccess)
                         {
                             //[CommonFunctionController showHUDWithMessage:@"发送邀请成功！" success:YES];
                         }
                         else if (state == SSResponseStateFail)
                         {
                             //[CommonFunctionController showHUDWithMessage:@"发送邀请失败！" success:NO];
                         }
                     }];
}

//刷新消息
- (void)setupOrgWithRequest:(BOOL)request {
    if (request && [CommonFunctionController checkNetworkWithNotify:NO] && !_isDetailBack) {
        if (!_isHeaderRefresh) {
            [CommonFunctionController showAnimateMessageHUD];
        }
        [DataRequest fetchOrgWithSuccess:^(NSArray *orgArray) {
            _orgArray = orgArray;
//            NSLog(@"%@",_orgArray);
            [self reloadOrgData:request];
        } failure:^(NSString *message){
            [self endRefreshWithMessage:message];
        }];
    }
    else {
        _orgArray = [DataFetcher fetchAllOrg];
        [self reloadOrgData:request];
    }
}

- (void)reloadOrgData:(BOOL)request {
    self.addButton.hidden = YES;
    self.tipMessageLabel.hidden = YES;
    self.applyingImageView.hidden = YES;
    self.cancelButton.hidden = YES;
    self.applyingLabel.hidden = YES;
    
    _org = nil;
    _lastMessageID = @"";
    _isEnd = YES;
    _taskBagdgeNumber = nil;
    _lastestTask = nil;
    if (_orgArray.count > 0) {
        _org = [_orgArray firstObject];
        if ([_org.status integerValue] == OrgStatusApplying) {
            self.applyingImageView.hidden = NO;
            self.cancelButton.hidden = NO;
            self.applyingLabel.hidden = NO;
            self.applyingLabel.text = [NSString stringWithFormat:@"您已申请加入%@，正在审核中...", _org.name];
        }
        _requestCount = 2;
        [self setupTaskWithRequest:request];
        [self setupOrgMessageWithRequest:request];
    }
    else {
        _orgMessageArray = @[];
        _isShowTask = NO;
        if (request) {
            [self endRefreshWithMessage:nil];
        }
        self.addButton.hidden = YES;
        self.tipMessageLabel.hidden = YES;
        [self.managerTableView reloadData];
        [HelpView showWithImageArray:@[@"help-1"]];
        
    }
    [self setupLeftMenu];
    [self updateBadgeValue];
}

- (void)setupTaskWithRequest:(BOOL)request {
    if (request && [CommonFunctionController checkNetworkWithNotify:NO] && !_isDetailBack) {
        [DataRequest fetchTaskCountWithSuccess:^(NSDictionary *taskCountDictionary) {
            [self loadDataByTaskCountDictionary:taskCountDictionary];
            [self endAllRefreshWithMessage:nil];
        } failure:^(NSString *message){
            [self endAllRefreshWithMessage:message];
        }];
    }
    else {
        [self loadDataByTaskCountDictionary:[DataFetcher fetchTaskCountDictionary]];
    }
}

- (void)loadDataByTaskCountDictionary:(NSDictionary *)taskCountDictionary {
    if ([[taskCountDictionary objectForKey:[NSNumber numberWithInteger:TaskStatusAll]] integerValue] > 0) {
        _lastestTask = [DataFetcher fetchLastestTask];
        _isShowTask = YES;
        _taskBagdgeNumber = [taskCountDictionary objectForKey:[NSNumber numberWithInteger:TaskStatusSpot]];
        if ([_taskBagdgeNumber integerValue] > 0) {
//            [HelpView showWithImageArray:@[@"help-7"]];
        }
    }
    else {
        _isShowTask = NO;
    }
    [self.managerTableView reloadData];
    [self updateBadgeValue];
}

- (void)setupOrgMessageWithRequest:(BOOL)request {
    if (request && [CommonFunctionController checkNetworkWithNotify:NO] && !_isDetailBack) {
        [DataRequest fetchOrgMessageWithOrgID:_org.orgID org_message_action:MessageCategory lastMessageID:_lastMessageID count:listCount success:^(NSArray *orgMessageArray, BOOL isEnd) {
            _isEnd = isEnd;
            _orgMessageArray = orgMessageArray;
            [self reloadOrgMessageData];
            [self endAllRefreshWithMessage:nil];
        } failure:^(NSString *message){
            [self endAllRefreshWithMessage:message];
        }];
    }
    else {
        _orgMessageArray = [DataFetcher fetchOrgMessageByOrgID:_org.orgID ascending:NO];
        [self reloadOrgMessageData];
    }
}

- (void)reloadOrgMessageData {
    if (_org != nil && _org.orgID != nil) {
        if (!_isAddFooterRefresh && !_isEnd) {
            _isAddFooterRefresh = YES;
            [self.managerTableView addLegendFooterWithRefreshingBlock:^{
                if ([CommonFunctionController checkNetworkWithNotify:NO]) {
                    _isFooterRefresh = YES;
                    _lastMessageID = [(OrgMessage *)[_orgMessageArray lastObject] orgMessageID];
                    if (_lastMessageID == nil) {
                        _lastMessageID = @"";
                    }
                    _requestCount = 1;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self setupOrgMessageWithRequest:YES];
                    });
                }
                else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self endRefreshWithMessage:ERROR_MESSAGE_1];
                    });
                }
            }];
            [self.managerTableView.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
            [self.managerTableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
        }
    }
    [self.managerTableView reloadData];
    [self updateBadgeValue];
}

- (void)endAllRefreshWithMessage:(NSString *)message {
    _requestCount--;
    if (_requestCount == 0) {
        [self endRefreshWithMessage:message];
    }
}

- (void)endRefreshWithMessage:(NSString *)message {
    if (_isEnd) {
        [self.managerTableView.footer noticeNoMoreData];
    }
    else {
        [self.managerTableView.footer endRefreshing];
    }
    [self.managerTableView.header endRefreshing];
    _isFooterRefresh = NO;
    _isHeaderRefresh = NO;
    if (message == nil) {
        [CommonFunctionController hideAllHUD];
    }
    else {
        [CommonFunctionController showHUDWithMessage:message success:NO];
    }
}

- (void)updateBadgeValue {
    [[NSNotificationCenter defaultCenter] postNotificationName:updateBadgeValueKey object:nil];
}

- (void)setupLeftMenu {
    if (_org != nil && [_org.status integerValue] == OrgStatusJoined) {
//        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"oil-list"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
//        self.tabBarController.navigationItem.leftBarButtonItem = leftBarButtonItem;
//        self.tabBarController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//        
//        UIBarButtonItem *applyOrgBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"邀请" style:UIBarButtonItemStylePlain target:self action:@selector(applyOrgBarButtonItemPressed:)];
//        self.tabBarController.navigationItem.rightBarButtonItem = applyOrgBarButtonItem;
//        self.tabBarController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];

        
        self.tabBarController.navigationItem.title = self.TabbarTitle;
        self.tabBarController.navigationItem.leftBarButtonItem=leftBarButtonItem;
        self.tabBarController.navigationItem.rightBarButtonItem=nil;
        
    } //存在组织
    else {
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
        self.tabBarController.navigationItem.leftBarButtonItem = leftBarButtonItem;
        self.tabBarController.navigationItem.hidesBackButton = YES;

        if (self.cancelButton.hidden) {
            UIBarButtonItem *createOrgBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(createOrgBarButtonItemPressed:)];
            self.tabBarController.navigationItem.rightBarButtonItem = createOrgBarButtonItem;
            self.tabBarController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
            self.tabBarController.navigationItem.rightBarButtonItem = nil;

        } //没有组织 并且 没有正在审核中的组织
        else {
            self.tabBarController.navigationItem.rightBarButtonItem = nil;
        } //加入别人的组织 并且 正在审核中
    
        self.tabBarController.navigationItem.title = self.TabbarTitle;

    } //不存在组织
}

- (void)successLoginNotification:(NSNotification *)notification {
    [_loginViewController.navigationController popViewControllerAnimated:NO];
    if (self.tabBarController.selectedIndex == 2) {
        _isLoaded = YES;
        [super setupNavigationBar];
        [self reloadAllData];
    }
}

- (IBAction)addButtonPressed:(UIButton *)sender {
    OrgSearchTableViewController *orgSearchTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([OrgSearchTableViewController class])];
    [self.tabBarController.navigationController pushViewController:orgSearchTableViewController animated:YES];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要取消申请？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)pushOrgMessageDetail:(OrgMessage *)orgMessage {
    _isDetailBack = YES;
    OrgMessageDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([OrgMessageDetailViewController class])];
    detailViewController.status = [_org.status integerValue];
    detailViewController.orgMessage = orgMessage;
    [detailViewController setRefreshOrgBlock:^{
        [self reloadAllData]; //创建成功之后更新组织相关信息
    }];
    [self.tabBarController.navigationController pushViewController:detailViewController animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            NSString *orgName = [alertView textFieldAtIndex:0].text;
            if (orgName == nil || [orgName isEqualToString:@""]) {
                [CommonFunctionController showHUDWithMessage:@"公司或团队名称不能为空" success:NO];
                return;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [CommonFunctionController showAnimateMessageHUD];
                [DataRequest createOrgWithOrgName:orgName success:^{
                    [CommonFunctionController showHUDWithMessage:@"创建公司或团队成功！" success:YES];
                    [self reloadAllData]; //创建成功之后更新组织相关信息
                } failure:^(NSString *message) {
                    [CommonFunctionController showHUDWithMessage:message success:NO];
                }];
            });
        }
    } //创建组织
    else {
        if (buttonIndex != 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [CommonFunctionController showAnimateMessageHUD];
                [DataRequest cancelOrgApplyingWithOrgID:_org.orgID success:^{
                    [CommonFunctionController showHUDWithMessage:@"取消申请成功！" success:YES];
//                  [self setupNavigationBar];
                    self.tipMessageLabel.hidden = YES;
                    self.applyingImageView.hidden = YES;
                    self.cancelButton.hidden = YES;
                    self.applyingLabel.hidden = YES;

                } failure:^(NSString *message) {
                    [CommonFunctionController showHUDWithMessage:message success:NO];
                }];
            });
        }
    } //取消申请
}

#pragma - UITableView datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    NSInteger count = _orgMessageArray.count;
    //    if (_isShowTask) {
    //        count = count + 1;
    //    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ManagerTableViewCell class])];
    if (cell == nil) {
        cell = [ManagerTableViewCell loadFromNib];
    }
    
//    _isShowTask=NO;
//    if (_isShowTask) {
//        switch (indexPath.row) {
//            case 0: {
//                cell.title = @"任务";
//                cell.imageName = @"cell-task";
//                cell.subTitle = _lastestTask.content;
//                cell.time = [[_lastestTask.updateTime stringToDateWithFormatter:@"yyyy-MM-dd HH:mm:ss"] dateToStringWithFormatter:@"yyyy-MM-dd"];
//                cell.badgeCount = [_taskBagdgeNumber integerValue];
//                cell.isRead = NO;
//                cell.imageIsShow = YES;
//                break;
//            }
//            default: {
//                OrgMessage *orgMessage = (OrgMessage *)_orgMessageArray[indexPath.row - 1];
//                cell.title = [orgMessage title];
//                cell.imageName = @"cell-organization";
//                cell.subTitle = [orgMessage content];
//                cell.time = [[[orgMessage updateTime] stringToDateWithFormatter:@"yyyy-MM-dd HH:mm:ss"] dateToStringWithFormatter:@"yyyy-MM-dd"];
//                cell.badgeCount = 0;
//                cell.imageIsShow = YES;
//                cell.isRead = [orgMessage.isRead isEqualToString:orgMessageHasRead];
//                cell.type = [orgMessage.action integerValue];
//                break;
//            }
//        }
//    }
//    else {
//        OrgMessage *orgMessage = (OrgMessage *)_orgMessageArray[indexPath.row];
//        cell.title = [orgMessage title];
//        cell.imageName = @"cell-organization";
//        cell.subTitle = [orgMessage content];
//        cell.time = [[[orgMessage updateTime] stringToDateWithFormatter:@"yyyy-MM-dd HH:mm:ss"] dateToStringWithFormatter:@"yyyy-MM-dd"];
//        cell.badgeCount = 0;
//        cell.imageIsShow = YES;
//        cell.isRead = [orgMessage.isRead isEqualToString:orgMessageHasRead];
//        cell.type = [orgMessage.action integerValue];
//    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    OrgMessage *orgMessage = (OrgMessage *)_orgMessageArray[indexPath.section];
    cell.title = [orgMessage title];
    cell.imageName = @"cell-organization";
    cell.subTitle = [orgMessage content];
    cell.time = [[[orgMessage updateTime] stringToDateWithFormatter:@"yyyy-MM-dd HH:mm:ss"] dateToStringWithFormatter:@"MM-dd"];
    cell.badgeCount = 0;
    cell.imageIsShow = YES;
    cell.isRead = [orgMessage.isRead isEqualToString:orgMessageHasRead];
    cell.type = [orgMessage.action integerValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (_isShowTask) {
//        switch (indexPath.row) {
//            case 0: {
//                TaskManagerViewController *taskManagerViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TaskManagerViewController class])];
//                [self.tabBarController.navigationController pushViewController:taskManagerViewController animated:YES];
//                break;
//            }
//            default: {
//                OrgMessage *orgMessage = (OrgMessage *)_orgMessageArray[indexPath.row - 1];
//                [self pushOrgMessageDetail:orgMessage];
//                break;
//            }
//        }
//    }
//    else {
//        OrgMessage *orgMessage = (OrgMessage *)_orgMessageArray[indexPath.row];
//        [self pushOrgMessageDetail:orgMessage];
//    }
    
    OrgMessage *orgMessage = (OrgMessage *)_orgMessageArray[indexPath.section];
    if (orgMessage.urlPath) {
        [self pushOrgMessageUrlPath:orgMessage];
    }else
    {
        [self pushOrgMessageDetail:orgMessage];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)pushOrgMessageUrlPath:(OrgMessage *)orgMessage
{
    _isDetailBack = YES;
    OrgMessageUrlPathViewController *urlPathViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([OrgMessageUrlPathViewController class])];
    urlPathViewController.orgMessage=orgMessage;
    [self.tabBarController.navigationController pushViewController:urlPathViewController animated:YES];

}

@end
