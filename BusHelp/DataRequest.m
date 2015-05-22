//
//  DataRequest.m
//  BusHelp
//
//  Created by 夜枫尘 on 15/2/19.
//  Copyright (c) 2015年 夜枫尘. All rights reserved.
//

#import "DataRequest.h"
#import "BaseDataItem.h"
#import "DataFetcher.h"
#import "NSDate+custom.h"
#import "ImageCache.h"
#import "ImageDownloader.h"
#import "Sql_Utils.h"

static NSTimeInterval const sceonds = 60;

@implementation DataRequest

+ (NSDictionary *)baseRequestParametersWithDictionary:(NSDictionary *)otherDictionary {
    NSDictionary *dictionary = @{@"device_id" : [UserSettingInfo fetchDeviceID]};
    NSMutableDictionary *parametersDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    if ([UserSettingInfo checkIsLogin] && ![otherDictionary.allKeys containsObject:@"device_type"]) {
        [parametersDictionary setObject:[UserSettingInfo fetchLoginToken] forKey:@"access_token"];
    }
    if ([CommonFunctionController checkValueValidate:otherDictionary] != nil) {
        for (NSString *key in otherDictionary) {
            [parametersDictionary setObject:[otherDictionary objectForKey:key] forKey:key];
        }
    }
    
    return parametersDictionary;
}

+ (NSString *)urlStringWithParameters:(NSString *)url {
    NSString *nonce = [[NSUUID UUID] UUIDString];
    NSString *timestamp = [[NSDate date] dateToStringWithFormatter:@"yyyyMMddHHmmss"];
    NSString *signature = [CommonFunctionController hmac:[NSString stringWithFormat:@"%@%@", nonce, timestamp] withKey:HMACSHA1KEY];
    NSString *urlString = [NSString stringWithFormat:@"%@?v=1.0&nonce=%@&timestamp=%@&signature=%@",url, nonce, timestamp, signature];
    
    return urlString;
}

+ (void)POST:(NSString *)url parameters:(id)parameters success:(void(^)(id data))success failure:(void(^)(NSString *message))failure {
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *baseParameters = [self baseRequestParametersWithDictionary:parameters];
        NSString *baseUrl = [self urlStringWithParameters:url];
        DLog(@"------url = %@, parameters = %@-------", baseUrl, baseParameters);
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setTimeoutInterval:sceonds];
        [manager POST:baseUrl parameters:baseParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"%@",responseObject);
            BaseDataItem *baseDataItem = [[BaseDataItem alloc] initWithDictionary:responseObject];
            if (baseDataItem.success) {
                success(baseDataItem.data);
            }
            else {
                if (baseDataItem.needAuth) {
                    [UserSettingInfo removeToken];
                    if ([UserSettingInfo fetchLoginUsername] != nil && [UserSettingInfo fetchLoginPassword] != nil) {
                        [self loginWithUsername:[UserSettingInfo fetchLoginUsername] password:[UserSettingInfo fetchLoginPassword] success:^(BOOL needBindVehicle) {
                            [self POST:url parameters:parameters success:^(id data) {
                                success(data);
                            } failure:failure];
                        } failure:failure];
                    }
                    else {
                        failure(ERROR_MESSAGE_5);
                    }
                }
                else {
                    failure(baseDataItem.message);
                }
            }
            DLog(@"method = %s, url = %@, message = %@", __FUNCTION__, url, baseDataItem.message);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(ERROR_MESSAGE_1);
            DLog(@"method = %s, url = %@, error = %@", __FUNCTION__, url, error);
        }];
    }
    else {
        failure(ERROR_MESSAGE_1);
    }
}

