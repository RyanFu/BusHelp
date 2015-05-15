//
//  NSString+custom.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/25.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "NSString+custom.h"

@implementation NSString (custom)

- (NSDate *)stringToDateWithFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: formatter];
    return [dateFormatter dateFromString:self];
}

@end
