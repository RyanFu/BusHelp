//
//  NSDate+custom.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/18.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "NSDate+custom.h"

@implementation NSDate (custom)

- (NSString *)dateToStringWithFormatter:(NSString *)formatter {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    
    return [dateFormatter stringFromDate:self];
}

@end
