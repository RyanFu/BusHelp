//
//  NetBaseService.h
//  HigerGbos
//
//  Created by KevinMao on 14-6-11.
//  Copyright (c) 2014年 Jijesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetBaseService : NSObject

- (void)get:(NSString *)url
 parameters:(NSMutableDictionary *)parameters
    success:(void (^)(int code, NSString *msg, id data))success
      error:(void (^)(int code, NSString *msg))error
    failure:(void (^)(NSError *failure))failure;

- (void)post:(NSString *)url
  parameters:(NSMutableDictionary *)parameters
     success:(void (^)(int code, NSString *msg, id data))success
       error:(void (^)(int code, NSString *msg))error
     failure:(void (^)(NSError *failure))failure;

@end
