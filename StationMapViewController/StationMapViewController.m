//
//  StationMapViewController.m
//  HigerStation
//
//  Created by KevinMao on 15/3/18.
//  Copyright (c) 2015年 Higer. All rights reserved.
//

#import "StationMapViewController.h"
#import "StationPointAnnotation.h"
#import "StationAnnotationView.h"
#import "StationAnnotationDetailsView.h"
//#import "StationDetailsViewController.h"
#import "Math.h"

@interface StationMapViewController ()
{
    CLLocationManager *locationManager;
}
@end

@implementation StationMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _stationService = [[NetStationService alloc] init];
    _srcCoordinate.longitude = 0;
    _srcCoordinate.latitude = 0;
    _station_list = [[NSArray alloc] init];
    self.mapView.showsUserLocation = YES;

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;

    
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined && ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
        // choose one request according to your business.
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
            [locationManager requestAlwaysAuthorization];
        } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
            [locationManager  requestWhenInUseAuthorization];
        } else {
            NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
        }
    }
    
    [self showWait:MSG_LOAD_CURRENT_LOCATION view:self.view];
    [locationManager startUpdatingLocation];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [self alert:MSG_ALERT_ALLOW_LOCATION view:self.view animated:YES afterDelay:3];

}


#pragma mark - Custom Action

- (void)requestGetStationList:(CLLocationCoordinate2D)coordinate
{
    [_stationService requestGetStationList:[NSString stringWithFormat:@"%f", coordinate.longitude] user_lat:[NSString stringWithFormat:@"%f", coordinate.latitude] success:^(int code, NSString *msg, NSArray *station_list) {
        [self.mapView removeAnnotations:self.mapView.annotations]; //清除所有标注
        _station_list = [[NSArray alloc] initWithArray:station_list copyItems:YES]; //添加数据
        for (m_station *station in _station_list) {
            StationPointAnnotation *pointAnnotation = [[StationPointAnnotation alloc] init];
            pointAnnotation.station = [station copy];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [station.station_lat doubleValue];
            coordinate.longitude = [station.station_lng doubleValue];
            pointAnnotation.coordinate = [self BaiduToMars:coordinate];
            [_mapView addAnnotation:pointAnnotation];
        } //添加标注
        [self zoomToMapPoints:self.mapView annotations:_mapView.annotations]; //缩放至显示所有充电站
    } error:^(int code, NSString *msg) {
        [self alert:msg view:self.view animated:YES afterDelay:2.0];
    }];
}

//百度地图转火星
-(CLLocationCoordinate2D)BaiduToMars:(CLLocationCoordinate2D)coordinate
{
    double x = coordinate.latitude-0.0065;
    double y = coordinate.longitude-0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) - 0.000003 * cos(x * M_PI);
    coordinate.latitude = z * cos(theta);
    coordinate.longitude = z * sin(theta);
    return coordinate;
}

