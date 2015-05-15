//
//  Sql_Utils.h
//  HQhsc
//
//  Created by Ping on 14-9-27.
//  Copyright (c) 2014年 Flycent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"

/**
 *  搜索历史记录等数据库操作
 */


@interface Sql_Utils : NSObject
{
    FMDatabase *_db;
    FMDatabaseQueue *_queue;
}

@property(nonatomic,assign)BOOL isExist;
@property(nonatomic,strong)NSString *Mytoken;

+ (Sql_Utils *)sharedInstance;
#pragma mark -数据库创建和关闭
- (void)createDB;
- (void)closeDB;
- (void)createTable;
- (void)insert:(NSString *)username password:(NSString *)password token:(NSString *)token;
- (void)fetchuser:(NSString *)username password:(NSString *)password;
@end
