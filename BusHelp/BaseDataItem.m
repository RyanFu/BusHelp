//
//  BaseDataItem.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/19.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "BaseDataItem.h"

static NSString *const successCode = @"E_0000";
static NSString *const needAuthCode = @"E_0003";

@implementation BaseDataItem

- (instancetype)initWithDictionary:(NSDictionary *)dataDictionary {
    if (self = [super init]) {
        if ([CommonFunctionController checkValueValidate:dataDictionary] != nil) {
            _code = [dataDictionary objectForKey:@"error_code"];
            _message = [dataDictionary objectForKey:@"error_message"];
            _data = [dataDictionary objectForKey:@"data"];
            if ([_code isEqualToString:successCode]) {
                _success = YES;
            }
            else {
                _success = NO;
                if ([_code isEqualToString:needAuthCode]) {
                    _needAuth = YES;
                }
            }
        }
    }
    
    return self;
}

@end
