//
//  TaskManagerViewController.h
//  BusHelp
//
//  Created by Tony Zeng on 15/2/27.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "BaseViewController.h"

@interface TaskManagerViewController : BaseViewController

@property (nonatomic, assign) BOOL isNotification;
@property (nonatomic, strong) NSString *referenceID;

- (void)showDetailViewWithReferenceID:(NSString *)referenceID;

@end
