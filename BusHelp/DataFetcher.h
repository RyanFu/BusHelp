//
//  DataFetcher.h
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/17.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "MonthItem.h"
#import "Month.h"
#import "OilTypeItem.h"
#import "OilType.h"
#import "StationItem.h"
#import "Station.h"
#import "Task.h"
#import "OrgMessage.h"
#import "OrgItem.h"
#import "Org.h"
#import "OilTotalItem.h"
#import "OilTotal.h"
#import "OilItem.h"
#import "Oil.h"
#import "ViolationItem.h"
#import "Violation.h"
#import "VehicleItem.h"
#import "Vehicle.h"
#import <Foundation/Foundation.h>

@interface DataFetcher : NSObject

/**
 *  数据库名称设置（不同用户数据库切换）
 *
 *  @param storeName 要设定的数据库名称
 */
+ (void)setupCoreDataStackWithStoreNamed:(NSString *)storeName;

/**
 *  将数据导入vehicle数据表
 *
 *  @param dataArray  要导入的数据
 *  @param completion 结束回调
 */
+ (void)importVehicleFromArray:(NSArray *)dataArray completion:(void(^)(void))completion;

/**
 *  添加一条数据到vehicle数据表
 *
 *  @param vehicleItem 要添加数据的数据模型
 *  @param completion  结束回调
 */
+ (void)addVehicleByVehicleItem:(VehicleItem *)vehicleItem completion:(void(^)(void))completion;

/**
 *  删除vehicle数据
 *
 *  @param vehicleArray 要删除的vehicle数据数组
 *  @param completion   结束回调
 */
+ (void)removeVehicleFromArray:(NSArray *)vehicleArray completion:(void(^)(void))completion;

/**
 *  根据vehicleID删除数据
 *
 *  @param vehicleIDArray 要删除的vehicle的id数组
 *  @param completion     结束回调
 */
+ (void)removeVehicleByVehicelIDArray:(NSArray *)vehicleIDArray completion:(void(^)(void))completion;

/**
 *  根据vehicleID删除数据
 *
 *  @param vehicleID  要删除的vehicle的id
 *  @param completion 结束回调
 */
+ (void)removeVehicleByVehicelID:(NSString *)vehicleID completion:(void(^)(void))completion;

/**
 *  更新vehicle数据
 *
 *  @param vehicleItem 要更新数据的数据模型
 *  @param completion  结束回调
 */
+ (void)updateVehicleByVehicleItem:(VehicleItem *)vehicleItem completion:(void(^)(void))completion;

/**
 *  查找所有的vehicle
 *
 *  @param ascending 按时间排序，如果ascending为YES，按升序排列；否则，按降序排列
 *
 *  @return 查询结果
 */
+ (NSArray *)fetchAllVehicle:(BOOL)ascending;

/**
 *  根据vehicleID查找vehicle
 *
 *  @param vehicleIDArray 要查找的vehicle的vehicleID 数组
 *
 *  @return 查询结果
 */
+ (NSArray *)fetchVehicelByVehicleIDArray:(NSArray *)vehicleIDArray;

/**
 *  根据vehicleID查找vehicle
 *
 *  @param vehicleID 要查找的vehicle的vehicleID
 *
 *  @return 查询结果
 */
+ (Vehicle *)fetchVehicelByVehicleID:(NSString *)vehicleID;

/**
 *  根据车牌号查找vehicle
 *
 *  @param numeber 要查找的vehicle的车牌号
 *
 *  @return 查询结果
 */
+ (Vehicle *)fetchVehicelByVehicleNumber:(NSString *)numeber;

/**
 *  将数据导入violation数据表
 *
 *  @param dataArray  要导入的数据
 *  @param completion 结束回调
 */
+ (void)importViolationFromArray:(NSArray *)dataArray completion:(void(^)(void))completion;

/**
 *  删除所有违章
 *
 *  @param completion 结束回调
 */
+ (void)removeAllViolation:(void(^)(void))completion;

