//
//  CheckVersionInfo.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/9.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckVersionInfo : NSObject

@property (nonatomic, assign) BOOL isCheck;

- (void)checkVersionInfoWithSuccess:(void(^)())success failure:(void(^)(NSString *message))failure;

@end
