//
//  MileageDataRequest.m
//  BusHelp
//
//  Created by Paul on 15/5/14.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "MileageDataRequest.h"
#import "DataRequest.h"
#import "CommonFunctionController.h"
#import "NSDate+custom.h"
#import "MileageItem.h"

@implementation MileageDataRequest
@synthesize resultdic;

+(MileageDataRequest *)shareinstance
{
    static MileageDataRequest *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MileageDataRequest alloc]init];
    });
    return sharedInstance;
}

-(void)fetchVehicleMonthList:(NSString *)vehicle_ids month:(NSString *)month org_id:(NSString *)org_id
{
    if ([CommonFunctionController checkValueValidate:month]&&[CommonFunctionController checkValueValidate:vehicle_ids]&&[CommonFunctionController checkValueValidate:org_id]) {
        [DataRequest fetchVehicleMonthList:vehicle_ids month:month org_id:org_id success:^(id data){
            NSArray *dataArray=[[NSArray alloc]initWithArray:data];
            if (dataArray.count>0) {
                NSDictionary *dic=[data objectAtIndex:0];
                MileageItem *mileModel=[[MileageItem alloc]initWithDictionary:dic error:nil];
                NSLog(@"%@",mileModel.mil_month_list);
                NSMutableArray *key=[[NSMutableArray alloc]init];
                NSMutableArray *value=[[NSMutableArray alloc]init];
                [key removeAllObjects];
                [value removeAllObjects];
                for (int i=0; i<mileModel.mil_month_list.count;i++) {
                    MileageDailyItem *dailyitem=[mileModel.mil_month_list objectAtIndex:i];
                    [key addObject:dailyitem.date];
                    [value addObject:dailyitem.mileage];
                }
                resultdic=[NSDictionary dictionaryWithObjects:value forKeys:key];
            }
            
            NSLog(@"%@",resultdic);
            } failure:^(NSString *message){
            
        }];
    }
}



@end

