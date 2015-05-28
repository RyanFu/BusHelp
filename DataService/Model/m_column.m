//
//  m_column.m
//  HigerStation
//
//  Created by KevinMao on 15/3/18.
//  Copyright (c) 2015年 Higer. All rights reserved.
//

#import "m_column.h"

@implementation m_column

@synthesize column_type;
@synthesize column_status;

+ (m_column *)convertJsonToModel:(NSDictionary *)json
{
    m_column *model = [[m_column alloc] init];
    
    model.column_type = [json objectForKey:@"column_type"];
    model.column_status = [json objectForKey:@"column_status"];
    
    return model;
}

+ (NSArray *)convertJsonToList:(NSArray *)jsons
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *json in jsons) {
        
        m_column *model = [[m_column alloc] init];
        
        model.column_type = [json objectForKey:@"column_type"];
        model.column_status = [json objectForKey:@"column_status"];
        
        [array addObject:model];
    }
    return array;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    m_column *copy = [[[self class] allocWithZone:zone] init];
    
    copy->column_type = [column_type copy];
    copy->column_status = [column_status copy];
    
    return copy;
}

@end
