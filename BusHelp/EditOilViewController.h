//
//  EditOilViewController.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/24.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "BaseViewController.h"
#import "DataRequest.h"

@interface EditOilViewController : BaseViewController

@property (nonatomic, strong) NSString *navigationTitle;
@property (nonatomic, strong) NSString *vehicleID;
@property (nonatomic, strong) OilItem *oilItem;

@end
