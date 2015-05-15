//
//  ImageDownloader.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/11.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ImageDownloader.h"
#import "ImageCache.h"

@interface ImageDownloader () {
    AFHTTPRequestOperation *_operation;
}

@end

@implementation ImageDownloader

- (void)downloadImageWithUrl:(NSString *)url success:(void(^)(UIImage *image))success failure:(void(^)())failure {
    if (![ImageCache hasCacheForKey:url]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        _operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (responseObject != nil) {
                @autoreleasepool {
                    [ImageCache storeCache:[UIImage imageWithData:responseObject] forKey:url];
                }
                success([ImageCache cacheForKey:url]);
            }
            else {
                failure();
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure();
        }];
        [[AFHTTPRequestOperationManager manager].operationQueue addOperation:_operation];
    }
    else {
        success([ImageCache cacheForKey:url]);
    }
}

- (void)cancleDownload {
    if ([_operation isExecuting]) {
        [_operation cancel];
    }
}

@end
