//
//  AttachmentImageView.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/9.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachmentImageView : UIImageView

- (void)downloadImageWithUrl:(NSString *)url success:(void(^)())success failure:(void(^)())failure;

- (void)cancelDownload;

@end