+ (void)POST:(NSString *)url parameters:(id)parameters attachmentDic:(NSDictionary *)attachmentDic success:(void(^)(id data))success failure:(void(^)(NSString *message))failure {
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        parameters = [self baseRequestParametersWithDictionary:parameters];
        url = [self urlStringWithParameters:url];
        DLog(@"------url = %@, parameters = %@-------", url, parameters);
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setTimeoutInterval:sceonds * 3];
        [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (NSString *key in attachmentDic) {
                [formData appendPartWithFileData:[attachmentDic objectForKey:key] name:key fileName:[NSString stringWithFormat:@"%@.jpg", key] mimeType:@"image/jpeg"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            BaseDataItem *baseDataItem = [[BaseDataItem alloc] initWithDictionary:responseObject];
            if (baseDataItem.success) {
                success(baseDataItem.data);
            }
            else {
                failure(baseDataItem.message);
            }
            DLog(@"method = %s, url = %@, message = %@", __FUNCTION__, url, baseDataItem.message);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(ERROR_MESSAGE_1);
            DLog(@"method = %s, url = %@, error = %@", __FUNCTION__, url, error);
        }];
    }
    else {
        failure(ERROR_MESSAGE_1);
    }
}

+ (void)saveDeviceWithSuccess:(void(^)())success failure:(void(^)(NSString *message))failure {
    [self POST:SAVEDEVICE_URL parameters:@{@"device_push_id" : [UserSettingInfo fetchPushDeviceToken], @"device_type" : DEVICE_TYPE} success:^(id data) {
        success();
    } failure:failure];
}

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(void(^)(BOOL needBindVehicle))success failure:(void(^)(NSString *message))failure {
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = [self baseRequestParametersWithDictionary:@{@"login_id" : username, @"password" : password}];
        NSString *url = [self urlStringWithParameters:LOGIN_URL];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer setTimeoutInterval:sceonds];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            BaseDataItem *baseDataItem = [[BaseDataItem alloc] initWithDictionary:responseObject];
            if (baseDataItem.success) {
                BOOL needBindVehicle = [DataFetcher fetchAllVehicle:YES].count == 0 ? NO : YES;
                [UserSettingInfo setupLoginUsername:username password:password token:[baseDataItem.data objectForKey:@"access_token"]];
                success(needBindVehicle);
            }
            else {
                NSString *message = baseDataItem.message;
                if (baseDataItem.needAuth) {
                    [UserSettingInfo cleanupLoginInfo];
                    message = ERROR_MESSAGE_5;
                    [[NSNotificationCenter defaultCenter] postNotificationName:againNeedLoginKey object:nil];
                }
                failure(message);
            }
            DLog(@"method = %s, url = %@, message = %@", __FUNCTION__, url, baseDataItem.message);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(ERROR_MESSAGE_1);
            DLog(@"method = %s, url = %@, error = %@", __FUNCTION__, url, error);
        }];
    }
    else {
        failure(ERROR_MESSAGE_1);

    }
}

+ (void)sendRegisterCodeWithPhoneNumber:(NSString *)phoneNumber isRegister:(BOOL)isRegister success:(void(^)())success failure:(void(^)(NSString *message))failure {
    [self POST:SENDREGISTERCODE_URL parameters:@{@"mobile_number" : phoneNumber, @"purpose" : isRegister ? @"register" : @"find_password"} success:^(id data) {
        success();
    } failure:failure];
}

+ (void)registerWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password registerCode:(NSString *)registerCode success:(void(^)())success failure:(void(^)(NSString *message))failure {
    [self POST:REGISTER_URL parameters:@{@"login_id" : phoneNumber, @"password" : password, @"validate_code" : registerCode} success:^(id data) {
        success();
    } failure:failure];
}

+ (void)logoutWithSuccess:(void(^)())success failure:(void(^)(NSString *message))failure {
    [self POST:LOGOUT_URL parameters:nil success:^(id data) {
        [UserSettingInfo cleanupLoginInfo];
        success();
    } failure:failure];
}

