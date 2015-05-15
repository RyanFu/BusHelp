//
//  SplashViewThree.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/20.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "SplashViewThree.h"

@interface SplashViewThree ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)dismissButtonPressed:(UIButton *)sender;


@end

@implementation SplashViewThree

- (void)awakeFromNib {
    self.imageView.image = [UIImage imageNamed:@"splash-introduction-new-3"];;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)dismissButtonPressed:(UIButton *)sender {
    if (self.dismissButtonPressedBlock != nil) {
        self.dismissButtonPressedBlock();
    }
}



@end
