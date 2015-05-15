//
//  SplashViewOne.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/20.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "SplashViewOne.h"

@interface SplashViewOne ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation SplashViewOne

- (void)awakeFromNib {
    self.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"splash-introduction-1" ofType:@"png"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