+ (void)findPasswordWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password registerCode:(NSString *)registerCode success:(void(^)())success failure:(void(^)(NSString *message))failure {
    [self POST:FINDPASSWORD_URL parameters:@{@"login_id" : phoneNumber, @"password" : password, @"validate_code" : registerCode, @"confirm_password" : password} success:^(id data) {
        success();
    } failure:failure];
}

+ (void)saveVehicleWithVehicleItem:(VehicleItem *)vehicleItem update:(BOOL)update success:(void(^)())success failure:(void(^)(NSString *message))failure {
    [self saveVehicleWithVehicleItem:vehicleItem success:^{
        if (update) {
            [DataFetcher updateVehicleByVehicleItem:vehicleItem completion:^{
                success();
            }];
        }
        else {
            [DataFetcher addVehicleByVehicleItem:vehicleItem completion:^{
                success();
            }];
        }
    } failure:failure];
}

+ (void)saveVehicleWithVehicleItem:(VehicleItem *)vehicleItem success:(void(^)())success failure:(void(^)(NSString *message))failure {
    [self POST:SAVEVEHICLE_URL parameters:[vehicleItem convertModelToDictionary] success:^(id data) {
        success();
    } failure:failure];
}

+ (void)removeVehicleWithVehicleID:(NSString *)vehicleID success:(void(^)())success failure:(void(^)(NSString *message))failure {
    [self POST:DELETEVEHICLE_URL parameters:@{@"vehicle_id" : vehicleID} success:^(id data) {
        [DataFetcher removeVehicleByVehicelIDArray:@[vehicleID] completion:^{
            success();
        }];
    } failure:failure];
}

+ (void)fetchVehicleWithSuccess:(void(^)(NSArray *vehicleArray))success failure:(void(^)(NSString *message))failure {
    [self POST:GETVEHICLE_URL parameters:nil success:^(id data) {
        [DataFetcher importVehicleFromArray:data completion:^{
            success([DataFetcher fetchAllVehicle:YES]);
        }];
    } failure:failure];
}

+ (void)bindVehicleWithSuccess:(void(^)())success failure:(void(^)(NSString *message))failure {
    //[DataFetcher setupCoreDataStackWithStoreNamed:DEFAULT_DATABASE_NAME];
    
    NSArray *vehicleIDArray = [[DataFetcher fetchAllVehicle:YES] valueForKeyPath:@"vehicleID"];
    [self POST:BINDVEHICLE_URL parameters:@{@"vehicle_ids" : [vehicleIDArray componentsJoinedByString:@","]} success:^(id data) {
        NSArray *vehicleArray = [DataFetcher fetchAllVehicle:YES];
        NSMutableArray *vehicleItemArray = [NSMutableArray arrayWithCapacity:vehicleArray.count];
        for (Vehicle *vehicle in vehicleArray) {
            VehicleItem *vehicleItem = [VehicleItem convertVehicleToVehicleItem:vehicle];
            [vehicleItemArray addObject:vehicleItem];
        }
        [DataFetcher removeVehicleByVehicelIDArray:vehicleIDArray completion:^{
            [UserSettingInfo setupDatabase];
            __block NSInteger count = vehicleItemArray.count;
            for (VehicleItem *vehicleItem in vehicleItemArray) {
                [DataFetcher addVehicleByVehicleItem:vehicleItem completion:^{
                    count--;
                    if (count == 0) {
                        success();
                    }
                }];
            }
        }];
    } failure:failure];
}

+ (void)fetchViolationWithVehicleID:(NSString *)vehicleID success:(void(^)(NSArray *violationArray))success failure:(void(^)(NSString *message))failure {
    [self POST:GETVIOLATION_URL parameters:@{@"vehicle_ids" : vehicleID} success:^(id data) {
        [DataFetcher importViolationFromArray:data completion:^{
            success([DataFetcher fetchViolationByVehicleID:vehicleID ascending:NO]);
        }];
    } failure:failure];
}

