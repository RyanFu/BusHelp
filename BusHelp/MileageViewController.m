//
//  MileageViewController.m
//  BusHelp
//
//  Created by Paul on 15/5/13.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "MileageViewController.h"
#import "CommonFunctionController.h"

#import "CalendarHomeViewController.h"
#import "CalendarViewController.h"
//#import "CalendarDayModel.h"
#import "Color.h"
#import "SelectVehicleViewController.h"
#import "DataRequest.h"
#import "CommonFunctionController.h"
#import "Vehicle.h"
#import "NSDate+custom.h"
#import "BDUGpsCorrect.h"

@interface MileageViewController ()
{
    NSString *weekday;
    CLLocationManager *locationManager;
    CalendarHomeViewController *chvc;
    NSArray *_vehicleArray;
    Vehicle *_vehicle;
    Org *_org;
}
@end

@implementation MileageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self getOrg:YES];
    [self setupVehicleNumber];
    [self setupData];
    self.activityindicator.hidden=YES;
    self.activityindicator.hidesWhenStopped=YES;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter=1000.0f,
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
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
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    /* We received the new location */
    
    NSDictionary *correctDictionary = [BDUGpsCorrect transformWithOriLat:newLocation.coordinate.latitude withOriLon:newLocation.coordinate.longitude];

    CLLocationCoordinate2D _currentCoordinate = CLLocationCoordinate2DMake([[correctDictionary objectForKey:BDUGPSCORRECT_KEY_DICT_RESULT_LAT] doubleValue], [[correctDictionary objectForKey:BDUGPSCORRECT_KEY_DICT_RESULT_LON] doubleValue]);
    
    CLLocation *myloaction=[[CLLocation alloc]initWithLatitude:_currentCoordinate.latitude longitude:_currentCoordinate.longitude];
    
    if (CLLocationCoordinate2DIsValid(_currentCoordinate))
    {
        //---------------位置反编码----------------
        CLGeocoder *geocoder=[[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:myloaction completionHandler:^(NSArray *placemarks, NSError *error){
            [self.activityindicator stopAnimating];
            for (CLPlacemark *place in placemarks) {
                NSLog(@"name=%@",place.name);                         //位置名
                NSLog(@"thoroughfare=%@",place.thoroughfare);         //街道
                NSLog(@"subThoroughfare=%@",place.subThoroughfare);   //子街道
                NSLog(@"locality=%@",place.locality);                 //市
                NSLog(@"subLocality=%@",place.subLocality);           //区
                NSLog(@"country=%@",place.country);                   //国家
                self.AddressLabel.text=place.name;
            }
            [locationManager stopUpdatingLocation];
            
        }
         ];

    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    /* Failed to receive user's location */
    NSLog(@"%@",error);
    if (![CommonFunctionController checkUrlValidate:self.AddressLabel.text]) {
        [CommonFunctionController showHUDWithMessage:@"请打开定位服务" detail:nil];
        self.activityindicator.hidden=YES;
    }
    
}


-(void)setupData
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    NSLog(@"%@",now);
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger year =[comps year];
    NSInteger week = [comps weekday];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    //    NSInteger hour = [comps hour];
    //    NSInteger min = [comps minute];
    //    NSInteger sec = [comps second];
    switch (week) {
        case 7:
            weekday=@"星期六";
            break;
        case 1:
            weekday=@"星期日";
            break;
        case 2:
            weekday=@"星期一";
            break;
        case 3:
            weekday=@"星期二";
            break;
        case 4:
            weekday=@"星期三";
            break;
        case 5:
            weekday=@"星期四";
            break;
        case 6:
            weekday=@"星期五";
            break;
            
        default:
            break;
    }
    self.DataLabel.text=[NSString stringWithFormat:@"%ld年%ld月%ld日 %@",(long)year,(long)month,(long)day,weekday];

}


