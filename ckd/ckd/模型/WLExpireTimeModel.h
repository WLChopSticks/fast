//
//  WLExpireTimeModel.h
//  ckd
//
//  Created by wanglei on 2018/5/3.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLIDepositStatusInfoModel : NSObject

@property (nonatomic, strong) NSString *thzt;///退还状态
@property (nonatomic, strong) NSString *user_id;///用户id
@property (nonatomic, strong) NSString *thje;///退还金额
@property (nonatomic, strong) NSString *thsj;///退还时间

@end

@interface WLExpireTimeModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *message;

+ (instancetype)getExpireTimeModel: (NSDictionary *)dict;
@end