+ (void)importAllViolationWithVehicleIDArray:(NSArray *)vehicleIDArray success:(void(^)())success failure:(void(^)(NSString *message))failure {
    [self POST:GETVIOLATION_URL parameters:@{@"vehicle_ids" : [vehicleIDArray componentsJoinedByString:@","]} success:^(id data) {
        [DataFetcher removeAllViolation:^{
            [DataFetcher importViolationFromArray:data completion:^{
                success();
            }];
        }];
    } failure:failure];
}

+ (void)downloadImageByImageArray:(NSArray *)imageArray success:(void(^)(NSDictionary *dictionary))success failure:(void(^)())failure {
    __block NSInteger count = imageArray.count;
    if (count > 0) {
        if ([CommonFunctionController checkNetworkWithNotify:NO]) {
            NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithCapacity:2];
            __block BOOL isSuccess = YES;
            for (NSString *url in imageArray) {
                @autoreleasepool {
                    ImageDownloader *imageDownloader = [[ImageDownloader alloc] init];
                    [imageDownloader downloadImageWithUrl:url success:^(UIImage *image) {
                        CGFloat scale = 0.5f;
                        if ([CommonFunctionController checkUrlValidate:url]) {
                            scale = 1.0f;
                        }
                        @autoreleasepool {
                            NSData *data = UIImageJPEGRepresentation(image, scale);
                            [dataDictionary setObject:data forKey:[[NSUUID UUID] UUIDString]];
                        }
                        count--;
                        if (count == 0) {
                            if (isSuccess) {
                                success(dataDictionary);
                            }
                            else {
                                failure();
                            }
                        }
                    } failure:^{
                        count--;
                        isSuccess = NO;
                        if (count == 0) {
                            failure();
                        }
                    }];
                }
            }
        }
        else {
            failure();
        }
    }
    else {
        success(@{});
    }
}

+ (void)commitAllUncommittedOilWithCompletion:(void(^)(BOOL isFinished))completion {
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        NSArray *oilArray = [DataFetcher fetchOilByOilSubmit:NO];
        __block NSInteger count = oilArray.count;
        if (count > 0) {
            __block BOOL isSuccess = YES;
            for (Oil *oil in oilArray) {
                OilItem *oilItem = [OilItem convertOilToOilItem:oil];
                [self downloadImageByImageArray:oilItem.attachmentList success:^(NSDictionary *dictionary) {
                    oilItem.attachmentList = [dictionary allKeys];
                    [self POST:SAVEOIL_URL parameters:[oilItem convertModelToDictionary] attachmentDic:dictionary success:^(id data) {
                        oilItem.isSubmit = [NSNumber numberWithBool:YES];
                        oilItem.dataType = [NSNumber numberWithInteger:OilDataTypeCommitted];
                        [DataFetcher updateOilByOilItem:oilItem completion:^{
                            count--;
                            if (count == 0) {
                                completion(isSuccess);
                            }
                        }];
                    } failure:^(NSString *message){
                        count--;
                        isSuccess = NO;
                        if (count == 0) {
                            completion(NO);
                        }
                    }];
                } failure:^{
                    count--;
                    isSuccess = NO;
                    if (count == 0) {
                        completion(NO);
                    }
                }];
            }
        }
        else {
            completion(YES);
        }
    }
    else {
        completion(NO);
    }
}

