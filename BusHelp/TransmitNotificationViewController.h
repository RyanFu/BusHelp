//
//  TransmitNotificationViewController.h
//  BusHelp
//
//  Created by Paul on 15/5/8.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface TransmitNotificationViewController : BaseViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;
@property (weak, nonatomic) IBOutlet UITextField *ThemeField;
@property (weak, nonatomic) IBOutlet UITextView *ContentText;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
- (IBAction)addUser:(id)sender;

@end
