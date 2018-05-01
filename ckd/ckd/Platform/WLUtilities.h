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

@end