+ (void)saveOilWithOilItem:(OilItem *)oilItem update:(BOOL)update success:(void(^)())success failure:(void(^)(NSString *message))failure {
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        [self commitAllUncommittedOilWithCompletion:^(BOOL isFinished) {
            [self downloadImageByImageArray:oilItem.attachmentList success:^(NSDictionary *dictionary) {
                oilItem.attachmentList = [dictionary allKeys];
                [self POST:SAVEOIL_URL parameters:[oilItem convertModelToDictionary] attachmentDic:dictionary success:^(id data) {
                    oilItem.isSubmit = [NSNumber numberWithBool:YES];
                    if (update) {
                        [DataFetcher updateOilByOilItem:oilItem completion:^{
                            success();
                        }];
                    }
                    else {
                        [DataFetcher addOilByOilItem:oilItem completion:^{
                            success();
                        }];
                    }
                } failure:^(NSString *message){
                    failure(message);
                }];
            } failure:^{
                NSString *message = update ? @"更新失败！" : @"添加失败！";
                failure(message);
            }];
        }];
    }
    else {
        if (update) {
            [DataFetcher updateOilByOilItem:oilItem completion:^{
                success();
            }];
        }
        else {
            [DataFetcher addOilByOilItem:oilItem completion:^{
                success();
            }];
        }
    }
}

+ (void)fetchOilWithVehicleID:(NSString *)vehicleID success:(void(^)(NSArray *oilArray))success failure:(void(^)(NSString *message))failure {
    [self commitAllUncommittedOilWithCompletion:^(BOOL isFinished) {
        [self POST:GETOIL_URL parameters:@{@"vehicle_id" : vehicleID, @"last_update_time" : [DataFetcher fetchOilLastUpdateTimeByVehicleID:vehicleID]} success:^(id data) {
            [DataFetcher importOilFromArray:data vehicleID:vehicleID completion:^{
                success([DataFetcher fetchOilByVehicleID:vehicleID ascending:NO]);
            }];
        } failure:failure];
    }];
}

+ (void)removeOilWithOilID:(NSString *)oilID vehicleID:(NSString *)vehicleID success:(void(^)())success failure:(void(^)(NSString *message))failure {
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        [self POST:DELETEOIL_URL parameters:@{@"vehicle_id" : vehicleID, @"oil_id" : oilID} success:^(id data) {
            NSArray *attachmentList = [DataFetcher fetchOilByOilID:oilID].attachmentList;
            [DataFetcher removeOilByOilIDArray:@[oilID] completion:^{
                [ImageCache clearCacheWithKeyArray:attachmentList];
                success();
            }];
        } failure:failure];
    }
    else {
        Oil *oil = [DataFetcher fetchOilByOilID:oilID];
        if ([oil.dataType integerValue] != OilDataTypeAddUncommitted) {
            failure(@"请连接网络后再删除！");
        }
        else {
            NSArray *attachmentList = [DataFetcher fetchOilByOilID:oilID].attachmentList;
            [DataFetcher removeOilByOilIDArray:@[oilID] completion:^{
                [ImageCache clearCacheWithKeyArray:attachmentList];
                success();
            }];
        }
    }
}

+ (void)fetchOilTotalWithVehicleID:(NSString *)vehicleID success:(void(^)(OilTotal *oilTotal))success failure:(void(^)(NSString *message))failure {
    [self POST:GETOILTOTAL_URL parameters:@{@"vehicle_ids" : vehicleID} success:^(id data) {
        [DataFetcher importOilTotalFromArray:data completion:^{
            success([DataFetcher fetchOilTotalByVehicleID:vehicleID]);
        }];
    } failure:failure];
}

+ (void)importOilTotalWithVehicleIDArray:(NSArray *)vehicleIDArray success:(void(^)())success failure:(void(^)(NSString *message))failure {
    [self POST:GETOILTOTAL_URL parameters:@{@"vehicle_ids" : [vehicleIDArray componentsJoinedByString:@","]} success:^(id data) {
        [DataFetcher importOilTotalFromArray:data completion:^{
            success();
        }];
    } failure:failure];
}

+ (void)fetchTaskCountWithSuccess:(void(^)(NSDictionary *taskCountDictionary))success failure:(void(^)(NSString *message))failure {
    [self POST:GETTASK_URL parameters:@{@"last_update_time" : [DataFetcher fetchTaskLastUpdateTime]} success:^(id data) {
        [DataFetcher removeAllTask:^{
            [DataFetcher importTaskFromArray:data completion:^{
                NSDictionary *countDictionary = [DataFetcher fetchTaskCountDictionary];
                success(countDictionary);
            }];
        }];
    } failure:failure];
}

