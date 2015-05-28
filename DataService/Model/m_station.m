//
//  m_station.m
//  HigerStation
//
//  Created by KevinMao on 15/3/18.
//  Copyright (c) 2015年 Higer. All rights reserved.
//

#import "m_station.h"
#import "m_column.h"

@implementation m_station

@synthesize station_id;
@synthesize station_name;
@synthesize station_status;
@synthesize column_count;
@synthesize station_distance;
@synthesize station_discount;
@synthesize station_address;
@synthesize station_telephone;
@synthesize station_lng;
@synthesize station_lat;
@synthesize column_list;
@synthesize occupy_number;
@synthesize idle_number;
@synthesize upcoming_release;
@synthesize occur_time;

+ (m_station *)convertJsonToModel:(NSDictionary *)json
{
    m_station *model = [[m_station alloc] init];
    
    model.station_id = [json objectForKey:@"station_id"];
    model.station_name = [json objectForKey:@"station_name"];
    model.station_status = [json objectForKey:@"station_status"];
    if ([json.allKeys containsObject:@"column_count"]) {
        model.column_count = [json objectForKey:@"column_count"];
    }
    else {
        model.column_count = [NSNumber numberWithInt:0];
    }
    
    model.occupy_number=[json objectForKey:@"occupy_number"];
    model.idle_number=[json objectForKey:@"idle_number"];
    model.upcoming_release=[json objectForKey:@"upcoming_release"];
    model.occur_time=[json objectForKey:@"occur_time"];

    model.station_distance = [json objectForKey:@"station_distance"];
    model.station_discount = [json objectForKey:@"station_discount"];
    model.station_address = [json objectForKey:@"station_address"];
    model.station_telephone = [json objectForKey:@"station_telephone"];
    model.station_lng = [json objectForKey:@"station_lng"];
    model.station_lat = [json objectForKey:@"station_lat"];
    if ([json.allKeys containsObject:@"column_list"]) {
        NSArray *column_list_json = [json objectForKey:@"column_list"];
        NSMutableArray *column_array = [[NSMutableArray alloc] init];
        for (NSDictionary *column_json in column_list_json) {
            m_column *column = [[m_column alloc] init];
            column.column_type = [column_json objectForKey:@"column_type"];
            column.column_status = [column_json objectForKey:@"column_status"];
            [column_array addObject:column];
        }
        model.column_list = [[NSArray alloc] initWithArray:column_array copyItems:YES];
    }
    
    return model;
}

+ (NSArray *)convertJsonToList:(NSArray *)jsons
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *json in jsons) {
        
        m_station *model = [[m_station alloc] init];
        
        model.station_id = [json objectForKey:@"station_id"];
        model.station_name = [json objectForKey:@"station_name"];
        model.station_status = [json objectForKey:@"station_status"];
        if ([json.allKeys containsObject:@"column_count"]) {
            model.column_count = [json objectForKey:@"column_count"];
        }
        else {
            model.column_count = [NSNumber numberWithInt:0];
        }
        
        model.occupy_number=[json objectForKey:@"occupy_number"];
        model.idle_number=[json objectForKey:@"idle_number"];
        model.upcoming_release=[json objectForKey:@"upcoming_release"];
        model.occur_time=[json objectForKey:@"occur_time"];
        
        model.station_distance = [json objectForKey:@"station_distance"];
        model.station_discount = [json objectForKey:@"station_discount"];
        model.station_address = [json objectForKey:@"station_address"];
        model.station_telephone = [json objectForKey:@"station_telephone"];
        model.station_lng = [json objectForKey:@"station_lng"];
        model.station_lat = [json objectForKey:@"station_lat"];
        if ([json.allKeys containsObject:@"column_list"]) {
            NSArray *column_list_json = [json objectForKey:@"column_list"];
            NSMutableArray *column_array = [[NSMutableArray alloc] init];
            for (NSDictionary *column_json in column_list_json) {
                m_column *column = [[m_column alloc] init];
                column.column_type = [column_json objectForKey:@"column_type"];
                column.column_status = [column_json objectForKey:@"column_status"];
                [column_array addObject:column];
            }
            model.column_list = [[NSArray alloc] initWithArray:column_array copyItems:YES];
        }
        
        [array addObject:model];
    }
    return array;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        column_list = [[NSArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    m_station *copy = [[[self class] allocWithZone:zone] init];
    
    copy->station_id = [station_id copy];
    copy->station_name = [station_name copy];
    copy->station_status = [station_status copy];
    copy->column_count = [column_count copy];
    copy->station_distance = [station_distance copy];
    copy->station_discount = [station_discount copy];
    copy->station_address = [station_address copy];
    copy->station_telephone = [station_telephone copy];
    copy->station_lng = [station_lng copy];
    copy->station_lat = [station_lat copy];
    copy->column_list = [[NSArray alloc] initWithArray:column_list copyItems:YES];
    copy->occupy_number = [occupy_number copy];
    copy->idle_number = [idle_number copy];
    copy->upcoming_release = [upcoming_release copy];
    copy->occur_time = [occur_time copy];

    return copy;
}

@end