- (void)zoomToMapPoints:(MKMapView*)mapView annotations:(NSArray*)annotations
{
    double minLat = 360.0f, maxLat = -360.0f;
    double minLon = 360.0f, maxLon = -360.0f;
    for (MKPointAnnotation *annotation in annotations) {
        if ( annotation.coordinate.latitude  < minLat ) minLat = annotation.coordinate.latitude;
        if ( annotation.coordinate.latitude  > maxLat ) maxLat = annotation.coordinate.latitude;
        if ( annotation.coordinate.longitude < minLon ) minLon = annotation.coordinate.longitude;
        if ( annotation.coordinate.longitude > maxLon ) maxLon = annotation.coordinate.longitude;
    }
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat + maxLat) / 2.0, (minLon + maxLon) / 2.0);
    MKCoordinateSpan span = MKCoordinateSpanMake(maxLat - minLat, maxLon - minLon);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [mapView setRegion:region animated:YES];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (_srcCoordinate.longitude == 0 || _srcCoordinate.latitude == 0) {
        MKCoordinateSpan theSpan;
        theSpan.latitudeDelta = 0.05;
        theSpan.longitudeDelta = 0.05;
        MKCoordinateRegion theRegion;
        theRegion.center = userLocation.coordinate;
        theRegion.span = theSpan;
        [self.mapView setRegion:theRegion animated:YES];
        _srcCoordinate = userLocation.coordinate;
        [self requestGetStationList:_srcCoordinate];
    } //初次加载
    else {
        double distance = [BaseInfo calculateDistance:_srcCoordinate.longitude srcLat:_srcCoordinate.latitude desLng:userLocation.coordinate.longitude desLat:userLocation.coordinate.latitude];
        if (distance >= 1000) {
            _srcCoordinate = userLocation.coordinate;
            [self requestGetStationList:_srcCoordinate];
        } //相隔距离超过1000米
    } //计算用户移动距离
    
    [self hideWait];

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:StationPointAnnotation.class]) {
        if (_mapPointAnnotation.coordinate.latitude == view.annotation.coordinate.latitude && _mapPointAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        } //重复点击
        
        if (_mapPointAnnotation) {
            [mapView removeAnnotation:_mapPointAnnotation];
            _mapPointAnnotation = nil;
        } //移除原有视图
        
        StationPointAnnotation *pointAnnotation = (StationPointAnnotation *)view.annotation;
        _mapPointAnnotation = [[StationMapPointAnnotation alloc] init];
        _mapPointAnnotation.station = [pointAnnotation.station copy];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [pointAnnotation.station.station_lat doubleValue];
        coordinate.longitude = [pointAnnotation.station.station_lng doubleValue];
        _mapPointAnnotation.coordinate = [self BaiduToMars:coordinate];
        [self.mapView addAnnotation:_mapPointAnnotation];
        [self.mapView setCenterCoordinate:_mapPointAnnotation.coordinate animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (_mapPointAnnotation && ![view isKindOfClass:StationAnnotationView.class]) {
        if (_mapPointAnnotation.coordinate.latitude == view.annotation.coordinate.latitude && _mapPointAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [self.mapView removeAnnotation:_mapPointAnnotation];
            _mapPointAnnotation = nil;
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:MKUserLocation.class]) {
        MKUserLocation *userLocation = (MKUserLocation *)annotation;
        userLocation.title = @"";
    } //用户位置
    else if ([annotation isKindOfClass:StationPointAnnotation.class]) {
        StationPointAnnotation *pointAnnotation = (StationPointAnnotation *)annotation;
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] init];
        if (pointAnnotation.station.station_status.intValue == 1001) {
            annotationView.image = [UIImage imageNamed:@"station_column_status_green"];
        } //空闲
        else if (pointAnnotation.station.station_status.intValue == 1002) {
            annotationView.image = [UIImage imageNamed:@"station_column_status_red"];
        } //占用
        else if (pointAnnotation.station.station_status.intValue == 1003) {
            annotationView.image = [UIImage imageNamed:@"station_column_status_yellow"];
        } //即将空闲
        else if (pointAnnotation.station.station_status.intValue == 1004) {
            annotationView.image = [UIImage imageNamed:@"station_column_status_gray"];
        } //即将空闲
        annotationView.canShowCallout = NO;
        return annotationView;
    } //充电站位置
    else if ([annotation isKindOfClass:StationMapPointAnnotation.class]) {
        StationMapPointAnnotation *mapPointAnnotation = (StationMapPointAnnotation *)annotation;
        StationAnnotationView *annotationView = [[StationAnnotationView alloc] init];
        StationAnnotationDetailsView *annotationDetailsView = [[[NSBundle mainBundle] loadNibNamed:@"StationAnnotationDetailsView" owner:self options:nil] objectAtIndex:0];
        annotationDetailsView.frame = CGRectMake(0, 0, 280, 130);
        
        annotationDetailsView.lblStationName.text = mapPointAnnotation.station.station_name;
        if ([mapPointAnnotation.station.station_discount isEqualToString:@""]) {
            annotationDetailsView.imgStationDiscount.hidden = YES;
        }
        else {
            annotationDetailsView.imgStationDiscount.hidden = NO;
        }
        if (mapPointAnnotation.station.station_status.intValue == 1001) {
            annotationDetailsView.lblStationStatus.text = @"可预约";
            annotationDetailsView.lblStationStatus.textColor = [UIColor colorWithRed:24.0f/255.0f green:147.0f/255.0f blue:60.0f/255.0f alpha:1.0];
        }
        else if (mapPointAnnotation.station.station_status.intValue == 1002) {
            annotationDetailsView.lblStationStatus.text = @"占用";
            annotationDetailsView.lblStationStatus.textColor = [UIColor colorWithRed:172.0/255.0f green:0.0/255.0f blue:11.0/255.0f alpha:1.0];
        }
        else if (mapPointAnnotation.station.station_status.intValue == 1003) {
            annotationDetailsView.lblStationStatus.text = @"即将空闲";
            annotationDetailsView.lblStationStatus.textColor = [UIColor colorWithRed:250.0/255.0f green:114.0/255.0f blue:17.0/255.0f alpha:1.0];
        }
        else if (mapPointAnnotation.station.station_status.intValue == 1004) {
            annotationDetailsView.lblStationStatus.text = @"停用";
            annotationDetailsView.lblStationStatus.textColor = [UIColor darkGrayColor];
        }

        annotationDetailsView.lblColumnCount.text = [NSString stringWithFormat:@"%d个", mapPointAnnotation.station.column_count.intValue];;
        
        
        NSString *distanceString=mapPointAnnotation.station.station_distance;
        NSString *finalstring;
        NSString *temp;
        if (distanceString.length) {
            temp=[distanceString substringToIndex:1];
            NSLog(@"%@",temp);
            if ([temp isEqualToString:@"."]) {
                finalstring=[NSString stringWithFormat:@"0%@",distanceString];
            }else
            {
                finalstring=distanceString;
            }
        }
        annotationDetailsView.lblStationDistance.text = finalstring;
        
        //新增4.28
        annotationDetailsView.occupyNo.text = [NSString stringWithFormat:@"%d个",mapPointAnnotation.station.occupy_number.intValue];
        annotationDetailsView.emptyNo.text = [NSString stringWithFormat:@"%d个",mapPointAnnotation.station.idle_number.intValue];
        annotationDetailsView.willReleaseNo.text = [NSString stringWithFormat:@"%d个",mapPointAnnotation.station.upcoming_release.intValue];
        annotationDetailsView.updateDate.text = mapPointAnnotation.station.occur_time;


        
//        CGSize labelMaxSize = CGSizeMake(240, 20);
//        NSDictionary *attributes = @{NSFontAttributeName:annotationDetailsView.lblStationName.font};
//        CGSize labelSize = [annotationDetailsView.lblStationName.text boundingRectWithSize:labelMaxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
//        annotationDetailsView.lblStationName.frame = CGRectMake(annotationDetailsView.lblStationName.frame.origin.x, annotationDetailsView.lblStationName.frame.origin.y, labelSize.width, annotationDetailsView.lblStationName.frame.size.height);
//        annotationDetailsView.imgStationDiscount.frame = CGRectMake(annotationDetailsView.lblStationName.frame.origin.x + annotationDetailsView.lblStationName.frame.size.width + 5, annotationDetailsView.imgStationDiscount.frame.origin.y, annotationDetailsView.imgStationDiscount.frame.size.width, annotationDetailsView.imgStationDiscount.frame.size.height);
//        
//        
//        labelMaxSize = CGSizeMake(240, 20);
//        attributes = @{NSFontAttributeName:annotationDetailsView.lblStationDistance.font};
//        labelSize = [annotationDetailsView.lblStationDistance.text boundingRectWithSize:labelMaxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
//        annotationDetailsView.lblStationDistance.frame = CGRectMake(annotationDetailsView.lblStationDistance.frame.origin.x, annotationDetailsView.lblStationDistance.frame.origin.y, labelSize.width, annotationDetailsView.lblStationDistance.frame.size.height);
//        annotationDetailsView.btnGo.frame = CGRectMake(annotationDetailsView.lblStationDistance.frame.origin.x + annotationDetailsView.lblStationDistance.frame.size.width + 5, annotationDetailsView.btnGo.frame.origin.y, annotationDetailsView.btnGo.frame.size.width, annotationDetailsView.btnGo.frame.size.height);
        
        [annotationDetailsView.btnDetails addTarget:self action:@selector(btnDetails_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [annotationDetailsView.btnGo addTarget:self action:@selector(btnGo_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        [annotationView.contentView addSubview:annotationDetailsView];
        
        _station = mapPointAnnotation.station;
        
        return annotationView;
    } //充电站详情视图
    return nil;
}

#pragma mark - UI Action

- (void)btnGo_TouchUpInside:(UIButton *)sender
{
    CLLocationCoordinate2D endCoordinate;
    endCoordinate.latitude = [_station.station_lat doubleValue];
    endCoordinate.longitude = [_station.station_lng doubleValue];
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:[self BaiduToMars:endCoordinate] addressDictionary:nil]];
    toLocation.name = _station.station_name;
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}

- (void)btnDetails_TouchUpInside:(UIButton *)sender
{
//    StationDetailsViewController *vc = [[StationDetailsViewController alloc] initWithNibName:@"StationDetailsViewController" bundle:nil station_id:_station.station_id];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnStationList_TouchUpInside:(id)sender
{
//    StationListViewController *vc = [[StationListViewController alloc] initWithNibName:@"StationListViewController" bundle:nil station_list:_station_list];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
