//
//  HomeTabBarController.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/21.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "HomeTabBarController.h"
#import "SplashViewController.h"
#import "LoginViewController.h"
#import "OrgMessageDetailViewController.h"
#import "TaskManagerViewController.h"
#import "DataRequest.h"
#import "ViolationViewController.h"
#import "UserSettingInfo.h"

@interface HomeTabBarController ()

@end

@implementation HomeTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self commonInit];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseNotification:) name:responseNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupBadgeNumber) name:updateBadgeValueKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needLogin) name:againNeedLoginKey object:nil];
    [self setupBadgeNumber];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self showSplash];
    });
    if (![UserSettingInfo checkIsLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:againNeedLoginKey object:nil];
    }

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:responseNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:updateBadgeValueKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:againNeedLoginKey object:nil];
}

- (void)setupBadgeNumber {
//    NSInteger spotTaskCount = [DataFetcher fetchTaskCountByStatus:TaskStatusSpot];
//    NSInteger orgMessageNotReadCount = [DataFetcher fetchNotReadOrgMessageCount];
//    NSString *badgeValue = nil;
//    if (spotTaskCount != 0 || orgMessageNotReadCount != 0) {
//        badgeValue = @(spotTaskCount + orgMessageNotReadCount).stringValue;
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [(UITabBarItem *)self.tabBar.items[0] setBadgeValue:badgeValue];
//    });
    
    NSInteger orgMessageNotReadCount = [DataFetcher fetchNotReadOrgMessageCount];
    NSString *badgeValue1 = nil;

    if (orgMessageNotReadCount != 0) {
        badgeValue1 = @(orgMessageNotReadCount).stringValue;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [(UITabBarItem *)self.tabBar.items[0] setBadgeValue:badgeValue1];

    });
    
    NSInteger spotTaskCount = [DataFetcher fetchTaskCountByStatus:TaskStatusSpot];
    NSString *badgeValue2 = nil;
    
    if (spotTaskCount != 0) {
        badgeValue2 = @(spotTaskCount).stringValue;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [(UITabBarItem *)self.tabBar.items[2] setBadgeValue:badgeValue2];
        
    });


}

- (void)needLogin {
    LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginViewController class])];
    [self.navigationController pushViewController:loginViewController animated:YES];
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

}

- (void)showSplash {
    if (![UserSettingInfo fetchSplashHasShown]) {
        SplashViewController *splashViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SplashViewController class])];
        [self.navigationController presentViewController:splashViewController animated:YES completion:nil];
    }
}

- (void)responseNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NotificationContentType type = [[userInfo objectForKey:@"contentType"] integerValue];
    NSString *referenceID = [userInfo objectForKey:@"referenceID"];
    if (type == NotificationContentTypeViolation) {
        self.selectedIndex = 0;
        if ([self.selectedViewController isKindOfClass:[ViolationViewController class]]) {
            ViolationViewController *violationViewController = (ViolationViewController *)self.selectedViewController;
            violationViewController.referenceID = referenceID;
        }
    }
    else {
        if ([UserSettingInfo checkIsLogin]) {
            [self showNotificationPageWithType:type referenceID:referenceID];
        }
        else {
            if (![self.navigationController.visibleViewController isKindOfClass:[LoginViewController class]] && self.selectedIndex != 2) {
                LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginViewController class])];
                loginViewController.isNotification = YES;
                [loginViewController setLoginSuccessBlock:^{
                    [self showNotificationPageWithType:type referenceID:referenceID];
                }];
                [self.navigationController pushViewController:loginViewController animated:YES];
            }
        }
    }
}

- (void)showNotificationPageWithType:(NotificationContentType)type referenceID:(NSString *)referenceID {
    if (type == NotificationContentTypeMessage) {
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest fetchOrgWithSuccess:^(NSArray *orgArray) {
            if ([CommonFunctionController checkValueValidate:orgArray] != nil) {
                [CommonFunctionController hideAllHUD];
                Org *org = [orgArray firstObject];
                if ([self.navigationController.visibleViewController isKindOfClass:[OrgMessageDetailViewController class]]) {
                    OrgMessageDetailViewController *orgMessageDetailController = (OrgMessageDetailViewController *)self.navigationController.visibleViewController;
                    [orgMessageDetailController.navigationController popViewControllerAnimated:NO];
                }
                OrgMessageDetailViewController *orgMessageDetailController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([OrgMessageDetailViewController class])];
                orgMessageDetailController.status = [org.status integerValue];
                orgMessageDetailController.referenceID = referenceID;
                [self.navigationController pushViewController:orgMessageDetailController animated:YES];
            }
            else {
                [CommonFunctionController showHUDWithMessage:ERROR_MESSAGE_4 success:NO];
            }
        } failure:^(NSString *message) {
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
    else {
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest fetchOrgWithSuccess:^(NSArray *orgArray) {
            if ([CommonFunctionController checkValueValidate:orgArray] != nil) {
                Org *org = [orgArray firstObject];
                if ([org.status integerValue] == OrgStatusJoined) {
                    [CommonFunctionController hideAllHUD];
                    if ([self.navigationController.visibleViewController isKindOfClass:[TaskManagerViewController class]]) {
                        TaskManagerViewController *taskManagerViewController = (TaskManagerViewController *)self.navigationController.visibleViewController;
                        [taskManagerViewController showDetailViewWithReferenceID:referenceID];
                    }
                    else {
                        TaskManagerViewController *taskManagerController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TaskManagerViewController class])];
                        taskManagerController.isNotification = YES;
                        taskManagerController.referenceID = referenceID;
                        [self.navigationController pushViewController:taskManagerController animated:YES];
                    }
                }
                else {
                    [CommonFunctionController showHUDWithMessage:ERROR_MESSAGE_4 success:NO];
                }
            }
            else {
                [CommonFunctionController showHUDWithMessage:ERROR_MESSAGE_4 success:NO];
            }
        } failure:^(NSString *message) {
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
}

@end
