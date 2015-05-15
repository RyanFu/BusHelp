//
//  NotificationSettingViewController.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/13.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "NotificationSettingViewController.h"
#import "APService.h"

@interface NotificationSettingViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;


- (IBAction)notificationSwitchValueChanged:(UISwitch *)sender;


@end

@implementation NotificationSettingViewController

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
    self.navigationItem.title = @"消息设置";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.notificationSwitch setOn:[UserSettingInfo fetchNotificationStatus] animated:YES];
}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)notificationSwitchValueChanged:(UISwitch *)sender {
    [UserSettingInfo setupNotification:sender.on];
    if (sender.on) {
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    }
    else {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
//    if ([CommonFunctionController checkNetworkWithNotify:YES]) {
//        [UserSettingInfo setupNotification:sender.on];
//        if (sender.on) {
//            [APService setAlias:[[UserSettingInfo fetchDeviceID] stringByReplacingOccurrencesOfString:@"-" withString:@""] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
//            //[[UIApplication sharedApplication] registerForRemoteNotifications];
//        }
//        else {
//            [APService setAlias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
//            //[[UIApplication sharedApplication] unregisterForRemoteNotifications];
//        }
//    }
//    else {
//        [sender setOn:!sender.on animated:YES];
//    }
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    DLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

@end
