//
//  WLUserInfoMaintainance.h
//  ckd
//
//  Created by 王磊 on 2018/5/6.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLQingLoginModel.h"

@interface WLUserInfoMaintainance : NSObject

@property (nonatomic, strong) WLQingLoginModel *model;

+ (instancetype)sharedMaintain;

//获取用户信息
- (void)queryUserInfo:(void(^)(NSNumber *result))complete;

@end
