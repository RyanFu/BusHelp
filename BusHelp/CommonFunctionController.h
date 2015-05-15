//
//  CommonFunctionController.h
//  IToyDeal
//
//  Created by Tony on 13-12-24.
//  Copyright (c) 2013年 gourp toy1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonFunctionController : NSObject

+ (id)checkValueValidate:(id)text;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;
+ (BOOL)validateCarNo:(NSString *)carNumber;
+ (void)showHUDWithMessage:(NSString *)message success:(BOOL)success;
+ (void)showHUDWithMessage:(NSString *)message detail:(NSString *)detail;
+ (void)showAnimateHUDWithMessage:(NSString *)message;
+ (void)hideAllHUD;
+ (NSString *)md5:(NSString *)str;
+ (NSString *)hmac:(NSString *)plainText withKey:(NSString *)key;
+ (BOOL)checkNetworkWithNotify:(BOOL)isNotify;
+ (NSString *)encodeToPercentEscapeString:(NSString *)input;
+ (NSString *)decodeFromPercentEscapeString:(NSString *)input;
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
+ (BOOL)checkUrlValidate:(NSString *)url;
+ (void)resignFirstResponderByView:(UIView *)view;
+ (void)removeAllSubviewByView:(UIView *)view;
+ (void)showAnimateMessageHUD;
+ (UIImage *)captureWithView:(UIView *)view;
+ (NSArray *)allSubviews:(UIView *)aView;

@end
