//
//  m_column.h
//  HigerStation
//
//  Created by KevinMao on 15/3/18.
//  Copyright (c) 2015年 Higer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface m_column : NSObject<NSCopying>

//充电桩类型，直接显示字段  单位:KW
@property (nonatomic, strong) NSNumber * column_type;

//充电桩状态，1001：空闲，1002：占用，1003：即将空闲 1004:停用
@property (nonatomic, strong) NSNumber * column_status;


+ (m_column *)convertJsonToModel:(NSDictionary *)json;
+ (NSArray *)convertJsonToList:(NSArray *)jsons;

@end
