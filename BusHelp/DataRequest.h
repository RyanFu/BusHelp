//
//  DataRequest.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/19.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFetcher.h"

@interface DataRequest : NSObject

/**
 *  保存设备信息
 *
 *  @param success 成功返回
 *  @param failure 失败返回
 */
+ (void)saveDeviceWithSuccess:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  用户登录接口
 *
 *  @param username 登录用户名
 *  @param password 登录密码
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(void(^)(BOOL needBindVehicle))success failure:(void(^)(NSString *message))failure;

/**
 *  验证码发送接口
 *
 *  @param phoneNumber 要发送验证码的手机号
 *  @param success     成功返回
 *  @param failure     失败返回
 */
+ (void)sendRegisterCodeWithPhoneNumber:(NSString *)phoneNumber isRegister:(BOOL)isRegister success:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  用户注册接口
 *
 *  @param phoneNumber     注册手机号
 *  @param password        注册密码
 *  @param registerCode    验证码
 *  @param success         成功返回
 *  @param failure         失败返回
 */
+ (void)registerWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password registerCode:(NSString *)registerCode success:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  用户注销接口
 *
 *  @param success 成功返回
 *  @param failure 失败返回
 */
+ (void)logoutWithSuccess:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  用户找回密码
 *
 *  @param phoneNumber     注册手机号
 *  @param password        密码
 *  @param registerCode    验证码
 *  @param success         成功返回
 *  @param failure         失败返回
 */
+ (void)findPasswordWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password registerCode:(NSString *)registerCode success:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  保存车辆信息
 *
 *  @param vehicleItem 车辆信息数据模型
 *  @param update      是更新数据还是添加数据
 *  @param success     成功返回
 *  @param failure     失败返回
 */
+ (void)saveVehicleWithVehicleItem:(VehicleItem *)vehicleItem update:(BOOL)update success:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  删除vehicle
 *
 *  @param vehicleID 要删除vehicle的vehicleID
 *  @param success   成功返回
 *  @param failure   失败返回
 */
+ (void)removeVehicleWithVehicleID:(NSString *)vehicleID success:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  查找vehicle
 *
 *  @param success 成功返回
 *  @param failure 失败返回
 */
+ (void)fetchVehicleWithSuccess:(void(^)(NSArray *vehicleArray))success failure:(void(^)(NSString *message))failure;

/**
 *  绑定车辆至用户
 *
 *  @param success 成功返回
 *  @param failure 失败返回
 */
+ (void)bindVehicleWithSuccess:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  查找violation
 *
 *  @param vehicleID 关联violation的vehicleID
 *  @param success   成功返回
 *  @param failure   失败返回
 */
+ (void)fetchViolationWithVehicleID:(NSString *)vehicleID success:(void(^)(NSArray *violationArray))success failure:(void(^)(NSString *message))failure;

/**
 *  违章信息批量导入
 *
 *  @param vehicleIDArray 关联violation的vehicleID数组
 *  @param success        成功返回
 *  @param failure        失败返回
 */
+ (void)importAllViolationWithVehicleIDArray:(NSArray *)vehicleIDArray success:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  保存油耗信息
 *
 *  @param oilItem 油耗信息数据模型
 *  @param update  是更新数据还是添加数据
 *  @param success 成功返回
 *  @param failure 失败返回
 */
+ (void)saveOilWithOilItem:(OilItem *)oilItem update:(BOOL)update success:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  查找oil
 *
 *  @param vehicleID      关联oil的vehicleID
 *  @param success        成功返回
 *  @param failure        失败返回
 */
+ (void)fetchOilWithVehicleID:(NSString *)vehicleID success:(void(^)(NSArray *oilArray))success failure:(void(^)(NSString *messages))failure;

/**
 *  删除oil
 *
 *  @param oilID     要删除oil的oilID
 *  @param vehicleID 要删除oil的vehicleID
 *  @param success   成功返回
 *  @param failure   失败返回
 */
+ (void)removeOilWithOilID:(NSString *)oilID vehicleID:(NSString *)vehicleID success:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  查找oilTotal
 *
 *  @param vehicleID 关联oilTotal的vehicleID
 *  @param success   成功返回
 *  @param failure   失败返回
 */
+ (void)fetchOilTotalWithVehicleID:(NSString *)vehicleID success:(void(^)(OilTotal *oilTotal))success failure:(void(^)(NSString *message))failure;

/**
 *  批量导入oilTotal
 *
 *  @param vehicleIDArray 关联oilTotal的vehicleID的数组
 *  @param success        成功返回
 *  @param failure        失败返回
 */
+ (void)importOilTotalWithVehicleIDArray:(NSArray *)vehicleIDArray success:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  查找task 数量
 *
 *  @param success 成功返回
 *  @param failure 失败返回
 */
+ (void)fetchTaskCountWithSuccess:(void(^)(NSDictionary *taskCountDictionary))success failure:(void(^)(NSString *message))failure;

/**
 *  确认任务
 *
 *  @param taskID  要确认任务的id
 *  @param success 成功返回
 *  @param failure 失败返回
 */
+ (void)confirmTaskByTaskID:(NSString *)taskID success:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  查找task
 *
 *  @param taskID  task id
 *  @param success 成功返回
 *  @param failure 失败返回
 */
