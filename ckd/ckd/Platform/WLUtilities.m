//
//  WLUtilities.m
//  ckd
//
//  Created by 王磊 on 2018/4/30.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLUtilities.h"

@implementation WLUtilities

+ (BOOL)isUserLogin
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [[def objectForKey:@"loginStatus"]boolValue];
}

+(void)setUserLogin
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[NSNumber numberWithBool:YES] forKey:@"loginStatus"];
}

+  (BOOL)isUserRealNameRegist
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [[def objectForKey:@"realNameRegist"]boolValue];
}
+(void)setUserNameRegist
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[NSNumber numberWithBool:YES] forKey:@"realNameRegist"];
}

+(BOOL)isUserDepositPaid
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [[def objectForKey:@"depositPaid"]boolValue];
}

+(void)setUserDepositPaid
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[NSNumber numberWithBool:YES] forKey:@"depositPaid"];
}



+(void)saveUserID: (NSString *)user_id
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:user_id forKey:@"user_id"];
}

+(NSString *)getUserID
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"user_id"];
}

+(NSString *)getNowTimeTimestamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

@end
