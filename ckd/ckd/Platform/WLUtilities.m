//
//  WLUtilities.m
//  ckd
//
//  Created by 王磊 on 2018/4/30.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLUtilities.h"
#import <sys/sysctl.h>

@implementation WLUtilities

+ (BOOL)isUserLogin
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [[def objectForKey:@"loginStatus"]boolValue];
}

+ (void)setUserLogin
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[NSNumber numberWithBool:YES] forKey:@"loginStatus"];
}

+ (void)setUserLogout
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:@"loginStatus"];
    [def removeObjectForKey:@"realNameRegist"];
    [def removeObjectForKey:@"depositPaid"];
    [def removeObjectForKey:@"user_id"];
    [def removeObjectForKey:@"user_name"];
    [def removeObjectForKey:@"city_code"];
    [def removeObjectForKey:@"city_name"];
}

+ (BOOL)isUserRealNameRegist
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [[def objectForKey:@"realNameRegist"]boolValue];
}
+ (void)setUserNameRegist
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[NSNumber numberWithBool:YES] forKey:@"realNameRegist"];
}

+ (BOOL)isUserDepositPaid
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [[def objectForKey:@"depositPaid"]boolValue];
}

+ (void)setUserDepositPaid
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[NSNumber numberWithBool:YES] forKey:@"depositPaid"];
}

+ (BOOL)isUserRentPaid
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [[def objectForKey:@"rent"]boolValue];
}

+ (void)setUserRentPaid
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[NSNumber numberWithBool:YES] forKey:@"rent"];
}

+ (void)saveUserID: (NSString *)user_id
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:user_id forKey:@"user_id"];
}

+ (NSString *)getUserID
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"user_id"];
//    return @"80a66d8a8cc44d36b0cf54ca01708aae";
}

+ (void)savuserName:(NSString *)user_name
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:user_name forKey:@"user_name"];
}

+ (NSString *)getUserName
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"user_name"];
}

+ (void)saveCurrentCityCode:(NSString *)cityCode andCityName:(NSString *)cityName
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:cityCode forKey:@"city_code"];
    [def setObject:cityName forKey:@"city_name"];
}

+ (NSString *)getCurrentCityCode
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"city_code"];
}

+ (NSString *)getCurrentCityName
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"city_name"];
}

+ (BOOL)isIphoneX
{
    NSString *platform = [WLUtilities getCurrentDeviceModelDescription];
    if ([platform isEqualToString:@"iPhone10,3"])    return YES;
    if ([platform isEqualToString:@"iPhone10,6"])    return YES;
    return NO;
}

+ (NSString *)getCurrentDeviceModelDescription{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

+ (void)savePaidPrice:(NSString *)price
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:price forKey:@"paid_Price"];
}

+ (NSString *)getPaidPrice
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"paid_Price"];
}

+(void)deletePaidPrice
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:@"paid_Price"];
}

@end
