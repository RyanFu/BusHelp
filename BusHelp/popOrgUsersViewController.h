//
//  popOrgUsersViewController.h
//  BusHelp
//
//  Created by Paul on 15/5/8.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface popOrgUsersViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *OrgUsersTable;
@property (retain, nonatomic) NSMutableArray *items;
@property(strong,nonatomic)void (^confirmBlock)(NSArray *selected,NSString *OrgID);
@end
