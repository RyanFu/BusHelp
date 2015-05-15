//
//  ErrorHandler.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/17.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorHandler : NSObject

LCSINGLETON_IN_H(ErrorHandler)

- (void)handlerError:(NSError *)error;

@end
