//
//  MileageList.h
//  BusHelp
//
//  Created by Paul on 15/5/14.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol MileageDailyItem <NSObject>
@end

@protocol MileageItem <NSObject>
@end

@interface MileageItem : JSONModel
@property(nonatomic,strong)NSArray<MileageDailyItem> *mil_month_list;
@property(nonatomic,strong)NSString *month;
@property(nonatomic,strong)NSString *vehicle_no;


@end


@interface MileageDailyItem : JSONModel
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *mileage;
@property(nonatomic,strong)NSString *mileage_id;
@property(nonatomic,strong)NSString *position;
@property(nonatomic,strong)NSString *vehicle_no;


@end