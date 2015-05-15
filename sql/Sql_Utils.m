//
//  Sql_Utils.m
//  HQhsc
//
//  Created by Ping on 14-9-27.
//  Copyright (c) 2014年 Flycent. All rights reserved.
//

#import "Sql_Utils.h"

#define TABLENAME @"logintable"
#define USERNAME @"username"
#define PASSWORD @"password"
#define TOKEN @"token"

@implementation Sql_Utils

+ (Sql_Utils *)sharedInstance
{
    static Sql_Utils *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Sql_Utils alloc]init];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

#pragma mark -数据库创建和关闭
- (void)createDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"bushelp.db"];
    
    NSLog(@"数据库存储位置：%@",dbPath);
    
    _db = [FMDatabase databaseWithPath:dbPath] ;
    
    _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (![_db open])
    {
        NSLog(@"Could not open db.");
    }
}

- (void)closeDB
{
    if ([_db open]) {
        
    }
    [_db close];
    [_queue close];
}

- (void)createTable
{
    if ([_db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT , '%@' TEXT, '%@' TEXT)",TABLENAME,USERNAME,PASSWORD,TOKEN];
        BOOL res = [_db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        [_db close];
        
    }

}
- (void)insert:(NSString *)username password:(NSString *)password token:(NSString *)token
{
    if ([_db open]) {
        NSString *insertSql= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@','%@') VALUES ('%@','%@','%@')",
                               TABLENAME, USERNAME, PASSWORD,TOKEN,username,password,token];
        BOOL res = [_db executeUpdate:insertSql];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        [_db close];
    }

}

- (void)fetchuser:(NSString *)username password:(NSString *)password
{
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@ ",TABLENAME];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            NSLog(@"username = %@ password = %@ token = %@",[rs stringForColumn:USERNAME],[rs stringForColumn:PASSWORD],[rs stringForColumn:TOKEN]);

            if ([[rs stringForColumn:USERNAME] isEqualToString:username]&&[[rs stringForColumn:PASSWORD] isEqualToString:password]) {
                _Mytoken=[rs stringForColumn:TOKEN];
                _isExist=YES;
                return;
            }else
            {
                _isExist=NO;
            }
        }
        [_db close];
    }

}



@end