+ (void)fetchTaskWithTaskID:(NSString *)taskID success:(void(^)(Task *task))success failure:(void(^)(NSString *message))failure;

/**
 *  获取组织列表
 *
 *  @param success 成功返回
 *  @param failure 失败返回
 */
+ (void)fetchOrgWithSuccess:(void(^)(NSArray *orgArray))success failure:(void(^)(NSString *message))failure;

/**
 *  根据组织id获取组织消息列表
 *
 *  @param orgID           组织id
 *  @param lastMessageID   最近一条组织消息ID（按照更新时间 降序排序）
 *  @param count           请求消息条数（分页使用）
 *  @param success         成功返回
 *  @param failure         失败返回
 */
+ (void)fetchOrgMessageWithOrgID:(NSString *)orgID org_message_action:(NSString *)org_message_action lastMessageID:(NSString *)lastMessageID count:(NSInteger)count success:(void(^)(NSArray *orgMessageArray, BOOL isEnd))success failure:(void(^)(NSString *message))failure;
/**
 *  根据orgMessageID 查找orgMessage
 *
 *  @param orgMessageID message id
 *  @param success      成功返回
 *  @param failure      失败返回
 */
+ (void)fetchOrgMessageWithOrgMessageID:(NSString *)orgMessageID success:(void(^)(OrgMessage *orgMessage))success failure:(void(^)(NSString *message))failure;

/**
 *  是否加入组织
 *
 *  @param orgID        组织id
 *  @param orgMessageID 组织消息id
 *  @param action       操作组织消息动作，200101：确认加入，200102：拒绝加入
 *  @param messageType  组织消息类型，1001：组织普通通知消息，2001：组织邀请加入消息
 *  @param success      成功返回
 *  @param failure      失败返回
 */
+ (void)joinOrgWithOrgID:(NSString *)orgID orgMessageID:(NSString *)orgMessageID action:(OrgAction)action messageType:(OrgMessageType)messageType success:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  屏蔽组织车辆
 *
 *  @param orgID     组织id
 *  @param vehicleID 要屏蔽的车辆id
 *  @param action    操作类型，1001：确定屏蔽，1002：取消屏蔽
 *  @param success   成功返回
 *  @param failure   失败返回
 */
+ (void)shieldOrgVehicleWithOrgID:(NSString *)orgID vehicleID:(NSString *)vehicleID action:(ShieldAction)action success:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  提交反馈
 *
 *  @param content 反馈内容
 *  @param success 成功返回
 *  @param failure 失败返回
 */
+ (void)submitFeedbackByContent:(NSString *)content success:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  检查应用版本更新
 *
 *  @param success 成功返回
 *  @param failure 失败返回
 */
+ (void)checkVersionBySuccess:(void(^)(NSString *url))success failure:(void(^)(NSString *message))failure;

/**
 *  退出组织
 *
 *  @param orgID   要退出组织的id
 *  @param success 成功返回
 *  @param failure 失败返回
 */
+ (void)outOrgByOrgID:(NSString *)orgID success:(void(^)())success failure:(void(^)(NSString *message))failure;

/**
 *  根据组织代号查询组织
 *
 *  @param orgInfo 组织代号或名称
 *  @param success 成功返回
 *  @param failure 失败返回
 */
+ (void)fetchOrgByOrgInfo:(NSString *)orgInfo success:(void(^)(NSArray *orgItemArray))success failure:(void(^)(NSString *message))failure;

/**
 *  申请加入组织
 *
 *  @param orgID    组织id
 *  @param username 用户名
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)applyOrgWithOrgID:(NSString *)orgID username:(NSString *)username success:(void (^)())success failure:(void (^)(NSString *message))failure;

/**
 *  取消申请
 *
 *  @param orgID   组织id
 *  @param success 成功返回
 *  @param failure 失败返回
 */
+ (void)cancelOrgApplyingWithOrgID:(NSString *)orgID success:(void (^)())success failure:(void (^)(NSString *message))failure;

//创建组织
+ (void)createOrgWithOrgName:(NSString *)orgName success:(void (^)())success failure:(void (^)(NSString *message))failure;

//解散组织
+ (void)dissolveOrgWithOrgID:(NSString *)orgID success:(void (^)())success failure:(void (^)(NSString *message))failure;

//获取组织所有成员
+ (void)getOrgAllUser:(NSString *)ordID success:(void (^)(NSDictionary *dictionary))success failure:(void (^)(NSString *message))failure;

//发送通知
+ (void)postNotification:(NSString *)receiver_id org_id:(NSString *)org_id message_title:(NSString *)message_title message_content:(NSString *)message_content success:(void (^)(NSDictionary *dictionary))success failure:(void (^)(NSString *message))failure;

//保存车辆当日历程
+ (void)saveVehicleDailyMile:(NSString *)mileage org_id:(NSString *)org_id vehicle_id:(NSString *)vehicle_id position:(NSString *)position success:(void (^)(NSDictionary *dictionary))success failure:(void (^)(NSString *message))failure;

//获取车辆每个月历程明细
+ (void)fetchVehicleMonthList:(NSString *)vehicle_ids month:(NSString *)month org_id:(NSString *)org_id success:(void (^)(NSDictionary *dictionary))success failure:(void (^)(NSString *message))failure;


@end
