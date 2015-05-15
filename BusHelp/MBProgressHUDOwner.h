//
//  MBProgressHUDOwner.h
//  BusHelp
//
//  Created by Tony Zeng on 15/3/23.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUDOwner : NSObject
LCSINGLETON_IN_H(MBProgressHUDOwner)

@property (nonatomic, strong) MBProgressHUD *hud;

@end
