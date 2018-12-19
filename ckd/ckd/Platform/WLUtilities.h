//
//  WLUtilities.h
//  ckd
//
//  Created by 王磊 on 2018/4/30.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLUtilities : NSObject

//用户登录状态
+ (BOOL)isUserLogin;
+ (void)setUserLogin;
+ (void)setUserLogout;
//用户实名注册状态
+ (BOOL)isUserRealNameRegist;
+ (void)setUserNameRegist;
//用户支付押金状态
+ (BOOL)isUserDepositPaid;
+ (void)setUserDepositPaid;
//用户支付租金状态
+ (BOOL)isUserRentPaid;
+ (void)setUserRentPaid;
//user_id
+(void)saveUserID: (NSString *)user_id;
+ (NSString *)getUserID;
//用户选择的城市名称以及城市代码
+(void)saveCurrentCityCode: (NSString *)cityCode andCityName: (NSString *)cityName;
+(NSString *)getCurrentCityCode;
+(NSString *)getCurrentCityName;
//用户名称
+(void)savuserName: (NSString *)user_name;
+ (NSString *)getUserName;

//个推ClientId
+ (void)savePushNotificationClientId:(NSString *)clientId;
+ (NSString *)getPushNotificationClientId;

//判断是否为iPhone X
+ (BOOL)isIphoneX;

//存储缴费金额
+ (void)savePaidPrice: (NSString *)price;
+ (NSString *)getPaidPrice;
+ (void)deletePaidPrice;//每次请求新的金额前都需要删除存储的金额

//是否支持电动车
+ (BOOL)isSupportMotor;

@end