/**
 *  查找所有的violation
 *
 *  @param ascending 按时间排序，如果ascending为YES，按升序排列；否则，按降序排列
 *
 *  @return 查询结果
 */
+ (NSArray *)fetchAllViolation:(BOOL)ascending;

/**
 *  根据violationID查找violation
 *
 *  @param violationID 要查找的violation的violationID
 *
 *  @return 查询结果
 */
+ (Violation *)fetchViolationByViolationID:(NSString *)violationID;

/**
 *  根据vehicleID查找violation
 *
 *  @param vehicleID 要查找的violation的vehicleID（vehicle to many violation）
 *  @param ascending 按时间排序，如果ascending为YES，按升序排列；否则，按降序排列
 *
 *  @return 查询结果
 */
+ (NSArray *)fetchViolationByVehicleID:(NSString *)vehicleID ascending:(BOOL)ascending;

/**
 *  将数据导入oil数据表
 *
 *  @param dataArray  要导入的数据
 *  @param vehicleID  对应的车辆id
 *  @param completion 结束回调
 */
+ (void)importOilFromArray:(NSArray *)dataArray vehicleID:(NSString *)vehicleID completion:(void(^)(void))completion;

/**
 *  添加一条数据到oil数据表
 *
 *  @param oilItem    要添加数据的数据模型
 *  @param completion 结束回调
 */
+ (void)addOilByOilItem:(OilItem *)oilItem completion:(void(^)(void))completion;

/**
 *  删除oil数据
 *
 *  @param oilArray   要删除的oil数据数组
 *  @param completion 结束回调
 */
+ (void)removeOilFromArray:(NSArray *)oilArray completion:(void(^)(void))completion;

/**
 *  根据oilID删除数据
 *
 *  @param oilIDArray 要删除的oil的id数组
 *  @param completion 结束回调
 */
+ (void)removeOilByOilIDArray:(NSArray *)oilIDArray completion:(void(^)(void))completion;

/**
 *  更新oil数据
 *
 *  @param oilItem    要更新数据的数据模型
 *  @param completion 结束回调
 */
+ (void)updateOilByOilItem:(OilItem *)oilItem completion:(void(^)(void))completion;

/**
 *  查找所有的oil
 *
 *  @param ascending 按时间排序，如果ascending为YES，按升序排列；否则，按降序排列
 *
 *  @return 查询结果
 */
+ (NSArray *)fetchAllOil:(BOOL)ascending;

/**
 *  根据oilID查找oil
 *
 *  @param oilID 要查找的oil的oilID
 *
 *  @return 查询结果
 */
+ (Oil *)fetchOilByOilID:(NSString *)oilID;

/**
 *  根据oil提交状态查找oil
 *
 *  @param isSubmit 提交状态
 *
 *  @return 查询结果
 */
+ (NSArray *)fetchOilByOilSubmit:(BOOL)isSubmit;

/**
 *  根据vehicleID查找oil
 *
 *  @param vehicleID 要查找的oil的vehicleID（vehicle to many oil）
 *  @param ascending 按时间排序，如果ascending为YES，按升序排列；否则，按降序排列
 *
 *  @return 查询结果
 */
+ (NSArray *)fetchOilByVehicleID:(NSString *)vehicleID ascending:(BOOL)ascending;

/**
 *  根据vehicleID查找oil
 *
 *  @param vehicleID 要查找的oil的vehicleID（vehicle to many oil）
 *  @param isSubmit  是否提交
 *  @param ascending 按时间排序，如果ascending为YES，按升序排列；否则，按降序排列
 *
 *  @return 查询结果
 */
+ (NSArray *)fetchOilByVehicleID:(NSString *)vehicleID isSubmit:(BOOL)isSubmit ascending:(BOOL)ascending;

/**
 *  查找oil更新时间
 *
 *  @param vehicleID 要查找的oil的vehicleID
 *
 *  @return 查询结果
 */
+ (NSString *)fetchOilLastUpdateTimeByVehicleID:(NSString *)vehicleID;

