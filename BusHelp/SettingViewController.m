//
//  SettingViewController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/21.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "SettingViewController.h"
#import "FeedbackViewController.h"
#import "VehicleManagerViewController.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"
#import "AboutViewController.h"
#import "CheckVersionInfo.h"
#import "NotificationSettingViewController.h"
#import "HelpViewController.h"
#import "SettingTableViewCell.h"
#import "HeadPortraitCell.h"
#import <ShareSDK/ShareSDK.h>
#import "DataRequest.h"
#import "Org.h"
#import "OrgSettingViewController.h"
#import "CreatOrJionViewController.h"

@interface SettingViewController (){
    NSArray *_orgArray;
    Org *_org;
    BOOL showApplyCell;
}

//@property (weak, nonatomic) IBOutlet UILabel *accountInfoLabel;
//@property (weak, nonatomic) IBOutlet UILabel *versionInfoLabel;


- (void)feedbackViewTapped;//留言
//- (IBAction)busManagerViewTapped;//车辆管理
- (void)accountViewTapped;//当前账号
- (void)aboutViewTapped;//关于我们
//- (IBAction)checkVersionViewTapped;
- (void)notificationViewTapped;//消息设置
- (void)helpViewTapped;//使用帮助
- (void)createorjoinViewTapped;//创建或加入组织

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    showApplyCell=NO;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 1;
    }else if(section==1)
    {
        return 1;
    }else if(section==2)
    {
        if (showApplyCell==NO) {
            return 3;
        }else if(showApplyCell==YES)
        {
            return 4;
        }
    }else if(section==3)
    {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 100;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellIdentifier = @"HeadPortraitCell";
        UINib *nib = [UINib nibWithNibName:@"HeadPortraitCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        
        HeadPortraitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.backgroundColor=[UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSString *accountInfo = @"未登录";
        if ([UserSettingInfo checkIsLogin]) {
            accountInfo = [UserSettingInfo fetchLoginUsername];
        }
        cell.accountinfo.text=accountInfo;
        cell.myImage.image=[UIImage imageNamed:@"HeadPortrait"];
        cell.myImage.layer.masksToBounds=YES;
        cell.myImage.layer.borderWidth=0.5;
        cell.myImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
        return cell;

       
    }else
    {
        static NSString *cellIdentifier = @"SettingTableViewCell";
        UINib *nib = [UINib nibWithNibName:@"SettingTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.backgroundColor=[UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.section==1&&indexPath.row==0) {
            cell.myLebal.text=@"消息设置";
            cell.myImageView.image=[UIImage imageNamed:@"setting-message"];
            
        }else if(indexPath.section==2&&indexPath.row==0)
        {
            cell.myLebal.text=@"使用帮助";
            cell.myImageView.image=[UIImage imageNamed:@"setting-help"];

        }else if(indexPath.section==2&&indexPath.row==1)
        {
            cell.myLebal.text=@"意见反馈";
            cell.myImageView.image=[UIImage imageNamed:@"setting-feedback"];

        }else if(indexPath.section==2&&indexPath.row==2)
        {
            cell.myLebal.text=@"我的团队";
            cell.myImageView.image=[UIImage imageNamed:@"setting-team"];
            
        }else if(indexPath.section==3&&indexPath.row==0)
        {
            cell.myLebal.text=@"关于我们";
            cell.myImageView.image=[UIImage imageNamed:@"setting-about"];

        }
        
        if(showApplyCell==YES)
        {
            if(indexPath.section==2&&indexPath.row==3)
            {
                cell.myLebal.text=@"推荐朋友使用";
                cell.myImageView.image=[UIImage imageNamed:@"setting-share"];

                
            }
        }
        cell.myImageView.backgroundColor=[UIColor groupTableViewBackgroundColor];
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0)
    {
        [self accountViewTapped];
    }else if (indexPath.section==1&&indexPath.row==0)
    {
        [self notificationViewTapped];

    }else if(indexPath.section==2&&indexPath.row==0)
    {
        [self helpViewTapped];

    }else if(indexPath.section==2&&indexPath.row==1)
    {
        [self feedbackViewTapped];

    }else if(indexPath.section==2&&indexPath.row==2)
    {
        if (_org != nil && [_org.status integerValue] == OrgStatusJoined) {
            [self ManagerMyteam];
        }else
        {
            [self createorjoinViewTapped];
        }

    }else if(indexPath.section==2&&indexPath.row==3)
    {
        [self applyOrgCellPressed];

    }else if(indexPath.section==3&&indexPath.row==0)
    {
        [self aboutViewTapped];

    }

}

-(void)ManagerMyteam
{
    OrgSettingViewController *orgSettingViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([OrgSettingViewController class])];
    orgSettingViewController.orgID = _org.orgID;
    orgSettingViewController.orgName = _org.name;
    orgSettingViewController.vehicleListArray = _org.vehicleList;
    orgSettingViewController.userType = _org.userType;
    [self.tabBarController.navigationController pushViewController:orgSettingViewController animated:YES];
}

