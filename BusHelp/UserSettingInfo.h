//
//  UserSettingInfo.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/21.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSettingInfo : NSObject

/**
 *  验证用户是否登录
 *
 *  @return 如果返回值为YES，已登录；否则，未登录
 */
+ (BOOL)checkIsLogin;

/**
 *  根据不同用户连接数据库
 */
+ (void)setupDatabase;

/**
 *  保存用户登录信息，并切换数据库
 *
 *  @param username 要保存的用户名称
 *  @param password 要保存的用户密码
 *  @param token token值
 */
+ (void)setupLoginUsername:(NSString *)username password:(NSString *)password token:(NSString *)token;

/**
 *  get用户登录信息
 *
 *  @return 登录用户名
 */
+ (NSString *)fetchLoginUsername;

/**
 *  get用户登录信息
 *
 *  @return 登录密码
 */
+ (NSString *)fetchLoginPassword;

/**
 *  get用户token
 *
 *  @return 登录用户名
 */
+ (NSString *)fetchLoginToken;

/**
 *  删除token
 */
+ (void)removeToken;

/**
 *  用户注销，清除登录信息
 */
+ (void)cleanupLoginInfo;

/**
 *  设置是否显示splash页面
 */
+ (void)setupSplashHasShown;

/**
 *  get用户splash has shown信息
 *
 *  @return splash has shown
 */
+ (BOOL)fetchSplashHasShown;

/**
 *  设置设备id
 */
+ (void)setupDeviceID;

/**
 *  查找设备id
 *
 *  @return 设备id
 */
+ (NSString *)fetchDeviceID;

/**
 *  log信息
 *
 *  @param object log对象
 */
+ (void)userLogWithMessage:(id)object;

/**
 *  图像缓存设置
 */
+ (void)setupImageCache;

/**
 *  获取当前应用版本号
 */
+ (NSString *)fetchAppVersion;

/**
 *  获取应用最新版本号
 */
+ (NSString *)fetchAppLastestVersion;

/**
 *  保存最新版本
 */
+ (void)saveAppLastestVersion:(NSString *)version;

/**
 *  网络请求设置
 */
+ (void)setupNetworking;

/**
 *  通知设置
 */
+ (void)setupNotification:(BOOL)isNotification;

/**
 *  获取通知设置
 *
 *  @return 返回值
 */
+ (BOOL)fetchNotificationStatus;

/**
 *  添加设备推送token
 *
 *  @param deviceToken 设备推送token
 */
+ (void)setupPushDeviceToken:(NSString *)deviceToken;

/**
 *  获取推送的device token
 *
 *  @return 设备推送token
 */
+ (NSString *)fetchPushDeviceToken;

/**
 *  帮助页面显示
 *
 *  @param key 不同帮助页面的key
 *
 *  @return 是否已显示过
 */
+ (BOOL)fetchHelpIsReadByKey:(NSString *)key;

/**
 *  帮助页面显示设置
 *
 *  @param key 不同帮助页面的key
 */
+ (void)setupHelpReadByKey:(NSString *)key;

@end