/**
 *  将数据导入oilTotal数据表
 *
 *  @param dataArray  要导入的数据
 *  @param completion 结束回调
 */
+ (void)importOilTotalFromArray:(NSArray *)dataArray completion:(void(^)(void))completion;

/**
 *  查找所有的oilTotal
 *
 *  @return 查询结果
 */
+ (NSArray *)fetchAllOilTotal;

/**
 *  根据vehicleID查找oilTotal
 *
 *  @param vehicleID 要查找的oilTotal的vehicleID（vehicle to one oilTotal）
 *
 *  @return 查询结果
 */
+ (OilTotal *)fetchOilTotalByVehicleID:(NSString *)vehicleID;

/**
 *  将数据导入org数据表
 *
 *  @param dataArray  要导入的数据
 *  @param completion 结束回调
 */
+ (void)importOrgFromArray:(NSArray *)dataArray completion:(void(^)(void))completion;

/**
 *  查找所有的org
 *
 *  @return 查询结果
 */
+ (NSArray *)fetchAllOrg;

/**
 *  根据orgID查找org
 *
 *  @param orgID 要查找的org的orgID
 *
 *  @return 查询结果
 */
+ (Org *)fetchOrgByOrgID:(NSString *)orgID;

/**
 *  组织中vehiclelist添加车辆id
 *
 *  @param orgID      组织id
 *  @param vehicleID  要添加的车辆id
 *  @param completion 结束回调
 */
+ (void)addVehicleIDToOrgByOrgID:(NSString *)orgID vehicleID:(NSString *)vehicleID completion:(void(^)(void))completion;

/**
 *  组织中vehiclelist删除车辆id
 *
 *  @param orgID      组织id
 *  @param vehicleID  要删除的车辆id
 *  @param completion 结束回调
 */
+ (void)removeVehicleIDToOrgByOrgID:(NSString *)orgID vehicleID:(NSString *)vehicleID completion:(void(^)(void))completion;

/**
 *  将数据导入orgMessage数据表
 *
 *  @param dataArray  要导入的数据
 *  @param completion 结束回调
 */
+ (void)importOrgMessageFromArray:(NSArray *)dataArray completion:(void(^)(void))completion;

/**
 *  查找所有的orgMessage
 *
 *  @param ascending 按时间排序，如果ascending为YES，按升序排列；否则，按降序排列
 *
 *  @return 查询结果
 */
+ (NSArray *)fetchAllOrgMessage:(BOOL)ascending;

/**
 *  移除所有组织消息
 *
 *  @param completion 结束回调
 */
+ (void)removeAllOrgMessage:(void(^)(void))completion;

/**
 *  根据orgMessageID查找orgMessage
 *
 *  @param orgMessageID 要查找的orgMessage的orgMessageID
 *
 *  @return 查询结果
 */
+ (OrgMessage *)fetchOrgMessageByOrgMessageID:(NSString *)orgMessageID;

/**
 *  根据orgID查找orgMessage
 *
 *  @param orgID 要查找的orgMessage的orgID（org to many orgMessage）
 *
 *  @param ascending 按时间排序，如果ascending为YES，按升序排列；否则，按降序排列
 *
 *  @return 查询结果
 */
+ (NSArray *)fetchOrgMessageByOrgID:(NSString *)orgID ascending:(BOOL)ascending;

/**
 *  查找未读组织消息数量
 *
 *  @return 查询结果
 */
+ (NSInteger)fetchNotReadOrgMessageCount;

/**
 *  查找组织的最新消息
 *
 *  @param orgID 组织id
 *
 *  @return 查询结果
 */
+ (OrgMessage *)fetchLastestOrgMessageByOrgID:(NSString *)orgID;

/**
 *  更新组织消息为已读
 *
 *  @param orgMessageID 组织消息的id
 *  @param completion  结束回调
 */
+ (void)updateOrgMessageStatusByOrgMessageID:(NSString *)orgMessageID completion:(void(^)(void))completion;

/**
 *  将数据导入task数据表
 *
 *  @param dataArray  要导入的数据
 *  @param completion 结束回调
 */
