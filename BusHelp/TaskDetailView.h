//
//  TaskDetailView.h
//  BusHelp
//
//  Created by Tony Zeng on 15/2/28.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface TaskDetailView : UIView

@property (nonatomic, strong) Task *task;
@property (copy, nonatomic) void (^confirmButtonPressedBlock)();
@property (nonatomic, strong) NSString *referenceID;

- (void)showInView:(UIView *)view;

@end
