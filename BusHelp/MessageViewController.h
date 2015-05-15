//
//  MessageViewController.h
//  BusHelp
//
//  Created by Paul on 15/5/5.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MessageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)IBOutlet UITableView *messageTable;
@end
