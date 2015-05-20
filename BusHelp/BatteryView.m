//
//  BatteryView.m
//  BusHelp
//
//  Created by Paul on 15/5/20.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "BatteryView.h"

@interface BatteryView ()


@end
@implementation BatteryView
@synthesize percent;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=5;
    self.layer.borderWidth=1.5;
    self.layer.borderColor=[UIColor darkGrayColor].CGColor;

    CGRect rectangle;
    if ((int)percent<=1) {
        rectangle = CGRectMake(0 , 0, percent*self.frame.size.width, self.frame.size.width);
    }
    
    // 获取当前图形，视图推入堆栈的图形，相当于你所要绘制图形的图纸
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 在当前路径下添加一个矩形路径
    CGContextAddRect(ctx, rectangle);
    
    // 设置试图的当前填充色
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1].CGColor);
    
    // 绘制当前路径区域
    CGContextFillPath(ctx);
}

@end
