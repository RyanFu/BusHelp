//
//  popoverViewController.h
//  BusHelp
//
//  Created by Paul on 15/5/5.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface popoverViewController : UIViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong,nonatomic)void (^dismissAndPush)(BOOL flag);
@property (strong,nonatomic)void (^dismiss)(BOOL flag);

- (IBAction)postNotification:(id)sender;
@end
