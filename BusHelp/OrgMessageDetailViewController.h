//
//  OrgMessageDetailViewController.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/3/8.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "BaseViewController.h"
#import "OrgMessage.h"

@interface OrgMessageDetailViewController : BaseViewController

@property (nonatomic, strong) OrgMessage *orgMessage;
@property (copy, nonatomic) void (^refreshOrgBlock)();
@property (nonatomic, assign) OrgStatus status;
@property (nonatomic, strong) NSString *referenceID;

@end
