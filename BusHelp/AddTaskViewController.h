//
//  AddTaskViewController.h
//  BusHelp
//
//  Created by Paul on 15/5/29.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AddTaskViewController : BaseViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *taskTitle;
@property (weak, nonatomic) IBOutlet UITextView *taskContent;
@property (weak, nonatomic) IBOutlet UIView *taskmanagerView;
@property (weak, nonatomic) IBOutlet UIView *vehicleView;
@property (weak, nonatomic) IBOutlet UIView *taskbegintimeView;
@property (weak, nonatomic) IBOutlet UIView *taskendtimeView;
@property (weak, nonatomic) IBOutlet UILabel *managerLabel;

- (IBAction)managerViewTappedGesture:(UITapGestureRecognizer *)sender;
- (IBAction)vehicleViewTappedGesture:(UITapGestureRecognizer *)sender;
- (IBAction)taskbegintimeViewTappedGesture:(UITapGestureRecognizer *)sender;
- (IBAction)taskendtimeViewTappedGesture:(UITapGestureRecognizer *)sender;

@end
