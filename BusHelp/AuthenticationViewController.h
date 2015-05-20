//
//  AuthenticatinViewController.h
//  BusHelp
//
//  Created by Paul on 15/5/19.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Vehicle.h"

@interface AuthenticationViewController : BaseViewController<UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *MyImage;
@property (nonatomic,weak) Vehicle *vehicle;

@end
