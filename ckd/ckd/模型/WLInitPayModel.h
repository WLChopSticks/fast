//
//  WLInitPayModel.h
//  ckd
//
//  Created by wanglei on 2018/5/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLPlatform.h"

@interface WLInitPayParametersModel : NSObject

@property (nonatomic, strong) NSString *appid;///公众账号id
@property (nonatomic, strong) NSString *trade_type;///交易类型
@property (nonatomic, strong) NSString *prepay_id;///商户id
@property (nonatomic, strong) NSString *nonce_str;///随机字符串
@property (nonatomic, strong) NSString *mch_id;///商户号
@property (nonatomic, strong) NSString *sign;//签名
@property (nonatomic, strong) NSString *responseString;//微信支付返回
@property (nonatomic, strong) NSString *api_key;//App需要
@property (nonatomic, strong) NSString *out_trade_no;


@end

@interface WLInitPayModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) WLInitPayParametersModel *data;
@property (nonatomic, strong) NSString *message;

+ (instancetype)getInitPayModel: (NSDictionary *)dict;
@end
