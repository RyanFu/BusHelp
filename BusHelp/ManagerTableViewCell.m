//
//  ManagerTableViewCell.m
//  BusHelp
//
//  Created by Tony Zeng on 15/2/27.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ManagerTableViewCell.h"
#import <JSBadgeView/JSBadgeView.h>

@interface ManagerTableViewCell () {
    JSBadgeView *_badgeView;
    CGFloat _imageWidth;
    CGFloat _leadingSpace;
}

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLeadingConstraint;


@end

@implementation ManagerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self commonInit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)commonInit {
    _badgeView = [[JSBadgeView alloc] initWithParentView:self.cellImageView alignment:JSBadgeViewAlignmentTopRight];
    _badgeView.hidden = YES;
    _imageWidth = self.imageWidthConstraint.constant;
    _leadingSpace = self.titleLabelLeadingConstraint.constant;
    self.imageIsShow = YES;
}

- (void)setImageName:(NSString *)imageName {
    if (imageName != nil && ![imageName isEqualToString:_imageName]) {
        _imageName = imageName;
        self.cellImageView.image = [UIImage imageNamed:imageName];
    }
}

- (void)setTime:(NSString *)time {
    if (![_time isEqualToString:time]) {
        _time = time;
        self.timeLabel.text = time;
    }
}

- (void)setTitle:(NSString *)title {
    if (![_title isEqualToString:title]) {
        _title = title;
        self.titleLabel.text = title;
    }
}

- (void)setSubTitle:(NSString *)subTitle {
    if (![_subTitle isEqualToString:subTitle]) {
        _subTitle = subTitle;
        self.subTitleLabel.text = subTitle;
    }
}

- (void)setBadgeCount:(NSUInteger)badgeCount {
    dispatch_async(dispatch_get_main_queue(), ^{
        _badgeView.hidden = YES;
        if (badgeCount != 0) {
            _badgeCount = badgeCount;
            _badgeView.hidden = NO;
            _badgeView.badgeText = @(badgeCount).stringValue;
        }
    });
}

- (void)setImageIsShow:(BOOL)imageIsShow {
    _imageIsShow = imageIsShow;
    self.cellImageView.hidden = !imageIsShow;
    self.imageWidthConstraint.constant = imageIsShow ? _imageWidth : 0;
    self.titleLabelLeadingConstraint.constant = imageIsShow ? _leadingSpace : 0;
}

- (void)setIsRead:(BOOL)isRead {
    if (isRead != _isRead) {
        _isRead = isRead;
        if (_isRead) {
            self.titleLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0f];
            self.subTitleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0f];
            self.titleLabel.font = [UIFont systemFontOfSize:self.titleLabel.font.pointSize];
            self.subTitleLabel.font = [UIFont systemFontOfSize:self.subTitleLabel.font.pointSize];
        }
        else {
            self.titleLabel.textColor = [UIColor darkTextColor];
            self.subTitleLabel.textColor = [UIColor darkGrayColor];
            self.titleLabel.font = [UIFont boldSystemFontOfSize:self.titleLabel.font.pointSize];
            self.subTitleLabel.font = [UIFont boldSystemFontOfSize:self.subTitleLabel.font.pointSize];
        }
    }
}

- (void)setType:(OrgMessageType)type {
    if (_type != type) {
        _type = type;
        if (_type == OrgMessageTypeInvite || _type == OrgMessageTypeApply) {
            self.titleLabel.textColor = [UIColor redColor];
        }
    }
}

@end
