//
//  LoginViewController.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/25.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

@property (nonatomic, assign) BOOL isNotification;
@property (copy, nonatomic) void (^loginSuccessBlock)();

@end
