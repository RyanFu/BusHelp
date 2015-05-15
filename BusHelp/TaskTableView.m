//
//  TaskTableView.m
//  BusHelp
//
//  Created by Tony Zeng on 15/2/28.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "TaskTableView.h"
#import "TaskTableViewCell.h"
#import "TaskDetailView.h"

@interface TaskTableView () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_dataArray;
    TaskDetailView *_taskDetailView;
}


@end

@implementation TaskTableView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commmonInit];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)commmonInit {
    self.dataSource = self;
    self.delegate = self;
}

- (void)setStatus:(TaskStatus)status {
    if (_status != status) {
        _status = status;
        _dataArray = [DataFetcher fetchTaskByStatus:status ascending:NO];
        [self reloadData];
    }
}

#pragma - UITableView datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TaskTableViewCell class])];
    if (cell == nil) {
        cell = [TaskTableViewCell loadFromNib];
    }
    cell.showStatus = (self.status == TaskStatusAll);
    cell.task = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_taskDetailView != nil) {
        [_taskDetailView removeFromSuperview];
        _taskDetailView = nil;
    }
    _taskDetailView = [TaskDetailView loadFromNib];
    _taskDetailView.task = [_dataArray objectAtIndex:indexPath.row];
    [_taskDetailView showInView:[UIApplication sharedApplication].keyWindow];
}

@end
