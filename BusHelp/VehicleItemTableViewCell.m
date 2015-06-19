//
//  VehicleItemTableViewCell.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/23.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "VehicleItemTableViewCell.h"
@interface VehicleItemTableViewCell () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkVehicleDetailButton;
@property (weak, nonatomic) IBOutlet UIImageView *identifyImage;

- (IBAction)rubbishButtonPressed:(UIButton *)sender;
- (IBAction)editButtonPressed:(UIButton *)sender;
- (IBAction)vehicleAuthenticationButtonPressed:(id)sender;

@end

@implementation VehicleItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVehicle:(Vehicle *)vehicle {
    _vehicle = vehicle;
    self.numberLabel.text = _vehicle.number;
    self.nameLabel.text = _vehicle.name;
    if ([_vehicle.identify_status isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)AuthenticationTypeAlready]]) {
        self.identifyImage.image=[UIImage imageNamed:@"authentication-already"];
        self.identifyImage.hidden=YES;
        self.checkVehicleDetailButton.hidden=YES;
    }else if ([_vehicle.identify_status isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)AuthenticationTypeHiger]])
    {
        self.identifyImage.image=[UIImage imageNamed:@"authentication-higer"];
        self.identifyImage.hidden=NO;
        [self.checkVehicleDetailButton setTitle:@"实时监测" forState:UIControlStateNormal];
        self.checkVehicleDetailButton.hidden=NO;

    }else if ([_vehicle.identify_status isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)AuthenticationTypeIn]])
    {
        self.identifyImage.image=[UIImage imageNamed:@"authentication-in"];
        self.identifyImage.hidden=YES;
        [self.checkVehicleDetailButton setTitle:@"车辆认证" forState:UIControlStateNormal];
        self.checkVehicleDetailButton.hidden=YES;
        
    }
    else if([vehicle.identify_status isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)AuthenticationTypeUn]])
    {
        self.identifyImage.image=[UIImage imageNamed:@"authentication-un"];
        self.identifyImage.hidden=YES;
        [self.checkVehicleDetailButton setTitle:@"车辆认证" forState:UIControlStateNormal];
        self.checkVehicleDetailButton.hidden=YES;

    }else
    {
        self.identifyImage.hidden=YES;
        self.checkVehicleDetailButton.hidden=YES;

    }

}

- (IBAction)rubbishButtonPressed:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定删除这辆车？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (IBAction)editButtonPressed:(UIButton *)sender {
    if (self.editButtonPressedBlock != nil) {
        self.editButtonPressedBlock(self.vehicle);
    }
}

- (IBAction)vehicleAuthenticationButtonPressed:(id)sender {
    if (self.AuthenticationButtonPressedBlock != nil) {
        self.AuthenticationButtonPressedBlock(self.vehicle);
    }
}

#pragma - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.rubbishButtonPressedBlock != nil) {
                self.rubbishButtonPressedBlock(self.vehicle.vehicleID);
            }
        });
    }
}

@end
