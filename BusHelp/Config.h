//
//  Config.h
//  BusQuery
//
//  Created by Tony Zeng on 6/3/14.
//  Copyright (c) 2014 Tony. All rights reserved.
//

#define DEFAULT_DATABASE_NAME @"BusHelp"
#define DEFAULT_UPDATE_TIME @"2015-01-01 00:00:00"
#define HMACSHA1KEY @"0CA7E941169DFA698D4548853EE0A199"

#define SINA_WEIBO_APPKEY @"4036904327"
#define SINA_WEIBO_APPSECRET @"fd8ac38d0675d06423333c216914428e"
#define TENCENT_WEIBO_APPKEY @"801518252"
#define TENCENT_WEIBO_APPSECRET @"95119c4569a6e47c5c0798d83720ad97"
#define WX_APPID @"wxafac63ac857881bf"
#define WX_APPSECRET @"47994dd6fa6d4ab1985db9d494703003"
#define SHARE_SDK_KEY @"21ea5e44a0e0"
#define SHARE_REDIRECT_URL @"http://ygc.g-bos.cn"
#define SHARE_TITLE @"易管车"
#define SHARE_CONTENT @"//走过春夏秋冬安全永驻心中"
#define DEVICE_TYPE @"1001"

//#define BASE_URL @"http://ygcapi.g-bos.cn:7702"//@"http://ptpws-pre.g-bos.cn:71"//@"http://172.16.21.141:9000"@"http://192.168.200.179:9000"

#define BASE_URL @"http://ptpws-pre.g-bos.cn:71"
#define LOGIN_URL [BASE_URL stringByAppendingString:@"/api/user/login"]
#define REGISTER_URL [BASE_URL stringByAppendingString:@"/api/user/register"]
#define LOGOUT_URL [BASE_URL stringByAppendingString:@"/api/user/logout"]
#define FINDPASSWORD_URL [BASE_URL stringByAppendingString:@"/api/user/find_password"]
#define SAVEDEVICE_URL [BASE_URL stringByAppendingString:@"/api/device/save"]
#define SENDREGISTERCODE_URL [BASE_URL stringByAppendingString:@"/api/smsvalidatecode/send"]
#define SAVEVEHICLE_URL [BASE_URL stringByAppendingString:@"/api/vehicle/save"]
#define DELETEVEHICLE_URL [BASE_URL stringByAppendingString:@"/api/vehicle/delete"]
#define GETVEHICLE_URL [BASE_URL stringByAppendingString:@"/api/vehicle/list"]
#define BINDVEHICLE_URL [BASE_URL stringByAppendingString:@"/api/vehicle/bind"]
#define GETVIOLATION_URL [BASE_URL stringByAppendingString:@"/api/violation/list"]
#define SAVEOIL_URL [BASE_URL stringByAppendingString:@"/api/oil/saveoil"]
#define GETOIL_URL [BASE_URL stringByAppendingString:@"/api/oil/getoillist"]
#define DELETEOIL_URL [BASE_URL stringByAppendingString:@"/api/oil/deleteoil"]
#define GETOILTOTAL_URL [BASE_URL stringByAppendingString:@"/api/oil/getoiltotallist"]
#define GETTASK_URL [BASE_URL stringByAppendingString:@"/api/task/gettasklist"]
#define CONFIRMTASK_URL [BASE_URL stringByAppendingString:@"/api/task/confirmtask"]
#define GETORG_URL [BASE_URL stringByAppendingString:@"/api/org/getorglist"]
#define GETORGMESSAGE_URL [BASE_URL stringByAppendingString:@"/api/org/getorgmessagelist"]
#define HANDLEORGMESSAGE_URL [BASE_URL stringByAppendingString:@"/api/org/handleorgmessage"]
#define SHIELDVEHICLE_URL [BASE_URL stringByAppendingString:@"/api/org/closeorgvehicle"]
#define SUBMITFEEDBACK_URL [BASE_URL stringByAppendingString:@"/api/system/savefeedback"]
#define CHECKVERSION_URL [BASE_URL stringByAppendingString:@"/api/system/checkversion"]
#define OUTORG_URL [BASE_URL stringByAppendingString:@"/api/org/out"]
#define SEARCHORG_URL [BASE_URL stringByAppendingString:@"/api/org/getorgbyno"]
#define APPLYORG_URL [BASE_URL stringByAppendingString:@"/api/org/apply"]
#define CANCELAPPLYORG_URL [BASE_URL stringByAppendingString:@"/api/org/cancel"]
#define GETORGMESSAGEDETAIL_URL [BASE_URL stringByAppendingString:@"/api/org/getorgmessage"]
#define GETTASKDETAIL_URL [BASE_URL stringByAppendingString:@"/api/task/gettask"]

#define CREATEORG_URL [BASE_URL stringByAppendingString:@"/api/org/create"]
#define DISSOLVEORG_URL [BASE_URL stringByAppendingString:@"/api/org/dissolve"]
#define GetOrgAllUsers [BASE_URL stringByAppendingString:@"/api/user/list"]
#define POSTNOTIFICATION [BASE_URL stringByAppendingString:@"/api/org/sendmessage"]
#define SAVEVEHICLEMILEAGE [BASE_URL stringByAppendingString:@"/api/mil/savedailymileage"]
#define GETVEHICLEMONTHLIST [BASE_URL stringByAppendingString:@"/api/mil/getmonthmillist"]
#define GETVEHICLEDRIVINGLICENSE [BASE_URL stringByAppendingString:@"/api/vehicle/getdrivinglicense"]
#define SAVEVEHICLEDRIVINGLICENSE [BASE_URL stringByAppendingString:@"/api/vehicle/savedrivinglicense"]

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define DOCUMENT_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define LIBRARY_PATH NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0]
#define CACHE_PATH NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
#define USERINFOADD(x, y) [[NSUserDefaults standardUserDefaults] setObject:x forKey:y], [[NSUserDefaults standardUserDefaults] synchronize]
#define USERINFOFIND(x) [[NSUserDefaults standardUserDefaults] objectForKey:x]
#define USERINFOREMOVE(x) [[NSUserDefaults standardUserDefaults] removeObjectForKey:x]

#define ERROR_MESSAGE_1 @"网络连接不稳定！"
#define ERROR_MESSAGE_2 @"返回值为null！"
#define ERROR_MESSAGE_3 @"参数不存在！"
#define ERROR_MESSAGE_4 @"该用户未加入公司或团队！"
#define ERROR_MESSAGE_5 @"请重新登录！"
#define MAX_MESSAGE_LENGTH 15

#define MESSAGE_1 @"载入中..."

#ifdef DEBUG
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...) /* */
#endif
#define ALog(...) NSLog(__VA_ARGS__)

#pragma mark - Singleton

#define LCSINGLETON_IN_H(classname) \
+ (id)sharedInstance;

#define LCSINGLETON_IN_M(classname) \
\
__strong static id _shared##classname = nil; \
\
+ (id)sharedInstance { \
@synchronized(self) \
{ \
if (_shared##classname == nil) \
{ \
_shared##classname = [[super allocWithZone:NULL] init]; \
} \
} \
return _shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
return [self sharedInstance]; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}
