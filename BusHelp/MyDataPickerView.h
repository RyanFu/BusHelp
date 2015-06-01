//
//  MyDataPickerView.h
//  BusHelp
//
//  Created by Paul on 15/6/1.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDataPickerView : UIView
@property (weak, nonatomic) IBOutlet UIDatePicker *DataTimePickerView;
@property(nonatomic,strong)void (^confirmBlock)(NSString *currentDate);
@property(nonatomic,strong)void (^cancelBlock)();
@property(nonatomic,strong)NSString *type;

- (IBAction)confirmButtonTap:(id)sender;
- (IBAction)cancelButtonTap:(id)sender;

@end
