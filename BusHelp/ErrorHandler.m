//
//  ErrorHandler.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/17.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ErrorHandler.h"

@implementation ErrorHandler

LCSINGLETON_IN_M(ErrorHandler)

- (void)handlerError:(NSError *)error {
    DLog(@"--method = %s, error = %@", __FUNCTION__, error);
}

@end
