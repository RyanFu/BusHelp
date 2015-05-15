//
//  AddVehicleViewController.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/21.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "BaseViewController.h"
#import "VehicleItem.h"

@interface EditVehicleViewController : BaseViewController

@property (nonatomic, strong) VehicleItem *vehicleItem;
@property (nonatomic, assign) BOOL hiddenSearchButton;

@end