+ (void)confirmTaskByTaskID:(NSString *)taskID success:(void(^)())success failure:(void(^)(NSString *message))failure {
    Task *task = [DataFetcher fetchTaskByTaskID:taskID];
    NSString *operationType = @"1001";
    if ([task.status integerValue] == TaskStatusSpot) {
        operationType = @"1001";
    }
    else if ([task.status integerValue] == TaskStatusUnderWay) {
        operationType = @"1002";
    }
    [self POST:CONFIRMTASK_URL parameters:@{@"task_id" : taskID, @"operation_type" : operationType} success:^(id data) {
        [DataFetcher updateTaskStatusByTaskID:taskID status:[operationType integerValue] == 1001 ? TaskStatusUnderWay : TaskStatusFinished completion:^{
            success();
        }];
    } failure:failure];
}

+ (void)fetchTaskWithTaskID:(NSString *)taskID success:(void(^)(Task *task))success failure:(void(^)(NSString *message))failure {
    [self POST:GETTASKDETAIL_URL parameters:@{@"task_id" : taskID} success:^(id data) {
        if ([CommonFunctionController checkValueValidate:data] != nil) {
            data = @[data];
            [DataFetcher importTaskFromArray:data completion:^{
                success([DataFetcher fetchTaskByTaskID:taskID]);
            }];
        }
        else {
            failure(ERROR_MESSAGE_2);
        }
    } failure:failure];
}

+ (void)fetchOrgWithSuccess:(void(^)(NSArray *orgArray))success failure:(void(^)(NSString *message))failure {
    [self POST:GETORG_URL parameters:nil success:^(id data) {
        [DataFetcher importOrgFromArray:data completion:^{
            success([DataFetcher fetchAllOrg]);
        }];
    } failure:failure];
}

+ (void)fetchOrgMessageWithOrgID:(NSString *)orgID org_message_action:(NSString *)org_message_action lastMessageID:(NSString *)lastMessageID count:(NSInteger)count success:(void(^)(NSArray *orgMessageArray, BOOL isEnd))success failure:(void(^)(NSString *message))failure {
    [self POST:GETORGMESSAGE_URL parameters:@{@"last_message_id" : lastMessageID, @"request_message_number" : @(count).stringValue,@"org_message_action":org_message_action} success:^(id data) {
        BOOL isEnd = YES;
        if ([CommonFunctionController checkValueValidate:data] != nil) {
            isEnd = [[[(NSArray *)data firstObject] objectForKey:@"is_end"] isEqualToString:@"Y"];
        }
        if ([lastMessageID isEqualToString:@""]) {
            [DataFetcher removeAllOrgMessage:^{
                [DataFetcher importOrgMessageFromArray:data completion:^{
                    success([DataFetcher fetchOrgMessageByOrgID:orgID ascending:NO], isEnd);
                }];
            }];
        }
        else {
            [DataFetcher importOrgMessageFromArray:data completion:^{
                success([DataFetcher fetchOrgMessageByOrgID:orgID ascending:NO], isEnd);
            }];
        }
    } failure:failure];
}

+ (void)fetchOrgMessageWithOrgMessageID:(NSString *)orgMessageID success:(void(^)(OrgMessage *orgMessage))success failure:(void(^)(NSString *message))failure {
    [self POST:GETORGMESSAGEDETAIL_URL parameters:@{@"org_message_id" : orgMessageID} success:^(id data) {
        if ([CommonFunctionController checkValueValidate:data] != nil) {
            data = @[data];
            [DataFetcher importOrgMessageFromArray:data completion:^{
                success([DataFetcher fetchOrgMessageByOrgMessageID:orgMessageID]);
            }];
        }
        else {
            failure(ERROR_MESSAGE_2);
        }
    } failure:failure];
}

