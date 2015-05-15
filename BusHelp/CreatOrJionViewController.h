//
//  CreatOrJionViewController.h
//  BusHelp
//
//  Created by Paul on 15/5/10.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Org.h"

@interface CreatOrJionViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *ApplyingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ApplyingImage;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *CreateTeam;
@property (weak, nonatomic) IBOutlet UIButton *JoinTeam;

- (IBAction)CreateOrgButtunPressed:(id)sender;
- (IBAction)AddOrgButtonPressed:(id)sender;
- (IBAction)cancelApplying:(id)sender;

@end
