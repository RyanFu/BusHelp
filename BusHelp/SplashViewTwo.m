//
//  SplashViewTwo.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/20.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "SplashViewTwo.h"

@interface SplashViewTwo ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SplashViewTwo

- (void)awakeFromNib {
    self.imageView.image = [UIImage imageNamed:@"splash-introduction-new-2"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
