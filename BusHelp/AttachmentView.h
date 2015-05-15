//
//  AttachmentView.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/2.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachmentView : UIView

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) BOOL deleteButtonHidden;
@property (copy, nonatomic) void (^deleteButtonPressedBlock)(AttachmentView *view);
@property (copy, nonatomic) void (^imageViewTapBlock)(AttachmentView *view);

@end
