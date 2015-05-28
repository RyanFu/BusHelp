//
//  StationMapViewController.h
//  HigerStation
//
//  Created by KevinMao on 15/3/18.
//  Copyright (c) 2015年 Higer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseInfo.h"
#import "StationBaseViewController.h"
//#import "StationListViewController.h"
#import "StationMapPointAnnotation.h"

@interface StationMapViewController : StationBaseViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    NetStationService *_stationService;
    CLLocationCoordinate2D _srcCoordinate;
    NSArray *_station_list;
    StationMapPointAnnotation *_mapPointAnnotation;
    m_station *_station; //当前打开信息的充电站
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)btnStationList_TouchUpInside:(id)sender;
- (IBAction)backButton:(id)sender;

@end
