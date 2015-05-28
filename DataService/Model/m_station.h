//
//  m_station.h
//  HigerStation
//
//  Created by KevinMao on 15/3/18.
//  Copyright (c) 2015年 Higer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface m_station : NSObject<NSCopying>

//充电站id，用于请求充电站详细信息的参数
@property (nonatomic, strong) NSString * station_id;

//充电站名称
@property (nonatomic, strong) NSString * station_name;

//充电站状态，1001：空闲，1002：占用，1003：即将空闲 1004:停用
@property (nonatomic, strong) NSNumber * station_status;

//充电桩个数
@property (nonatomic, strong) NSNumber * column_count;

//相隔距离，提供距离文字描述包括单位，如“5 km”
@property (nonatomic, strong) NSString * station_distance;

//优惠政策，如果没有优惠政策则返回空字符串，如果有优惠政策则返回优惠政策的文字描述，如“电价8折”
@property (nonatomic, strong) NSString * station_discount;

//地址
@property (nonatomic, strong) NSString * station_address;

//电话
@property (nonatomic, strong) NSString *  station_telephone;

//经度
@property (nonatomic, strong) NSNumber * station_lng;

//纬度
@property (nonatomic, strong) NSNumber * station_lat;

//充电桩数组集合
@property (nonatomic, strong) NSArray * column_list;

//充电桩占用数量
@property (nonatomic, strong) NSNumber *occupy_number;

//充电桩空闲数量
@property (nonatomic, strong) NSNumber *idle_number;

//充电桩即将释放数量
@property (nonatomic, strong) NSNumber *upcoming_release;

//充电桩数据更新时间
@property (nonatomic, strong) NSString *occur_time;


+ (m_station *)convertJsonToModel:(NSDictionary *)json;
+ (NSArray *)convertJsonToList:(NSArray *)jsons;

@end
