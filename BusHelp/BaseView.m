//
//  BaseView.m
//  BusHelp
//
//  Created by Paul on 15/5/20.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "BaseView.h"

@interface BaseView ()

@end


@implementation BaseView


- (void)drawRect:(CGRect)rect {
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=2;
    self.layer.borderWidth=1;
    self.layer.borderColor=[UIColor lightGrayColor].CGColor;
}



@end
