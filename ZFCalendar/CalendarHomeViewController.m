//
//  CalendarHomeViewController.m
//  Calendar
//
//  Created by 张凡 on 14-6-23.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarHomeViewController.h"
#import "Color.h"
#import "SelectVehicleViewController.h"
#import "DataRequest.h"
#import "NSDate+custom.h"
#import "CommonFunctionController.h"
#import "MileageItem.h"

@interface CalendarHomeViewController ()
{
    int daynumber;//天数
    int optiondaynumber;//选择日期数量
//    NSMutableArray *optiondayarray;//存放选择好的日期对象数组
    
}

@end

@implementation CalendarHomeViewController
@synthesize vehicle,org;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchVehicleMonthList];

}

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    [self fetchVehicleMonthList];
//
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    UIBarButtonItem *rightbarbutton=[[UIBarButtonItem alloc]initWithTitle:@"换车" style:UIBarButtonItemStyleDone target:self action:@selector(changeVehicle)];
    self.navigationItem.rightBarButtonItem=rightbarbutton;
    
    
}

-(void)fetchVehicleMonthList
{
    [CommonFunctionController showAnimateMessageHUD];
    NSString *month=[[NSDate date] dateToStringWithFormatter:@"yyyy-MM"];
    NSLog(@"%@",vehicle.vehicleID);
    NSLog(@"%@",org.orgID);
    NSLog(@"%@",month);
    
    if ([CommonFunctionController checkValueValidate:month]&&[CommonFunctionController checkValueValidate:vehicle.vehicleID]&&[CommonFunctionController checkValueValidate:org.orgID]) {
        [DataRequest fetchVehicleMonthList:vehicle.vehicleID month:month org_id:org.orgID success:^(id data){
            NSArray *dataArray=[[NSArray alloc]initWithArray:data];
            if (dataArray.count>0) {
                NSDictionary *dic=[data objectAtIndex:0];
                MileageItem *mileModel=[[MileageItem alloc]initWithDictionary:dic error:nil];
//                NSLog(@"%@",mileModel.mil_month_list);
                NSMutableArray *key=[[NSMutableArray alloc]init];
                NSMutableArray *value=[[NSMutableArray alloc]init];
                [key removeAllObjects];
                [value removeAllObjects];
                for (int i=0; i<mileModel.mil_month_list.count;i++) {
                    MileageDailyItem *dailyitem=[mileModel.mil_month_list objectAtIndex:i];
                    [key addObject:dailyitem.date];
                    [value addObject:dailyitem.mileage];
                }
                NSDictionary *resultdic=[NSDictionary dictionaryWithObjects:value forKeys:key];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"DailyMile"];
                [[NSUserDefaults standardUserDefaults]setObject:resultdic forKey:@"DailyMile"];
                [[NSUserDefaults standardUserDefaults]synchronize];
//                NSLog(@"%@",resultdic);
                [self setAirPlaneToDay:100 ToDateforString:@"2015-5-1"];//日历初始化方法
                [CommonFunctionController hideAllHUD];
            }else
            {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"DailyMile"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self setAirPlaneToDay:100 ToDateforString:@"2015-5-1"];//日历初始化方法
                [CommonFunctionController hideAllHUD];

            }
        } failure:^(NSString *message){
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"DailyMile"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self setAirPlaneToDay:100 ToDateforString:@"2015-5-1"];//日历初始化方法
            [CommonFunctionController showHUDWithMessage:@"获取数据失败" detail:nil];
        }];
    }else
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"DailyMile"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self setAirPlaneToDay:100 ToDateforString:@"2015-5-1"];//日历初始化方法
        [CommonFunctionController hideAllHUD];
    }

    
}

//-(void)setup
//{
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"DailyMile"]) {
//        [self setAirPlaneToDay:100 ToDateforString:@"2015-5-1"];//日历初始化方法
//        [CommonFunctionController hideAllHUD];
//
//    }else
//    {
//        [self setAirPlaneToDay:100 ToDateforString:@"2015-5-1"];//日历初始化方法
//        [CommonFunctionController showHUDWithMessage:@"该车还没有记录" detail:nil];
//    }
//    
//}

//-(void)fetchVehicleMonthList
//{
//    NSString *month=[[NSDate date] dateToStringWithFormatter:@"yyyy-MM"];
//    NSLog(@"%@",vehicle.vehicleID);
//    NSLog(@"%@",org.orgID);
//    NSLog(@"%@",month);
//    [[MileageDataRequest shareinstance]fetchVehicleMonthList:vehicle.vehicleID month:month org_id:org.orgID];
//    
//}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 设置方法

//飞机初始化方法
- (void)setAirPlaneToDay:(int)day ToDateforString:(NSString *)todate
{
    daynumber = day;
    optiondaynumber = 1;//选择一个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    [super.collectionView reloadData];//刷新
}

//酒店初始化方法
- (void)setHotelToDay:(int)day ToDateforString:(NSString *)todate
{

    daynumber = day;
    optiondaynumber = 2;//选择两个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    [super.collectionView reloadData];//刷新
}


//火车初始化方法
- (void)setTrainToDay:(int)day ToDateforString:(NSString *)todate
{
    daynumber = day;
    optiondaynumber = 1;//选择一个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    [super.collectionView reloadData];//刷新
    
}



#pragma mark - 逻辑代码初始化

//获取时间段内的天数数组
- (NSMutableArray *)getMonthArrayOfDayNumber:(int)day ToDateforString:(NSString *)todate
{
    
    NSDate *date = [NSDate date];
    
    NSDate *selectdate  = [NSDate date];
    
    if (todate) {
        
        selectdate = [selectdate dateFromString:todate];
        
    }
    
    super.Logic = [[CalendarLogic alloc]init];
    
    return [super.Logic reloadCalendarView:date selectDate:selectdate  needDays:day];
}



#pragma mark - 设置标题

- (void)setCalendartitle:(NSString *)calendartitle
{

    [self.navigationItem setTitle:calendartitle];

}

-(void)changeVehicle
{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SelectVehicleViewController *selectvehicle = [main instantiateViewControllerWithIdentifier:NSStringFromClass([SelectVehicleViewController class])];
    selectvehicle.dismiss=^(Vehicle *selectVehicle){
        vehicle=selectVehicle;
        [self setCalendartitle:selectVehicle.number];
    };
    [self.navigationController pushViewController:selectvehicle animated:YES];
}


@end
