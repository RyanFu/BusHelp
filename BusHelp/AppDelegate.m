//
//  AppDelegate.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/15.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "AppDelegate.h"
#import "CheckVersionInfo.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import "WeiboApi.h"
#import "APService.h"
#import "DataRequest.h"
#import "Sql_Utils.h"

@interface AppDelegate () <UIAlertViewDelegate> {
    NSDictionary *_userInfo;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //设置状态栏风格
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //设置navigationBar tintColor
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:22.0f/255.0f green:164.0f/255.0f blue:220.0f/255.0f alpha:1.0f]];

    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor =[UIColor whiteColor];
    shadow.shadowOffset = CGSizeMake(0, 0);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Helvetica" size:20.0], NSFontAttributeName, nil]];
    

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
//    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"bushelp.db"];
    NSLog(@"%@",documentDirectory);
//    [self removeFileAtPath:dbPath];
    

    // Override point for customization after application launch.
    [UserSettingInfo setupDatabase];
    [UserSettingInfo setupDeviceID];
    [UserSettingInfo setupNetworking];
    [NetWorkReachability sharedInstance];
    
//    CheckVersionInfo *checkVersionInfo = [[CheckVersionInfo alloc] init];
//    [checkVersionInfo checkVersionInfoWithSuccess:^{
//        
//    } failure:^(NSString *message) {
//        
//    }];
    [ShareSDK registerApp:SHARE_SDK_KEY];
    [self initializePlat];
    if ([UserSettingInfo fetchNotificationStatus]) {
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
        [APService setupWithOption:launchOptions];
        
        //应用启动时推送
        NSDictionary* userInfo = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self didReceiveNotificationUserInfo:userInfo isLaunched:YES];
    }
    else {
        [application unregisterForRemoteNotifications];
    }
    
    return YES;
}

- (void)removeFileAtPath:(NSString *)filePath {
    
    NSError *error = nil;
    if ([self isFileExitsAtPath:filePath]) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:&error];
        NSLog(@"clean success");
    }
}

- (BOOL)isFileExitsAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath isDirectory:NULL]) {
        return YES;
    }
    
    return NO;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url {
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation
                        wxDelegate:self];
}

- (void)initializePlat {
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:SINA_WEIBO_APPKEY
                               appSecret:SINA_WEIBO_APPSECRET
                             redirectUri:SHARE_REDIRECT_URL];
    
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:TENCENT_WEIBO_APPKEY
                                  appSecret:TENCENT_WEIBO_APPSECRET
                                redirectUri:SHARE_REDIRECT_URL
                                   wbApiCls:[WeiboApi class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:WX_APPID wechatCls:[WXApi class]];
    
    //连接短信分享
    [ShareSDK connectSMS];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
    NSString *deviceTokenString = [[[[deviceToken description]stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    DLog(@"-----------deviceTokenString = %@----------", deviceTokenString);
    [UserSettingInfo setupPushDeviceToken:deviceTokenString];
    [self registerAlienPush];
    [DataRequest saveDeviceWithSuccess:^{
        
    } failure:^(NSString *message) {
        
    }];
}

//注册推送别名
- (void)registerAlienPush {
//    NSString *alien = @"";
//    if ([UserSettingInfo fetchNotificationStatus]) {
//        alien = [[UserSettingInfo fetchDeviceID] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    }
    [APService setAlias:[[UserSettingInfo fetchDeviceID] stringByReplacingOccurrencesOfString:@"-" withString:@""] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}


- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    DLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self didReceiveNotificationUserInfo:userInfo isLaunched:NO];
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [self didReceiveNotificationUserInfo:userInfo isLaunched:NO];
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    DLog(@"-------push error = %@", error);
}

- (void)didReceiveNotificationUserInfo:(NSDictionary *)userInfo isLaunched:(BOOL)isLaunched {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if ([CommonFunctionController checkValueValidate:userInfo] != nil) {
        _userInfo = userInfo;
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
            NSString *content = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"易管车" message:content delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
            [alert show];
        }
        else {
            [self responseNotification];
        }
    }
}

- (void)responseNotification {
    if ([CommonFunctionController checkValueValidate:_userInfo] != nil) {
        NSString *contentType = [_userInfo objectForKey:@"content_type"];
        NSString *referenceID = [_userInfo objectForKey:@"reference_id"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:responseNotificationKey object:nil userInfo:@{@"contentType" : contentType, @"referenceID" : referenceID}];
        });
    }
}

#pragma - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        [self responseNotification];
    }
}

@end
