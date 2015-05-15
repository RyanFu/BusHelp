//
//  NetWorkReachability.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/23.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    NetworkReachStatusReach,
    NetworkReachStatusUnReach,
} NetworkReachStatus;

@interface NetWorkReachability : NSObject

LCSINGLETON_IN_H(NetWorkReachability)

@property (nonatomic, assign, readonly) NetworkReachStatus networkStatus;

@end
