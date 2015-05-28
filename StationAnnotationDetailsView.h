//
//  StationAnnotationDetailsView.h
//  HigerStation
//
//  Created by KevinMao on 15/3/18.
//  Copyright (c) 2015年 Higer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationAnnotationDetailsView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblStationName;
@property (weak, nonatomic) IBOutlet UIImageView *imgStationDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblStationStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblColumnCount;
@property (weak, nonatomic) IBOutlet UILabel *lblStationDistance;
@property (weak, nonatomic) IBOutlet UIButton *btnGo;
@property (weak, nonatomic) IBOutlet UIButton *btnDetails;
@property (weak, nonatomic) IBOutlet UILabel *occupyNo;
@property (weak, nonatomic) IBOutlet UILabel *emptyNo;
@property (weak, nonatomic) IBOutlet UILabel *willReleaseNo;
@property (weak, nonatomic) IBOutlet UILabel *updateDate;

@end
