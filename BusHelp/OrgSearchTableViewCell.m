//
//  OrgSearchTableViewCell.m
//  BusHelp
//
//  Created by Tony Zeng on 15/3/13.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "OrgSearchTableViewCell.h"
#import "CustomGasStationView.h"
#import "DataRequest.h"

@interface OrgSearchTableViewCell () {
    CustomGasStationView *_stationView;
}

- (IBAction)joinButtonPressed:(id)sender;

@end

@implementation OrgSearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)joinButtonPressed:(id)sender {
    if (_stationView != nil) {
        [_stationView removeFromSuperview];
        _stationView = nil;
    }
    _stationView = [CustomGasStationView loadFromNib];
    _stationView.type = ViewTypeOrgSearch;
    __weak OrgSearchTableViewCell *weakSelf = self;
    [_stationView setConfirmButtonPressedBlock:^(NSString *name, ViewType type) {
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest applyOrgWithOrgID:weakSelf.orgID username:name success:^{
            [CommonFunctionController showHUDWithMessage:@"申请成功！" success:YES];
            if (weakSelf.joinButtonPressed != nil) {
                weakSelf.joinButtonPressed();
            }
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }];
    [_stationView showInView:[UIApplication sharedApplication].keyWindow];
}

@end
