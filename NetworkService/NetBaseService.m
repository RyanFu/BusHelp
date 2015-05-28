//
//  NetBaseService.m
//  HigerGbos
//
//  Created by KevinMao on 14-6-11.
//  Copyright (c) 2014年 Jijesoft. All rights reserved.
//

#import "NetBaseService.h"
#import "AFHTTPRequestOperationManager.h"
#import "BaseInfo.h"

@implementation NetBaseService

- (void)get:(NSString *)url
 parameters:(NSMutableDictionary *)parameters
    success:(void (^)(int code, NSString *msg, id data))success
      error:(void (^)(int code, NSString *msg))error
    failure:(void (^)(NSError *failure))failure
{
    [self request:url parameters:parameters method:@"get" success:success error:error failure:failure];
}

- (void)post:(NSString *)url
  parameters:(NSMutableDictionary *)parameters
     success:(void (^)(int code, NSString *msg, id data))success
       error:(void (^)(int code, NSString *msg))error
     failure:(void (^)(NSError *failure))failure
{
    [self request:url parameters:parameters method:@"post" success:success error:error failure:failure];
}

- (void)request:(NSString *)url
     parameters:(NSMutableDictionary *)parameters
         method:(NSString *)method
        success:(void (^)(int code, NSString *msg, id data))success
          error:(void (^)(int code, NSString *msg))error
        failure:(void (^)(NSError *failure))failure
{
    if ([BaseInfo isDebug]) {
        NSLog(@"request infomation");
        NSLog(@"url:%@", url);
        NSLog(@"parameters:%@", parameters);
        NSLog(@" ");
    }
    
    //获取请求对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //设置请求以及响应的解析方式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if ([method isEqualToString:@"get"]) {
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:url parameters:parameters error:nil];
        request.timeoutInterval = 15; //设置超时时间
        AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self doSuccess:operation responseObject:responseObject success:success error:error];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self doFailure:operation error:error failure:failure];
        }];
        [manager.operationQueue addOperation:operation];
    }
    else {
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:url parameters:parameters error:nil];
        request.timeoutInterval = 15; //设置超时时间
        AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self doSuccess:operation responseObject:responseObject success:success error:error];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self doFailure:operation error:error failure:failure];
        }];
        [manager.operationQueue addOperation:operation];
    }
}

- (void)doSuccess:(AFHTTPRequestOperation *)operation
   responseObject:(id)responseObject
          success:(void (^)(int code, NSString *msg, id data))success
            error:(void (^)(int code, NSString *msg))error
{
    if ([BaseInfo isDebug]) {
        NSLog(@"request success");
        NSLog(@"operation.request.URL:%@", operation.request.URL);
        NSLog(@"operation.userInfo:%@", operation.userInfo);
        NSLog(@"operation.responseString:%@", operation.responseString);
        NSLog(@"responseObject:%@", responseObject);
        NSLog(@" ");
    }
    
    NSDictionary *result = (NSDictionary *)responseObject;
    int code = [[result objectForKey:@"code"] intValue];
    NSString *msg = [result objectForKey:@"message"];
    if (code == 0) {
        if ([result.allKeys containsObject:@"data"]) {
            id data = [result objectForKey:@"data"];
            success(code, msg, data);
        }
        else {
            success(code, msg, nil);
        }
    } //验证成功
    else {
        error(code, msg);
    } //验证失败
}

- (void)doFailure:(AFHTTPRequestOperation *)operation error:(NSError *)error failure:(void (^)(NSError *failure))failure
{
    if ([BaseInfo isDebug]) {
        NSLog(@"request failure");
        NSLog(@"operation.request.URL:%@", operation.request.URL);
        NSLog(@"operation.userInfo:%@", operation.userInfo);
        NSLog(@"operation.responseString:%@", operation.responseString);
        NSLog(@"failure:%@", error);
        NSLog(@" ");
    }
    
    failure(error);
}

@end