+ (void)importTaskFromArray:(NSArray *)dataArray completion:(void(^)(void))completion;

/**
 *  查找不同状态的任务数量
 *
 *  @return 返回结果
 */
+ (NSDictionary *)fetchTaskCountDictionary;

/**
 *  删除所有task
 *
 *  @param completion 返回结果
 */
+ (void)removeAllTask:(void(^)(void))completion;

/**
 *  查找最新任务
 *
 *  @return 返回结果
 */
+ (Task *)fetchLastestTask;

/**
 *  更新task的status
 *
 *  @param taskID 要更新task的taskID
 *  @param status 任务状态，1001：未确认，1002：进行中，1003：已完成，1004：已取消
 *  @param completion  结束回调
 */
+ (void)updateTaskStatusByTaskID:(NSString *)taskID status:(TaskStatus)status completion:(void(^)(void))completion;

/**
 *  查找所有task
 *
 *  @param ascending 按时间排序，如果ascending为YES，按升序排列；否则，按降序排列
 *
 *  @return 查询结果
 */
+ (NSArray *)fetchAllTask:(BOOL)ascending;

/**
 *  根据taskID查找task
 *
 *  @param taskID 要查找的task的taskID
 *
 *  @return 查询结果
 */
+ (Task *)fetchTaskByTaskID:(NSString *)taskID;

/**
 *  根据task status查找task
 *
 *  @param status    任务状态，1001：未确认，1002：进行中，1003：已完成，1004：已取消
 *  @param ascending 按时间排序，如果ascending为YES，按升序排列；否则，按降序排列
 *
 *  @return 查询结果
 */
+ (NSArray *)fetchTaskByStatus:(TaskStatus)status ascending:(BOOL)ascending;

/**
 *  根据task status查找task 数量
 *
 *  @param status 任务状态，1001：未确认，1002：进行中，1003：已完成，1004：已取消
 *
 *  @return 查询结果
 */
+ (NSUInteger)fetchTaskCountByStatus:(TaskStatus)status;

/**
 *  根据task status查找task 数量
 *
 *  @param status 任务状态，1001：未确认，1002：进行中，1003：已完成，1004：已取消
 *
 *  @return 查询结果
 */
+ (NSNumber *)fetchTaskNumberByStatus:(TaskStatus)status;

/**
 *  查找task上次更新时间
 *
 *  @return 上次更新时间
 */
+ (NSString *)fetchTaskLastUpdateTime;

/**
 *  查找orgMessage上次更新时间
 *
 *  @return 上次更新时间
 */
+ (NSString *)fetchOrgMessageLastUpdateTime;

/**
 *  添加加油站信息
 *
 *  @param stationItem 加油站信息数据模型
 *  @param completion  结束回调
 */
+ (void)addStationByStationItem:(StationItem *)stationItem completion:(void(^)(void))completion;

/**
 *  查找所有加油站
 *
 *  @return 油站数组
 */
+ (NSArray *)fetchAllStation;

/**
 *  删除加油站
 *
 *  @param station 要删除的加油站数据
 *  @param completion  结束回调
 */
+ (void)removeStationByStation:(Station *)station completion:(void(^)(void))completion;

/**
 *  添加油品信息
 *
 *  @param oilTypeItem 油品信息数据模型
 *  @param completion  结束回调
 */
+ (void)addOilTypeByOilTypeItem:(OilTypeItem *)oilTypeItem completion:(void(^)(void))completion;

/**
 *  查找所有油品
 *
 *  @return 油品数组
 */
+ (NSArray *)fetchAllOilType;

/**
 *  删除油品
 *
 *  @param station 要删除的油品数据
 *  @param completion  结束回调
 */
+ (void)removeOilTypeByOilType:(OilType *)oilType completion:(void(^)(void))completion;

/**
 *  根据组织id删除组织
 *
 *  @param orgID      组织id
 *  @param completion 结束回调
 */
+ (void)removeOrgByOrgID:(NSString *)orgID completion:(void(^)(void))completion;

@end
