//
//  OrgMessageUrlPathViewController.h
//  BusHelp
//
//  Created by Paul on 15/6/18.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OrgMessage.h"

@interface OrgMessageUrlPathViewController : BaseViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *TaskDetaiWebView;
@property (nonatomic,strong)OrgMessage *orgMessage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end
