//
//  ShieldVehicleTableViewCell.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/5.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ShieldVehicleTableViewCell.h"

@interface ShieldVehicleTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISwitch *statusSwitch;

- (IBAction)statusSwitchValueChanged:(UISwitch *)sender;

@end

@implementation ShieldVehicleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsShield:(BOOL)isShield {
    _isShield = isShield;
    [self.statusSwitch setOn:isShield animated:YES];
    self.statusLabel.hidden = !isShield;
}

- (IBAction)statusSwitchValueChanged:(UISwitch *)sender {
    self.isShield = sender.on;
    if (self.switchValueChangedBlock != nil) {
        self.switchValueChangedBlock(self.isShield);
    }
}


@end
