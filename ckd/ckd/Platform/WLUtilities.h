//
//  WLUtilities.h
//  ckd
//
//  Created by 王磊 on 2018/4/30.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLUtilities : NSObject

+ (BOOL)isUserLogin;
+ (void)setUserLogin;
+ (BOOL)isUserRealNameRegist;
+ (void)setUserNameRegist;
+ (BOOL)isUserDepositPaid;
+ (void)setUserDepositPaid;

+(void)saveUserID: (NSString *)user_id;
+ (NSString *)getUserID;
+(void)saveCurrentCityCode: (NSString *)cityCode andCityName: (NSString *)cityName;
+(NSString *)getCurrentCityCode;
+(NSString *)getCurrentCityName;

+(void)savuserName: (NSString *)user_name;
+ (NSString *)getUserName;

+ (NSString *)getNowTimeTimestamp;


+ (BOOL)isIphoneX;

@end
