//
//  BaseDataItem.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/19.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDataItem : NSObject

@property (nonatomic, assign, readonly) BOOL success;
@property (nonatomic, strong, readonly) NSString *code;
@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, strong, readonly) id data;
@property (nonatomic, assign, readonly) BOOL needAuth;

- (instancetype)initWithDictionary:(NSDictionary *)dataDictionary;

@end
