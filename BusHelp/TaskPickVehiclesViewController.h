//
//  TaskPickVehiclesViewController.h
//  BusHelp
//
//  Created by Paul on 15/5/29.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Vehicle.h"

@interface TaskPickVehiclesViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *vehicleTable;
@property (nonatomic,strong)void (^confirmBlock)(NSArray *selectVehicles);

@end
