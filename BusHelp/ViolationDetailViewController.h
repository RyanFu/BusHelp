//
//  ViolationDetailViewController.h
//  BusHelp
//
//  Created by Paul on 15/5/12.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Violation.h"
#import "ViolationPageView.h"

@interface ViolationDetailViewController : BaseViewController
@property (nonatomic, strong) Vehicle *vehicle;
@property (nonatomic, strong)IBOutlet ViolationPageView *violationPageview;
@end
