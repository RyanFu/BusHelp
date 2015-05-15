//
//  ManagerTableViewCell.h
//  BusHelp
//
//  Created by Tony Zeng on 15/2/27.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) NSUInteger badgeCount;
@property (nonatomic, assign) BOOL imageIsShow;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, assign) OrgMessageType type;

@end
