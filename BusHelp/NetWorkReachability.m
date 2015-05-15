//
//  NetWorkReachability.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/23.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "NetWorkReachability.h"
#import <Reachability/Reachability.h>

@interface NetWorkReachability ()

@end

@implementation NetWorkReachability

LCSINGLETON_IN_M(NetWorkReachability)

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    __block AFNetworkReachabilityStatus currentStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        if (currentStatus != status) {
//            currentStatus = status;
//            NSString *message = @"当前网络连接不稳定!";
//            BOOL success = NO;
//            if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
//                _networkStatus = NetworkReachStatusUnReach;
//            }
//            else {
//                _networkStatus = NetworkReachStatusReach;
//                message = @"当前网络连接稳定!";
//                success = YES;
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [CommonFunctionController showHUDWithMessage:message success:success];
//            });
//        }
//    }];
    
    Reachability *internetConnectionReach = [Reachability reachabilityForInternetConnection];
    _networkStatus = internetConnectionReach.currentReachabilityStatus == NotReachable ? NetworkReachStatusUnReach : NetworkReachStatusReach;
    internetConnectionReach.reachableBlock = ^(Reachability * reachability) {
        NSString * temp = [NSString stringWithFormat:@"InternetConnection Says Reachable(%@)", reachability.currentReachabilityString];
        DLog(@"network = %@", temp);
        _networkStatus = NetworkReachStatusReach;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [CommonFunctionController showHUDWithMessage:@"当前网络连接稳定!" success:YES];
        });
    };
    
    internetConnectionReach.unreachableBlock = ^(Reachability * reachability) {
        NSString * temp = [NSString stringWithFormat:@"InternetConnection Block Says Unreachable(%@)", reachability.currentReachabilityString];
        DLog(@"network = %@", temp);
        _networkStatus = NetworkReachStatusUnReach;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [CommonFunctionController showHUDWithMessage:@"当前网络连接不稳定!" success:NO];
        });
    };
    
    [internetConnectionReach startNotifier];
}

@end
