//
//  HigerVehicleListViewController.h
//  BusHelp
//
//  Created by Paul on 15/5/22.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Vehicle.h"

@interface HigerVehicleListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *HigerListTable;
@property (nonatomic,strong)void (^dismiss)(Vehicle *selectVehicle);
@end
