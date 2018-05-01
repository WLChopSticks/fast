//
//  WLQuickLoginModel.h
//  ckd
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLDataModel : NSObject

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_realname;
@property (nonatomic, strong) NSString *user_phone;
@property (nonatomic, strong) NSString *idcard;
@property (nonatomic, strong) NSString *area_id;
@property (nonatomic, strong) NSString *ztm;
@property (nonatomic, strong) NSString *ddczj;
@property (nonatomic, strong) NSString *ddcyj;
@property (nonatomic, strong) NSString *zj;
@property (nonatomic, strong) NSString *yj;

@end

@interface WLQuickLoginModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) WLDataModel *data;
@property (nonatomic, strong) NSString *message;

+ (instancetype)getQuickLoginModel: (NSDictionary *)dict;

@end


