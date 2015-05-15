//
//  OilTotalPageView.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/24.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "OilTotalPageView.h"
#import "UUChart.h"
#import "DataRequest.h"
#import "Month.h"
#import <ShareSDK/ShareSDK.h>
#import "ShareViewController.h"

static CGFloat const chartWidth = 288.0f;
static CGFloat const chartHeight = 167.0f;

@interface OilTotalPageView () <UUChartDataSource> {
    UUChart *_chartView;
    OilTotal *_oilTotal;
}

@property (weak, nonatomic) IBOutlet UILabel *avgNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *mileageLabel;

- (IBAction)shareButtonPressed:(UIButton *)sender;
- (IBAction)listButtonPressed:(id)sender;

@end

@implementation OilTotalPageView

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
    
}

- (void)setVehicleID:(NSString *)vehicleID {
    _vehicleID = vehicleID;
    [self setupData];
}

- (void)setupData {
    _oilTotal = [DataFetcher fetchOilTotalByVehicleID:self.vehicleID];
    self.avgNumberLabel.text = @"0";
    self.mileageLabel.text = @"0";
    if (_oilTotal != nil) {
        self.avgNumberLabel.text = [NSString stringWithFormat:@"%@", _oilTotal.avgNumber];
        self.mileageLabel.text = [NSString stringWithFormat:@"%@", _oilTotal.mileageSumNumber];
    }
    [self setupChart];
}

/*
- (void)refreshData {
    [CommonFunctionController showAnimateMessageHUD];
    [DataRequest fetchOilTotalWithVehicleID:self.vehicleID success:^(OilTotal *oilTotal) {
        _oilTotal = oilTotal;
        self.avgNumberLabel.text = @"0";
        self.mileageLabel.text = @"0";
        if (_oilTotal != nil) {
            self.avgNumberLabel.text = [NSString stringWithFormat:@"%@", _oilTotal.avgNumber];
            self.mileageLabel.text = [NSString stringWithFormat:@"%@", _oilTotal.mileageSumNumber];
        }
        [self setupChart];
        [CommonFunctionController hideAllHUD];
    } failure:^(NSString *message){
        [CommonFunctionController showHUDWithMessage:message success:NO];
    }];
}
 */

- (void)setupChart {
    if (_chartView != nil) {
        [_chartView removeFromSuperview];
        _chartView = nil;
    }
    _chartView = [[UUChart alloc] initwithUUChartDataFrame:CGRectMake(([UIApplication sharedApplication].keyWindow.width - chartWidth) / 2.0f, 95.0f, chartWidth, chartHeight) withSource:self withStyle:UUChartLineStyle];
    _chartView.yCount = 7;
    _chartView.backgroundColor = [UIColor clearColor];
    [_chartView showInView:self];
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart {
    NSMutableArray *monthArray = [NSMutableArray arrayWithCapacity:6];
    for (Month *month in _oilTotal.hasMonth) {
        [monthArray addObject:[NSString stringWithFormat:@"%@月", month.month]];
    }
    return monthArray;
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart {
    NSMutableArray *numberArray = [NSMutableArray arrayWithCapacity:6];
    for (Month *month in _oilTotal.hasMonth) {
        [numberArray addObject:month.number];
    }
    return @[numberArray];
}

//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart {
    NSInteger maxNumber = [[_oilTotal.hasMonth valueForKeyPath:@"@max.number"] integerValue];
    maxNumber = (maxNumber / 10 + 1) * 10;
    return CGRangeMake(maxNumber, 0);
}

#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart {
    return @[UURed];
}

#pragma mark 折线图专享功能
//标记数值区域
- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart {
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index {
    return YES;
}

//判断显示最大最小值
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index {
    return NO;
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
    
    NSArray *shareList = [ShareSDK customShareListWithType:
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo] icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                                     clickHandler:clickHandlerSina],
                          /*
                          [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeTencentWeibo] icon:[ShareSDK getClientIconWithType:ShareTypeTencentWeibo]
                                                     clickHandler:clickHandlerTencent],
                           */
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          nil];
    
    [ShareSDK showShareActionSheet:nil
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





@end