- (void)setupNavigationBar
{
    [super setupNavigationBar];
    self.navigationItem.title=@"里程";
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mileage-more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    
    chvc = [[CalendarHomeViewController alloc]init];
    
    chvc.calendartitle = _vehicle.number;
    chvc.vehicle=_vehicle;
    chvc.org=_org;
    
    //    [chvc setAirPlaneToDay:100 ToDateforString:@"2015-4-1"];//日历初始化方法
    

    [self.navigationController pushViewController:chvc animated:YES];
    
    //    chvc.calendarblock = ^(CalendarDayModel *model){
    //
    //        NSLog(@"\n---------------------------");
    //        NSLog(@"1星期 %@",[model getWeek]);
    //        NSLog(@"2字符串 %@",[model toString]);
    //        NSLog(@"3节日  %@",model.holiday);
    //
    //    };
    


}


- (IBAction)getAddressAction:(id)sender {
    [locationManager startUpdatingLocation];
    self.activityindicator.hidden=NO;
    [self.activityindicator startAnimating];
}

- (IBAction)selectvehicle:(id)sender {
    [self performSegueWithIdentifier:@"MileageToSelectVehicle" sender:self];
}

- (IBAction)submitAction:(id)sender {
    [self.mileageLabel resignFirstResponder];
    if ([CommonFunctionController checkValueValidate:self.mileageLabel.text]&&[CommonFunctionController checkValueValidate:self.vehicleNumber.titleLabel.text]) {
        [self setupOrgWithRequest:YES];
        
    }else
    {
        [CommonFunctionController showHUDWithMessage:@"请填写完整" detail:nil];
    }
}

- (void)setupOrgWithRequest:(BOOL)request {
    if (request && [CommonFunctionController checkNetworkWithNotify:NO]) {
        [DataRequest fetchOrgWithSuccess:^(NSArray *orgArray) {
            _org = [orgArray firstObject];
            NSLog(@"组织名称：%@",_org.name);
            if (!_org) {
                _org.name=@"";
            }
            [self postVehicleMile];
        
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message detail:nil];
        }];
    }
    else {
        [CommonFunctionController showHUDWithMessage:@"网络已断开" detail:nil];
    }
}

-(void)postVehicleMile
{
    [DataRequest saveVehicleDailyMile:self.mileageLabel.text org_id:_org.orgID vehicle_id:_vehicle.vehicleID  position:self.AddressLabel.text success:^(id data){
        [CommonFunctionController showHUDWithMessage:@"上传成功" detail:nil];
    } failure:^(NSString *message){
        [CommonFunctionController showHUDWithMessage:message detail:nil];
    }];
}

-(void)setupVehicleNumber
{
    if ([DataFetcher fetchAllVehicle:YES].count) {
        _vehicleArray=[DataFetcher fetchAllVehicle:YES];
        _vehicle=[_vehicleArray firstObject];
        [self.vehicleNumber setTitle:_vehicle.number forState:UIControlStateNormal];
        [self.vehicleNumber setTintColor:[UIColor blackColor]];
    }
    else if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        
        [CommonFunctionController showAnimateMessageHUD];
        [DataRequest fetchVehicleWithSuccess:^(NSArray *vehicleArray) {
            _vehicleArray = [NSMutableArray arrayWithArray:vehicleArray];
            _vehicle=[_vehicleArray firstObject];
            [self.vehicleNumber setTitle:_vehicle.number forState:UIControlStateNormal];
            [self.vehicleNumber setTintColor:[UIColor blackColor]];
    
            [CommonFunctionController hideAllHUD];
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
    
}

-(void)getOrg:(BOOL)request
{
    if (request && [CommonFunctionController checkNetworkWithNotify:NO]) {
        [DataRequest fetchOrgWithSuccess:^(NSArray *orgArray) {
            _org = [orgArray firstObject];
            NSLog(@"组织名称：%@",_org.name);
            if (!_org) {
                _org.name=@"";
            }            
        } failure:^(NSString *message){
            [CommonFunctionController showHUDWithMessage:message success:NO];
        }];
    }
    else {
        [CommonFunctionController showHUDWithMessage:@"网络已断开" detail:nil];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"MileageToSelectVehicle"]) {
        SelectVehicleViewController *selectvehicle=segue.destinationViewController;
        selectvehicle.dismiss=^(Vehicle *selectVehicle){
            _vehicle=selectVehicle;
            [self.vehicleNumber setTitle:_vehicle.number forState:UIControlStateNormal];
            [self.vehicleNumber setTintColor:[UIColor blackColor]];
        };
    }
}


@end
