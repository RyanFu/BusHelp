//
//  ImageCache.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/11.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ImageCache.h"
#import <SDWebImage/SDImageCache.h>

@implementation ImageCache

+ (BOOL)hasCacheForKey:(NSString *)key {
    return [[SDImageCache sharedImageCache] diskImageExistsWithKey:key];
}

+ (void)storeCache:(UIImage *)image forKey:(NSString *)key {
    [[SDImageCache sharedImageCache] storeImage:image forKey:key];
}

+ (UIImage *)cacheForKey:(NSString *)key {
    return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
}

+ (void)clearCacheWithKeyArray:(NSArray *)keyArray {
    for (NSString *key in keyArray) {
        [[SDImageCache sharedImageCache] removeImageForKey:key];
    }
}

@end
