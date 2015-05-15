//
//  CommonFunctionController.m
//  IToyDeal
//
//  Created by Tony on 13-12-24.
//  Copyright (c) 2013年 gourp toy1. All rights reserved.
//

#import "CommonFunctionController.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Base64nl/Base64.h>
#import "UIView+custom.h"

@implementation CommonFunctionController

//检查值是否有效
+ (id)checkValueValidate:(id)text {
	id value = nil;
	if (text && ![text isEqual:[NSNull null]]) {
		if ([text isKindOfClass:[NSString class]] && ((NSString *)text).length != 0) {
			text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			value = text;
		}
		else if ([text isKindOfClass:[NSNumber class]]) {
			value = text;
		}
		else if (([text isKindOfClass:[NSDictionary class]] || [text isKindOfClass:[NSMutableDictionary class]]) && [((NSDictionary *)text) count] != 0) {
			value = text;
		}
		else if (([text isKindOfClass:[NSArray class]] || [text isKindOfClass:[NSMutableArray class]]) && [((NSArray *)text) count] != 0) {
			value = text;
		}
	}
	return value;
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

/*车牌号验证*/
+ (BOOL)validateCarNo:(NSString *)carNumber {
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carNumber];
}

+ (void)showHUDWithMessage:(NSString *)message success:(BOOL)success {
    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:message success:success];
}

+ (void)showHUDWithMessage:(NSString *)message detail:(NSString *)detail {
    [[UIApplication sharedApplication].keyWindow showHUDWithMessage:message detail:detail];
}

+ (void)showAnimateHUDWithMessage:(NSString *)message {
    [[UIApplication sharedApplication].keyWindow showAnimateHUDWithMessage:message];
}

+ (void)showAnimateMessageHUD {
    [self showAnimateHUDWithMessage:MESSAGE_1];
}

+ (void)hideAllHUD {
    [[UIApplication sharedApplication].keyWindow hideAllHUD];
}

+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

+ (NSString *)hmac:(NSString *)data withKey:(NSString *)key {
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64EncodedString];
    
    return [CommonFunctionController encodeToPercentEscapeString:hash];
}



+ (BOOL)checkNetworkWithNotify:(BOOL)isNotify {
    BOOL reach = YES;
    if ([[NetWorkReachability sharedInstance] networkStatus] == NetworkReachStatusUnReach) {
        if (isNotify) {
            [CommonFunctionController showHUDWithMessage:ERROR_MESSAGE_1 success:NO];
        }
        reach = NO;
    }
    
    return reach;
}

+ (NSString *)encodeToPercentEscapeString:(NSString *)input {
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)input,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8));
    return outputStr;
}

+ (NSString *)decodeFromPercentEscapeString:(NSString *)input {
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        }
        else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        DLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

+ (BOOL)checkUrlValidate:(NSString *)url {
    NSString *match = @"[a-zA-z]+://[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:url];
}

+ (NSArray *)allSubviews:(UIView *)aView {
    NSArray *results = [aView subviews];
    for (UIView *eachView in [aView subviews]) {
        NSArray *riz = [self allSubviews:eachView];
        if (riz) {
            results = [results arrayByAddingObjectsFromArray:riz];
        }
    }
    return results;
}

+ (void)resignFirstResponderByView:(UIView *)view {
    for (UIView *subView in [self allSubviews:view]) {
        if ([subView isKindOfClass:[UITextField class]] || [subView isKindOfClass:[UITextView class]]) {
            [subView resignFirstResponder];
        }
    }
}

+ (void)removeAllSubviewByView:(UIView *)view {
    for (UIView *subView in [self allSubviews:view]) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [(UIImageView *)subView setImage:nil];
        }
    }
}

+ (UIImage *)captureWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
