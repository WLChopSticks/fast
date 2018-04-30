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

@end
