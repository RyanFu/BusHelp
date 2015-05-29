//
//  TaskManagerListViewController.h
//  BusHelp
//
//  Created by Paul on 15/5/29.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TaskManagerListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ManagerTable;
@property (retain, nonatomic) NSMutableArray *items;
@property(strong,nonatomic)void (^confirmBlock)(NSArray *selected,NSString *OrgID);
@end
