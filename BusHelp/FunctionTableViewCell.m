//
//  FunctionTableViewCell.m
//  BusHelp
//
//  Created by Paul on 15/4/30.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "FunctionTableViewCell.h"
#import "UIView+MGBadgeView.h"

@implementation FunctionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.FunctionImage.badgeView setPosition:MGBadgePositionTopRight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
