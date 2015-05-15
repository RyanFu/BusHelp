//
//  TaskTableViewCell.m
//  BusHelp
//
//  Created by Tony Zeng on 15/2/28.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "TaskTableViewCell.h"

@interface TaskTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@end

@implementation TaskTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTask:(Task *)task {
    if (task != nil) {
        _task = task;
        UIColor *taskColor = nil;
        NSString *taskMessage = nil;
        switch ([task.status integerValue]) {
            case TaskStatusSpot:
                taskColor = [UIColor clearColor];
                taskMessage = @"新任务";
                break;
            case TaskStatusUnderWay:
                taskColor = [UIColor colorWithRed:94.0f / 255.0f green:167.0f / 255.0f blue:250.0f / 255.0f alpha:1.0f];
                taskMessage = @"进行中";
                break;
            case TaskStatusFinished:
                taskColor = [UIColor colorWithRed:131.0f / 255.0f green:200.0f / 255.0f blue:85.0f / 255.0f alpha:1.0f];
                taskMessage = @"已完成";
                break;
            case TaskStatusCancle:
                taskColor = [UIColor colorWithRed:234.0f / 255.0f green:84.0f / 255.0f blue:84.0f / 255.0f alpha:1.0f];
                taskMessage = @"已取消";
                break;
            default:
                break;
        }
        self.statusImageView.backgroundColor = taskColor;
        self.statusLabel.text = taskMessage;
        self.timeLabel.text = task.updateTime;
        self.titleLabel.text = task.title;
    }
}

- (void)setShowStatus:(BOOL)showStatus {
    _showStatus = showStatus;
    self.statusLabel.hidden = !_showStatus;
}

@end
