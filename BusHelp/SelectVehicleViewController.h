//
//  SelectVehicleViewController.h
//  BusHelp
//
//  Created by Paul on 15/5/13.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Vehicle.h"

@interface SelectVehicleViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *vehicleTable;
@property (nonatomic,strong)void (^dismiss)(Vehicle *selectVehicle);
@end
