//
//  OilItemTableViewCell.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/24.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "OilItemTableViewCell.h"

@interface OilItemTableViewCell () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *mileageLabel;
@property (weak, nonatomic) IBOutlet UIButton *rubbishButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *attachmentButton;

- (IBAction)rubbishButtonPressed:(UIButton *)sender;
- (IBAction)editButtonPressed:(UIButton *)sender;
- (IBAction)attachmentButtonPressed:(UIButton *)sender;

@end

@implementation OilItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsShowButton:(BOOL)isShowButton {
    _isShowButton = isShowButton;
    self.editButton.hidden = !isShowButton;
    self.rubbishButton.hidden = !isShowButton;
    self.attachmentButton.hidden = !isShowButton;
}

- (void)setOil:(Oil *)oil {
    _oil = oil;
    self.timeLabel.text = oil.time;
    self.numberLabel.text = [NSString stringWithFormat:@"%.1f", [oil.number floatValue]];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.1f", [oil.money floatValue]];
    self.mileageLabel.text = [NSString stringWithFormat:@"%ld", (long)[oil.mileage integerValue]];
}

- (IBAction)rubbishButtonPressed:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定删除这条加油数据？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (IBAction)editButtonPressed:(UIButton *)sender {
    if (self.editButtonPressedBlock != nil) {
        self.editButtonPressedBlock(self.oil);
    }
}

- (IBAction)attachmentButtonPressed:(UIButton *)sender {
    if (self.attachmentButtonPressedBlock != nil) {
        self.attachmentButtonPressedBlock(self.oil);
    }
}

#pragma - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.rubbishButtonPressedBlock != nil) {
                self.rubbishButtonPressedBlock(self.oil.oilID, self.oil.belongsToVehicle.vehicleID);
            }
        });
    }
}

@end