- (void)setupOrgWithRequest:(BOOL)request {
    if (request && [CommonFunctionController checkNetworkWithNotify:NO]) {
            [DataRequest fetchOrgWithSuccess:^(NSArray *orgArray) {
            _orgArray = orgArray;
            _org = [_orgArray firstObject];
            NSLog(@"组织名称：%@",_org.name);
            NSLog(@"status:%li",(long)_org.status.integerValue);
            if (_org != nil ) {
                showApplyCell=YES;
            }else
            {
                showApplyCell=NO;
            }
            [self.SettingTable reloadData];
        } failure:^(NSString *message){
            showApplyCell=NO;
            [self.SettingTable reloadData];

        }];
    }
    else {
        [self.SettingTable reloadData];

    }
}

//邀请组织
- (void)applyOrgCellPressed{
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
//    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupNavigationBar];
    [self setupOrgWithRequest:YES];


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
}

//- (void)setupNavigationBar {
//    [super setupNavigationBar];
//    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    NSString *accountInfo = @"未登录";
//    if ([UserSettingInfo checkIsLogin]) {
//        accountInfo = [UserSettingInfo fetchLoginUsername];
//    }
//    self.accountInfoLabel.text = accountInfo;
//    [self setupVersionInfo];
//}

//- (void)setupVersionInfo {
//    if ([UserSettingInfo fetchAppLastestVersion] != nil) {
//        if (![[UserSettingInfo fetchAppVersion] isEqualToString:[UserSettingInfo fetchAppLastestVersion]]) {
//            self.versionInfoLabel.text = [NSString stringWithFormat:@"有最新版本%@", [UserSettingInfo fetchAppLastestVersion]];
//        }
//        else {
//            self.versionInfoLabel.text = @"已是最新版本";
//        }
//    }
//    else {
//        self.versionInfoLabel.text = @"已是最新版本";
//    }
//}

- (void)feedbackViewTapped {
    FeedbackViewController *feedbackViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FeedbackViewController class])];
    [self.tabBarController.navigationController pushViewController:feedbackViewController animated:YES];
}

- (void)busManagerViewTapped {
    VehicleManagerViewController *vehicleManagerViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([VehicleManagerViewController class])];
    vehicleManagerViewController.hiddenSearchButton = YES;
    [self.tabBarController.navigationController pushViewController:vehicleManagerViewController animated:YES];
}

- (void)accountViewTapped {
    if ([UserSettingInfo checkIsLogin]) {
        UserInfoViewController *userInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([UserInfoViewController class])];
        [self.tabBarController.navigationController pushViewController:userInfoViewController animated:YES];
    }
    else {
        LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginViewController class])];
        [self.tabBarController.navigationController pushViewController:loginViewController animated:YES];
    }
}

- (void)aboutViewTapped {
    AboutViewController *aboutViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AboutViewController class])];
    [self.tabBarController.navigationController pushViewController:aboutViewController animated:YES];
}

//- (void)checkVersionViewTapped {
//    CheckVersionInfo *checkVersionInfo = [[CheckVersionInfo alloc] init];
//    checkVersionInfo.isCheck = YES;
//    [CommonFunctionController showAnimateMessageHUD];
//    [checkVersionInfo checkVersionInfoWithSuccess:^{
//        [CommonFunctionController hideAllHUD];
//        self.versionInfoLabel.text = [NSString stringWithFormat:@"有最新版本%@", [UserSettingInfo fetchAppLastestVersion]];
//    } failure:^(NSString *message) {
//        if (![message isEqualToString:ERROR_MESSAGE_2]) {
//            [CommonFunctionController showHUDWithMessage:message success:NO];
//        }
//        else {
//            [CommonFunctionController hideAllHUD];
//        }
//    }];
//}

- (void)notificationViewTapped {
    NotificationSettingViewController *notificationController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NotificationSettingViewController class])];
    [self.tabBarController.navigationController pushViewController:notificationController animated:YES];
}

- (void)helpViewTapped {
    HelpViewController *helpViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HelpViewController class])];
    [self.tabBarController.navigationController presentViewController:helpViewController animated:YES completion:nil];
}

- (void)createorjoinViewTapped
{
    CreatOrJionViewController *createorjoinViewController=[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CreatOrJionViewController class])];
    [self.tabBarController.navigationController pushViewController:createorjoinViewController animated:YES];
}

@end
