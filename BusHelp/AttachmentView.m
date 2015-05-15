//
//  AttachmentView.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/2.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "AttachmentView.h"
#import "AttachmentImageView.h"
#import <QBPopupMenu/QBPopupMenu.h>
#import "UIView+custom.h"

@interface AttachmentView () <UIAlertViewDelegate> {
    QBPopupMenu *_popupMenu;
}

@property (weak, nonatomic) IBOutlet AttachmentImageView *attachmentImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)deleteButtonPressed:(UIButton *)sender;
- (IBAction)longPressGesture:(UILongPressGestureRecognizer *)sender;
- (IBAction)tapGesture:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageActivityIndicatorView;

@end

@implementation AttachmentView

- (void)awakeFromNib {
    [self commonInit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)commonInit {
    self.deleteButtonHidden = YES;
    QBPopupMenuItem *item = [QBPopupMenuItem itemWithTitle:@"删除" target:self action:@selector(deleteButtonPressed:)];
    _popupMenu = [[QBPopupMenu alloc] initWithItems:@[item]];
}

- (void)setDeleteButtonHidden:(BOOL)deleteButtonHidden {
    _deleteButtonHidden = deleteButtonHidden;
    self.deleteButton.hidden = deleteButtonHidden;
}

- (void)setImageUrl:(NSString *)imageUrl {
    self.deleteButton.hidden = YES;
    if (![_imageUrl isEqualToString:imageUrl] && imageUrl != nil) {
        _imageUrl = imageUrl;
        [self.imageActivityIndicatorView startAnimating];
        [self.attachmentImageView downloadImageWithUrl:imageUrl success:^{
            [self.imageActivityIndicatorView stopAnimating];
        } failure:^{
            [self.imageActivityIndicatorView stopAnimating];
        }];
    }
}

- (void)dealloc {
    [self.imageActivityIndicatorView stopAnimating];
    [self.imageActivityIndicatorView removeFromSuperview];
    self.imageActivityIndicatorView = nil;
    self.attachmentImageView.image = nil;
    [self.attachmentImageView removeFromSuperview];
    [self.attachmentImageView cancelDownload];
}

- (IBAction)deleteButtonPressed:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要删除这张图片？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (IBAction)longPressGesture:(UILongPressGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateBegan) {
        UIViewController *viewController = [self firstAvailableUIViewController];
        CGRect frame = CGRectMake((self.attachmentImageView.width - _popupMenu.width) / 2.0f, 10, _popupMenu.width, _popupMenu.height);
        frame = [self convertRect:frame toView:viewController.view];
        [_popupMenu showInView:viewController.view targetRect:frame animated:YES];
    }
}

- (IBAction)tapGesture:(UITapGestureRecognizer *)sender {
    if (self.imageViewTapBlock != nil) {
        self.imageViewTapBlock(self);
    }
}

#pragma -UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        [self.attachmentImageView cancelDownload];
        if (self.deleteButtonPressedBlock != nil) {
            self.deleteButtonPressedBlock(self);
        }
    }
}

@end
