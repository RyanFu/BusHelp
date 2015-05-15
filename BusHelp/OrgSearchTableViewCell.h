//
//  OrgSearchTableViewCell.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/13.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrgSearchTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *orgID;
@property (weak, nonatomic) IBOutlet UILabel *OrgName;
@property (copy, nonatomic) void (^joinButtonPressed)();

@end
