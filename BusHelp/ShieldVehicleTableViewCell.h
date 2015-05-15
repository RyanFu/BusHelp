//
//  ShieldVehicleTableViewCell.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/5.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShieldVehicleTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isShield;
@property (copy, nonatomic) void (^switchValueChangedBlock)(BOOL isShield);


@end
