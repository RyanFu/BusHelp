//
//  TaskDetailView.m
//  BusHelp
//
//  Created by Tony Zeng on 15/2/28.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "TaskDetailView.h"
#import <SwipeView/SwipeView.h>
#import "RoundCornerButton.h"
#import "DataRequest.h"
#import "AttachmentView.h"
#import "ImageDownloader.h"

@interface TaskDetailView () <SwipeViewDataSource, SwipeViewDelegate> {
    NSArray *_imageArray;
    ImageDownloader *_imageDownloader;

}

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *managerLabel;
@property (weak, nonatomic) IBOutlet UILabel *helperLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *vehicleNumberLabel;
@property (weak, nonatomic) IBOutlet SwipeView *attachmentSwipeView;
@property (weak, nonatomic) IBOutlet RoundCornerButton *confirmButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *swipeViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *swipeViewTopConstraint;

- (IBAction)confirmButtonPressed:(RoundCornerButton *)sender;
- (IBAction)tapped:(UITapGestureRecognizer *)sender;

@end

@implementation TaskDetailView

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
    self.attachmentSwipeView.pagingEnabled = YES;
}

- (void)setReferenceID:(NSString *)referenceID {
    if (![_referenceID isEqualToString:referenceID] && referenceID != nil) {
        _referenceID = referenceID;
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest fetchTaskWithTaskID:_referenceID success:^(Task *task) {
            self.task = task;
            [CommonFunctionController hideAllHUD];
        } failure:^(NSString *message) {
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
}

- (void)setTask:(Task *)task {
    if (task != nil) {
        _task = task;
        BOOL hiddenButton = NO;
        UIColor *taskColor = nil;
        NSString *buttonTitle = nil;
        switch ([task.status integerValue]) {
            case TaskStatusSpot:
                taskColor = [UIColor clearColor];
                buttonTitle = @"接 受";
                break;
            case TaskStatusUnderWay:
                taskColor = [UIColor colorWithRed:94.0f / 255.0f green:167.0f / 255.0f blue:250.0f / 255.0f alpha:1.0f];
                buttonTitle = @"完 成";
                break;
            case TaskStatusFinished:
                taskColor = [UIColor colorWithRed:131.0f / 255.0f green:200.0f / 255.0f blue:85.0f / 255.0f alpha:1.0f];
                hiddenButton = YES;
                break;
            case TaskStatusCancle:
                taskColor = [UIColor colorWithRed:234.0f / 255.0f green:84.0f / 255.0f blue:84.0f / 255.0f alpha:1.0f];
                hiddenButton = YES;
                break;
            default:
                break;
        }
        self.confirmButton.hidden = hiddenButton;
        if (!hiddenButton) {
            [self.confirmButton setTitle:buttonTitle forState:UIControlStateNormal];
        }
        else {
            self.confirmButtonHeightConstraint.constant = 0;
            self.confirmButtonTopConstraint.constant = 0;
            [self layoutIfNeeded];
        }
        self.statusImageView.backgroundColor = taskColor;
        self.titleLabel.text = task.title;
        self.contentLabel.text = task.content;
        self.managerLabel.text = task.manager;
        self.helperLabel.text = task.helper;
        self.beginTimeLabel.text = task.beginTime;
        self.endTimeLabel.text = task.endTime;
        self.vehicleNumberLabel.text=task.vehicleNumber;
        _imageArray = task.attachmentList;
        if ([CommonFunctionController checkValueValidate:_imageArray] == nil) {
            self.swipeViewHeightConstraint.constant = 0;
            self.swipeViewTopConstraint.constant = 0;
        }
    }
}

- (IBAction)confirmButtonPressed:(RoundCornerButton *)sender {
    [CommonFunctionController showAnimateMessageHUD];
    [DataRequest confirmTaskByTaskID:self.task.taskID success:^{
        [CommonFunctionController hideAllHUD];
        [[NSNotificationCenter defaultCenter] postNotificationName:updateBadgeValueKey object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:refreshDataKey object:nil];
        [self removeFromSuperview];
    } failure:^(NSString *message){
        [CommonFunctionController showHUDWithMessage:message success:NO];
    }];
}

- (IBAction)tapped:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.referenceID != nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:refreshDataKey object:nil];
        }
        [self removeFromSuperview];
    }];
}

- (void)showInView:(UIView *)view {
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}

#pragma - SwipeView datasource and delegate
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return _imageArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (view == nil) {
        @autoreleasepool {
            view = [AttachmentView loadFromNib];
        }
    }
    [(AttachmentView *)view setImageUrl:[_imageArray objectAtIndex:index]];
    
    [(AttachmentView *)view setImageViewTapBlock:^(AttachmentView *attachmentView) {
        UIView *attachView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        attachView.backgroundColor=[UIColor whiteColor];
        UIImageView *attachImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, sFrame.size.width, sFrame.size.height-160)];
    
        attachmentView.contentMode=UIViewContentModeScaleAspectFit;
        
        _imageDownloader = [[ImageDownloader alloc] init];
        [_imageDownloader downloadImageWithUrl:[_imageArray objectAtIndex:index] success:^(UIImage *image) {
            attachImageView.image = image;
            attachImageView.alpha = 0;
            [[UIApplication sharedApplication].keyWindow addSubview:attachView];
            [attachView addSubview:attachImageView];

            [UIView animateWithDuration:0.5 animations:^{
                attachImageView.alpha = 1.0f;
            }];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Attachtapped:)];
            attachView.userInteractionEnabled = YES;
            [attachView addGestureRecognizer:tapGesture];

        } failure:^{
        }];
    }];

    return view;
}

- (void)Attachtapped:(UITapGestureRecognizer *)gesture {
    UIView *view = gesture.view;
    [UIView animateWithDuration:0.5 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}


- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    return CGSizeMake(100.0f, 88.0f);
}

@end
