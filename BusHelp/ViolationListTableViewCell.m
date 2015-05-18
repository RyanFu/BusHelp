//
//  ViolationListTableViewCell.m
//  BusHelp
//
//  Created by Paul on 15/5/12.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ViolationListTableViewCell.h"

@implementation ViolationListTableViewCell
@synthesize LeftImage,untreatedNumber,VehicleNumber,money,score;
- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=[UIColor clearColor];
//    self.baseview.layer.masksToBounds=YES;
//    self.baseview.layer.cornerRadius=5;
//    self.baseview.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    self.baseview.layer.borderWidth=0.8;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
