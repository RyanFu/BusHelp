//
//  FunctionViewController.h
//  BusHelp
//
//  Created by Paul on 15/4/29.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FunctionViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *FunctionTable;

@end
