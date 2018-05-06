//
//  WLQingLoginModel.h
//  ckd
//
//  Created by 王磊 on 2018/5/5.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLUserInfoModel : NSObject

@property (nonatomic, strong) NSString *user_id;//用户id
@property (nonatomic, strong) NSString *user_realname;//用户真实姓名
@property (nonatomic, strong) NSString *user_phone;//用户电话
@property (nonatomic, strong) NSString *idcard;//身份证
@property (nonatomic, strong) NSString *area_id;//城市id
@property (nonatomic, strong) NSString *ztm;//状态码（0判断未认证，1认证通过）
@property (nonatomic, strong) NSString *ddczj;//电动车押金（0未交，1已交）
@property (nonatomic, strong) NSString *ddcyj;//电动车押金（0未交，1已交）
@property (nonatomic, strong) NSString *zj;//电池租金（0未交，1已交）
@property (nonatomic, strong) NSString *yj;//电池押金（0未交，1已交）
@property (nonatomic, strong) NSString *list;//到期时间list （fylb 0电动车 1电池）
@property (nonatomic, strong) NSString *dcdm;//电池代码
@property (nonatomic, strong) NSString *csmc;//城市名称
@property (nonatomic, strong) NSString *list1;//费用金额list
/*
 费用金额  费用详情代码 费用类型代码，费用金额
 */

@end

@interface WLQingLoginModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) WLUserInfoModel *data;
@property (nonatomic, strong) NSString *message;

+ (instancetype)getQingLoginModel: (NSDictionary *)dict;

@end
