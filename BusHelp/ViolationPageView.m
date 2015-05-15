//
//  ViolationPageView.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/23.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "ViolationPageView.h"
#import "ViolationPageTableViewCell.h"
#import "ShareViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface ViolationPageView () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_violationArray;
    NSMutableDictionary *_offscreenCells;
}


@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITableView *pageTableView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipMessageLabel;

- (IBAction)refreshButtonPressed:(UIButton *)sender;
- (IBAction)shareButtonPressed:(UIButton *)sender;


@end

@implementation ViolationPageView

- (void)awakeFromNib {
    [self commonInit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)commonInit {
    _offscreenCells = [NSMutableDictionary dictionary];
    self.pageTableView.estimatedRowHeight = 44.0;
    self.pageTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)setVehicle:(Vehicle *)vehicle {
    _vehicle = vehicle;
    [self setupData];
}

- (void)setupData {
    self.numberLabel.text = @"违章记录";
    _violationArray = [DataFetcher fetchViolationByVehicleID:_vehicle.vehicleID ascending:NO];
    [self.pageTableView reloadData];
    self.thumbImageView.hidden = NO;
    self.tipMessageLabel.hidden = NO;
    if (_violationArray.count > 0) {
        self.thumbImageView.hidden = YES;
        self.tipMessageLabel.hidden = YES;
    }
}

- (void)refreshData {
    [CommonFunctionController showAnimateMessageHUD];
    [DataRequest fetchViolationWithVehicleID:_vehicle.vehicleID success:^(NSArray *violationArray) {
        _violationArray = violationArray;
        [self setupData];
        [CommonFunctionController hideAllHUD];
    } failure:^(NSString *message){
        [CommonFunctionController showHUDWithMessage:message success:NO];
    }];
}

- (IBAction)refreshButtonPressed:(UIButton *)sender {
    [self refreshData];
}

- (IBAction)shareButtonPressed:(UIButton *)sender {
    UIImage *shareImage = [CommonFunctionController captureWithView:self.firstAvailableUIViewController.tabBarController.navigationController.view];
    id<ISSContent> publishContent = [ShareSDK content:SHARE_CONTENT
                                       defaultContent:SHARE_CONTENT
                                                image:[ShareSDK jpegImageWithImage:shareImage quality:0.5]
                                                title:SHARE_TITLE
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeImage];
    
    //定制微信好友内容
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:INHERIT_VALUE
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                          content:INHERIT_VALUE
                                            title:INHERIT_VALUE
                                              url:INHERIT_VALUE
                                            image:INHERIT_VALUE
                                     musicFileUrl:INHERIT_VALUE
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    id clickHandlerSina = ^{
        ShareViewController *shareViewController = [[self firstAvailableUIViewController].storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ShareViewController class])];
        shareViewController.content = SHARE_CONTENT;
        shareViewController.shareImage = shareImage;
        shareViewController.navigationTitle = [ShareSDK getClientNameWithType:ShareTypeSinaWeibo];
        [self.firstAvailableUIViewController.navigationController pushViewController:shareViewController animated:YES];
    };
    
//    id clickHandlerTencent = ^{
//        ShareViewController *shareViewController = [[self firstAvailableUIViewController].storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ShareViewController class])];
//        shareViewController.content = SHARE_CONTENT;
//        shareViewController.shareImage = shareImage;
//        shareViewController.navigationTitle = [ShareSDK getClientNameWithType:ShareTypeTencentWeibo];
//        [self.firstAvailableUIViewController.navigationController pushViewController:shareViewController animated:YES];
//    };
    
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    NSArray *shareList = [ShareSDK customShareListWithType:
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo] icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                                     clickHandler:clickHandlerSina],
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          nil];
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess) {
                                    DLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail) {
                                    if ([error errorCode] == -22003) {
                                        [CommonFunctionController showHUDWithMessage:@"请安装微信客户端后再重新分享！" success:NO];
                                    }
                                    DLog(@"分享失败,错误码:%@,错误描述:%@", @([error errorCode]), [error errorDescription]);
                                }
                            }];
    

}

#pragma - UITableView datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _violationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ViolationPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ViolationPageTableViewCell class])];
    if (cell == nil) {
        cell = [ViolationPageTableViewCell loadFromNib];
    }
    cell.violation = [_violationArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    ViolationPageTableViewCell *cell = [_offscreenCells objectForKey:NSStringFromClass([ViolationPageTableViewCell class])];
    if (cell == nil) {
        cell = [ViolationPageTableViewCell loadFromNib];
        [_offscreenCells setObject:cell forKey:NSStringFromClass([ViolationPageTableViewCell class])];
    }
    
    cell.violation = [_violationArray objectAtIndex:indexPath.row];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height + 1;
}

@end
