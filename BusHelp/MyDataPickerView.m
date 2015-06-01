//
//  MyDataPickerView.m
//  BusHelp
//
//  Created by Paul on 15/6/1.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "MyDataPickerView.h"

@implementation MyDataPickerView
@synthesize type;

- (void)drawRect:(CGRect)rect {
    
}


- (IBAction)confirmButtonTap:(id)sender {
    
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.confirmBlock([df stringFromDate:self.DataTimePickerView.date]);
}

- (IBAction)cancelButtonTap:(id)sender {
    self.cancelBlock();
}
@end
