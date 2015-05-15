//
//  ImageDownloader.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/11.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDownloader : NSObject

- (void)downloadImageWithUrl:(NSString *)url success:(void(^)(UIImage *image))success failure:(void(^)())failure;

- (void)cancleDownload;

@end
