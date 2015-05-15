//
//  TaskTableViewCell.h
//  BusHelp
//
//  Created by Tony Zeng on 15/2/28.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface TaskTableViewCell : UITableViewCell

@property (nonatomic, strong) Task *task;
@property (nonatomic, assign) BOOL showStatus;

@end
