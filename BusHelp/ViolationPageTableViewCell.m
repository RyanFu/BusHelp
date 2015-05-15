//
//  ViolationPageTableViewCell.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/23.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ViolationPageTableViewCell.h"

@interface ViolationPageTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reasonLabelLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reasonLabelTrailingConstraint;

@end

@implementation ViolationPageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    self.reasonLabel.preferredMaxLayoutWidth = self.width - self.reasonLabelLeadingConstraint.constant - self.reasonLabelTrailingConstraint.constant;
}

- (void)setViolation:(Violation *)violation {
    _violation = violation;
    self.reasonLabel.text = _violation.reason;
    self.timeLabel.text = _violation.time;
    self.addressLabel.text = _violation.address;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)[violation.score integerValue]];
    self.moneyLabel.text = [NSString stringWithFormat:@"%ld", (long)[violation.money integerValue]];
    
    //self.reasonLabel.text = @"舒服舒服，啊飒飒法萨芬，的方式的第三个色粉，水电费师傅的说法，是对方是否收费";
    //self.timeLabel.text = @"2015-01-08 19:20:00";
    //self.addressLabel.text = @"竹园路-金山东路";
    //self.scoreLabel.text = @"10";
    //self.moneyLabel.text = @"1200";
}

@end
