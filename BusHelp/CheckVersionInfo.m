//
//  CheckVersionInfo.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/9.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "CheckVersionInfo.h"
#import "DataRequest.h"
#import "NSDate+custom.h"

@interface CheckVersionInfo () <UIAlertViewDelegate> {
    NSString *_versionUrl;
}

@end

@implementation CheckVersionInfo

- (void)checkVersionInfoWithSuccess:(void(^)())success failure:(void(^)(NSString *message))failure {
    NSString *lastTime = USERINFOFIND(@"last_check_version_time");
    if (![lastTime isEqualToString:[[NSDate date] dateToStringWithFormatter:@"yyyy-MM-dd"]] || self.isCheck) {
        [DataRequest checkVersionBySuccess:^(NSString *url) {
            success();
            USERINFOADD([[NSDate date] dateToStringWithFormatter:@"yyyy-MM-dd"], @"last_check_version_time");
            if ([CommonFunctionController checkValueValidate:url] != nil) {
                _versionUrl = url;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有最新版本，是否需要更新？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [alert show];
            }
        } failure:^(NSString *message){
            failure(message);
        }];
    }
    else {
        success();
    }
}

#pragma - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_versionUrl]];
    }
}

@end