+ (void)joinOrgWithOrgID:(NSString *)orgID orgMessageID:(NSString *)orgMessageID action:(OrgAction)action messageType:(OrgMessageType)messageType success:(void(^)())success failure:(void(^)(NSString *message))failure {
    [self POST:HANDLEORGMESSAGE_URL parameters:@{@"org_id" : orgID, @"org_message_id" : orgMessageID, @"org_message_handle" : @(action).stringValue, @"org_message_type" : @(messageType).stringValue} success:^(id data) {
        [DataFetcher updateOrgMessageStatusByOrgMessageID:orgMessageID completion:^{
            success();
        }];
    } failure:failure];
}

+ (void)shieldOrgVehicleWithOrgID:(NSString *)orgID vehicleID:(NSString *)vehicleID action:(ShieldAction)action success:(void(^)())success failure:(void(^)(NSString *message))failure {
    [self POST:SHIELDVEHICLE_URL parameters:@{@"org_id" : orgID, @"vehicle_id" : vehicleID, @"operation_type" : @(action).stringValue} success:^(id data) {
        if (action == ShieldActionConfirm) {
            [DataFetcher removeVehicleIDToOrgByOrgID:orgID vehicleID:vehicleID completion:^{
                success();
            }];
        }
        else {
            [DataFetcher addVehicleIDToOrgByOrgID:orgID vehicleID:vehicleID completion:^{
                success();
            }];
        }
    } failure:failure];
}

+ (void)submitFeedbackByContent:(NSString *)content success:(void(^)())success failure:(void(^)(NSString *message))failure {
    [self POST:SUBMITFEEDBACK_URL parameters:@{@"feedback_content" : content} success:^(id data) {
        success();
    } failure:failure];
}

+ (void)checkVersionBySuccess:(void(^)(NSString *url))success failure:(void(^)(NSString *message))failure {
    [self POST:CHECKVERSION_URL parameters:@{@"app_version" : [UserSettingInfo fetchAppVersion], @"device_type" : DEVICE_TYPE} success:^(id data) {
        if ([CommonFunctionController checkValueValidate:data] != nil) {
            if ([data objectForKey:@"version_number"] != nil) {
                [UserSettingInfo saveAppLastestVersion:[data objectForKey:@"version_number"]];
                success([data objectForKey:@"version_address"]);
            }
            else {
                failure(ERROR_MESSAGE_3);
            }
        }
        else {
            failure(ERROR_MESSAGE_2);
        }
    } failure:failure];
}

+ (void)outOrgByOrgID:(NSString *)orgID success:(void(^)())success failure:(void(^)(NSString *message))failure {
    [self POST:OUTORG_URL parameters:@{@"org_id" : orgID} success:^(id data) {
        [DataFetcher removeOrgByOrgID:orgID completion:^{
            success();
        }];
    } failure:failure];
}

+ (void)fetchOrgByOrgInfo:(NSString *)orgInfo success:(void(^)(NSArray *orgItemArray))success failure:(void(^)(NSString *message))failure {
    [self POST:SEARCHORG_URL parameters:@{@"org_show_no" : orgInfo} success:^(id data) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:2];
        for (NSDictionary *dataDic in data) {
            OrgItem *orgItem = [[OrgItem alloc] init];
            orgItem.name = [dataDic objectForKey:@"org_name"];
            orgItem.orgID = [dataDic objectForKey:@"org_id"];
            orgItem.number = [dataDic objectForKey:@"org_show_no"];
            orgItem.orgDescription = [dataDic objectForKey:@"org_description"];
            [dataArray addObject:orgItem];
        }
        success(dataArray);
    } failure:failure];
}

