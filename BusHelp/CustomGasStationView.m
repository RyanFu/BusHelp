//
//  CustomGasStationView.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/2.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "CustomGasStationView.h"

@interface CustomGasStationView ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UIView *inputFieldView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)cancleButtonPrseed:(UIButton *)sender;
- (IBAction)confirmButtonPressed:(UIButton *)sender;

@end

@implementation CustomGasStationView

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

- (void)layoutSubviews {
    [super layoutSubviews];
    switch (self.type) {
        case ViewTypeStation:
            self.nameTextField.placeholder = @"请输入加油站名称";
            self.titleLabel.text = @"自定义加油站";
            break;
        case ViewTypeOil:
            self.nameTextField.placeholder = @"请输入油品名称";
            self.titleLabel.text = @"自定义油品";
            break;
        default:
            self.nameTextField.placeholder = @"请输入您的姓名";
            self.titleLabel.text = @"我是谁";
            break;
    }
}

- (void)commonInit {
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.borderColor = [UIColor colorWithRed:200.0f / 255.0f green:200.0f / 255.0f blue:200.0f / 255.0f alpha:1.0f].CGColor;
    self.inputFieldView.layer.cornerRadius = 10.0f;
}

- (void)showInView:(UIView *)view {
    self.alpha = 0;
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [view addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.nameTextField becomeFirstResponder];
    }];
}

- (IBAction)cancleButtonPrseed:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)confirmButtonPressed:(UIButton *)sender {
    if ([CommonFunctionController checkValueValidate:self.nameTextField.text] == nil) {
        [CommonFunctionController showHUDWithMessage:[NSString stringWithFormat:@"%@！", self.nameTextField.placeholder] success:NO];
    }
    else {
        [self.nameTextField resignFirstResponder];
        if (self.confirmButtonPressedBlock != nil) {
            self.confirmButtonPressedBlock(self.nameTextField.text, self.type);
        }
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

@end
