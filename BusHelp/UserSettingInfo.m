//
//  UserSettingInfo.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/21.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "UserSettingInfo.h"
#import "DataFetcher.h"
#import "SvUDIDTools.h"
#import <SDWebImage/SDImageCache.h>
#import <RNCryptor/RNEncryptor.h>
#import <RNCryptor/RNDecryptor.h>

@implementation UserSettingInfo

+ (BOOL)checkIsLogin {
    BOOL isLogin = YES;
    if ([CommonFunctionController checkValueValidate:[self fetchLoginToken]] == nil) {
        isLogin = NO;
    }
    
    return isLogin;
}

+ (void)setupDatabase {
    NSString *databaseName = DEFAULT_DATABASE_NAME;
    if ([self checkIsLogin]) {
        databaseName = [self fetchLoginUsername];
    }
    databaseName = [CommonFunctionController md5:databaseName];
    [DataFetcher setupCoreDataStackWithStoreNamed:databaseName];
}

+ (void)setupLoginUsername:(NSString *)username password:(NSString *)password token:(NSString *)token {
    USERINFOADD(username, @"login_username");
    USERINFOADD(token, @"token");
    
    NSError *error = nil;
    NSData *encryptedPasswordData = [RNEncryptor encryptData:[password dataUsingEncoding:NSUTF8StringEncoding] withSettings:kRNCryptorAES256Settings password:HMACSHA1KEY error:&error];
    if (error != nil) {
        DLog(@"----------encryptedPasswordData error = %@---------", error);
    }
    else {
        USERINFOADD(encryptedPasswordData, @"login_encrypted_password");
    }
    //[self setupDatabase];
}

+ (NSString *)fetchLoginUsername {
    return USERINFOFIND(@"login_username");
}

+ (NSString *)fetchLoginPassword {
    NSError *error = nil;
    NSData *decryptedPasswordData = [RNDecryptor decryptData:USERINFOFIND(@"login_encrypted_password") withPassword:HMACSHA1KEY error:&error];
    NSString *password = @"";
    if (error != nil) {
        DLog(@"----------decryptedPasswordData error = %@---------", error);
    }
    else {
        password = [[NSString alloc] initWithData:decryptedPasswordData encoding:NSUTF8StringEncoding];
    }
    
    return password;
}

+ (NSString *)fetchLoginToken {
    return USERINFOFIND(@"token");
}

+ (void)removeToken {
    USERINFOREMOVE(@"token");
}

+ (void)cleanupLoginInfo {
    USERINFOREMOVE(@"login_username");
    USERINFOREMOVE(@"token");
    USERINFOREMOVE(@"login_encrypted_password");
    [self setupDatabase];
}

+ (void)setupSplashHasShown {
    USERINFOADD([NSNumber numberWithBool:YES], @"splash_has_shown");
}

+ (BOOL)fetchSplashHasShown {
    return [USERINFOFIND(@"splash_has_shown") boolValue];
}

+ (void)setupDeviceID {
    if ([CommonFunctionController checkValueValidate:[self fetchDeviceID]] == nil) {
        USERINFOADD([SvUDIDTools UDID], @"device_id");
    }
}

+ (NSString *)fetchDeviceID {
    return USERINFOFIND(@"device_id");
}

+ (void)userLogWithMessage:(id)object {
    if ([object isKindOfClass:[NSError class]]) {
        DLog(@"method = %s, error = %@", __FUNCTION__, object);
    }
    else {
        DLog(@"method = %s, message = %@", __FUNCTION__, object);
    }
}

+ (void)setupImageCache {
    [[SDImageCache sharedImageCache] setMaxCacheAge:NSIntegerMax];
    [[SDImageCache sharedImageCache] setMaxCacheSize:NSIntegerMax];
}

+ (NSString *)fetchAppVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)fetchAppLastestVersion {
    return USERINFOFIND(@"lastest_app_version");
}

+ (void)saveAppLastestVersion:(NSString *)version {
    USERINFOADD(version, @"lastest_app_version");
}

+ (void)setupNetworking {
    [[AFHTTPRequestOperationManager manager].operationQueue setMaxConcurrentOperationCount:3];
    [self setupImageCache];
}

+ (void)setupNotification:(BOOL)isNotification {
    USERINFOADD([NSNumber numberWithBool:isNotification], @"app_is_notification");
}

+ (BOOL)fetchNotificationStatus {
    NSNumber *status = USERINFOFIND(@"app_is_notification");
    if (status == nil) {
        [self setupNotification:YES];
    }
    return [USERINFOFIND(@"app_is_notification") boolValue];
}

+ (void)setupPushDeviceToken:(NSString *)deviceToken {
    USERINFOADD(deviceToken, @"push_device_token");
}

+ (NSString *)fetchPushDeviceToken {
    if (USERINFOFIND(@"push_device_token") == nil) {
        return @"";
    }
    return USERINFOFIND(@"push_device_token");
}

+ (BOOL)fetchHelpIsReadByKey:(NSString *)key {
    NSMutableDictionary *helpDic = [NSMutableDictionary dictionaryWithDictionary:USERINFOFIND(@"help_shown_by_key")];
    if (helpDic == nil) {
        helpDic = [NSMutableDictionary dictionaryWithCapacity:2];
        for (NSInteger i = 1; i <= 8; i++) {
            [helpDic setObject:@(NO) forKey:[NSString stringWithFormat:@"help-%@", @(i)]];
        }
        USERINFOADD(helpDic, @"help_shown_by_key");
    }
    
    return [[helpDic objectForKey:key] boolValue];
}

+ (void)setupHelpReadByKey:(NSString *)key {
    NSMutableDictionary *helpDic = [NSMutableDictionary dictionaryWithDictionary:USERINFOFIND(@"help_shown_by_key")];
    if (helpDic == nil) {
        helpDic = [NSMutableDictionary dictionaryWithCapacity:2];
        for (NSInteger i = 1; i <= 8; i++) {
            [helpDic setObject:@(NO) forKey:[NSString stringWithFormat:@"help-%@", @(i)]];
        }
    }
    [helpDic setObject:@(YES) forKey:key];
    USERINFOADD(helpDic, @"help_shown_by_key");
}

@end