+ (void)applyOrgWithOrgID:(NSString *)orgID username:(NSString *)username success:(void (^)())success failure:(void (^)(NSString *message))failure {
    [self POST:APPLYORG_URL parameters:@{@"org_id" : orgID, @"user_name" : username} success:^(id data) {
        success();
    } failure:failure];
}

+ (void)cancelOrgApplyingWithOrgID:(NSString *)orgID success:(void (^)())success failure:(void (^)(NSString *message))failure {
    [self POST:CANCELAPPLYORG_URL parameters:@{@"org_id" : orgID} success:^(id data) {
        success();
    } failure:failure];
}

+ (void)createOrgWithOrgName:(NSString *)orgName success:(void (^)())success failure:(void (^)(NSString *message))failure {
    [self POST:CREATEORG_URL parameters:@{@"org_name" : orgName} success:^(id data) {
        success();
    } failure:failure];
}

+ (void)dissolveOrgWithOrgID:(NSString *)orgID success:(void (^)())success failure:(void (^)(NSString *message))failure {
    [self POST:DISSOLVEORG_URL parameters:@{@"org_id" : orgID} success:^(id data) {
        success();
    } failure:failure];
}

+ (void)getOrgAllUser:(NSString *)ordID success:(void (^)(NSDictionary *dictionary))success failure:(void (^)(NSString *message))failure
{
    [self POST:GetOrgAllUsers parameters:@{@"org_id" : ordID} success:^(id data) {
        success(data);
    } failure:failure];
}

+ (void)postNotification:(NSString *)receiver_id org_id:(NSString *)org_id message_title:(NSString *)message_title message_content:(NSString *)message_content success:(void (^)(NSDictionary *dictionary))success failure:(void (^)(NSString *message))failure
{
    [self POST:POSTNOTIFICATION parameters:@{@"receiver_id" : receiver_id, @"org_id" : org_id, @"message_title" : message_title, @"message_content" : message_content} success:^(id data) {
        success(data);
    } failure:failure];

}

+ (void)saveVehicleDailyMile:(NSString *)mileage org_id:(NSString *)org_id vehicle_id:(NSString *)vehicle_id position:(NSString *)position success:(void (^)(NSDictionary *dictionary))success failure:(void (^)(NSString *message))failure
{
    [self POST:SAVEVEHICLEMILEAGE parameters:@{@"mileage" : mileage, @"org_id" : org_id, @"vehicle_id" : vehicle_id, @"position" : position} success:^(id data) {
        success(data);
    } failure:failure];
}

+ (void)fetchVehicleMonthList:(NSString *)vehicle_ids month:(NSString *)month org_id:(NSString *)org_id success:(void (^)(NSDictionary *dictionary))success failure:(void (^)(NSString *message))failure
{
    [self POST:GETVEHICLEMONTHLIST parameters:@{@"vehicle_ids" : vehicle_ids, @"month" : month, @"org_id" : org_id} success:^(id data) {
        success(data);
    } failure:failure];

}

+ (void)fetchVehicleDrivingLicense:(NSString *)vehicle_ids success:(void (^)())success failure:(void (^)(NSString *message))failure
{
    [self POST:GETVEHICLEDRIVINGLICENSE parameters:@{@"vehicle_ids" : vehicle_ids} success:^(id data){
        success(data);
    }failure:failure];
}

+ (void)saveVehicleDrivingLicense:(NSString *)vehicle_id imageArray:(NSArray *)imageArray success:(void (^)())success failure:(void (^)(NSString *message))failure
{
    if ([CommonFunctionController checkNetworkWithNotify:NO]) {
        [self downloadImageByImageArray:imageArray success:^(NSDictionary *dictionary) {
            [self POST:SAVEVEHICLEDRIVINGLICENSE parameters:@{@"vehicle_id" : vehicle_id
            } attachmentDic:dictionary success:^(id data) {
                success(data);
            } failure:^(NSString *message){
                failure(message);
            }];
        } failure:^{
            
        }];

    }

}

@end
