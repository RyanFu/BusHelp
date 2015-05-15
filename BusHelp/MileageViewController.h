//
//  MileageViewController.h
//  BusHelp
//
//  Created by Paul on 15/5/13.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <MapKit/MapKit.h>

@interface MileageViewController : BaseViewController<UITextFieldDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *DataLabel;
@property (weak, nonatomic) IBOutlet UITextField *mileageLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityindicator;
@property (weak, nonatomic) IBOutlet UIButton *vehicleNumber;
- (IBAction)getAddressAction:(id)sender;
- (IBAction)selectvehicle:(id)sender;
- (IBAction)submitAction:(id)sender;

@end
