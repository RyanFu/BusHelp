//
//  AddTaskViewController.h
//  BusHelp
//
//  Created by Paul on 15/5/29.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <SwipeView/SwipeView.h>

@interface AddTaskViewController : BaseViewController<UITextViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextView *taskTitle;
@property (weak, nonatomic) IBOutlet UITextView *taskContent;
@property (weak, nonatomic) IBOutlet UIView *taskmanagerView;
@property (weak, nonatomic) IBOutlet UIView *vehicleView;
@property (weak, nonatomic) IBOutlet UIView *taskbegintimeView;
@property (weak, nonatomic) IBOutlet UIView *taskendtimeView;
@property (weak, nonatomic) IBOutlet UILabel *managerLabel;
@property (weak, nonatomic) IBOutlet UILabel *vehicleNumbersLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholder_title;
@property (weak, nonatomic) IBOutlet UILabel *placeholder_content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraintSwipeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstrainCamerTopToSwipeBottom;
@property (weak, nonatomic) IBOutlet SwipeView *attachmentSwipeView;
@property (strong, nonatomic) NSMutableArray *imageArray;


- (IBAction)managerViewTappedGesture:(UITapGestureRecognizer *)sender;
- (IBAction)vehicleViewTappedGesture:(UITapGestureRecognizer *)sender;
- (IBAction)taskbegintimeViewTappedGesture:(UITapGestureRecognizer *)sender;
- (IBAction)taskendtimeViewTappedGesture:(UITapGestureRecognizer *)sender;
- (IBAction)cameraButtonPressed:(id)sender;

@end
