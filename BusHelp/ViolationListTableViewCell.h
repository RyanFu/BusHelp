//
//  ViolationListTableViewCell.h
//  BusHelp
//
//  Created by Paul on 15/5/12.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViolationListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *baseview;
@property (weak, nonatomic) IBOutlet UIImageView *LeftImage;
@property (weak, nonatomic) IBOutlet UILabel *VehicleNumber;
@property (weak, nonatomic) IBOutlet UILabel *untreatedNumber;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *score;

@end
