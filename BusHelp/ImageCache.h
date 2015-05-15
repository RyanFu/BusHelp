//
//  ImageCache.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/11.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

+ (BOOL)hasCacheForKey:(NSString *)key;

+ (void)storeCache:(UIImage *)image forKey:(NSString *)key;

+ (UIImage *)cacheForKey:(NSString *)key;

+ (void)clearCacheWithKeyArray:(NSArray *)keyArray;

@end
