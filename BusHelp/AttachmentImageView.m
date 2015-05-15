//
//  AttachmentImageView.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/9.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "AttachmentImageView.h"
#import "ImageDownloader.h"

@interface AttachmentImageView () {
    ImageDownloader *_imageDownloader;
}

@end

@implementation AttachmentImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    //self.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"placeholder-image" ofType:@"png"]];
}

- (void)downloadImageWithUrl:(NSString *)url success:(void(^)())success failure:(void(^)())failure {
    _imageDownloader = [[ImageDownloader alloc] init];
    __weak AttachmentImageView *weakSelf = self;
    [_imageDownloader downloadImageWithUrl:url success:^(UIImage *image) {
        weakSelf.image = image;
        success();
    } failure:^{
        failure();
    }];
}

- (void)cancelDownload {
    if (_imageDownloader != nil) {
        [_imageDownloader cancleDownload];
    }
}

@end
