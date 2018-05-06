//
//  WLPaidRecordModel.h
//  ckd
//
//  Created by 王磊 on 2018/5/6.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLPaidRecordDetailModel : NSObject

@property (nonatomic, strong) NSString *user_id;//用户id
@property (nonatomic, strong) NSString *orderid;//订单号
@property (nonatomic, strong) NSString *fxqmc;//费用详情名称
@property (nonatomic, strong) NSString *fyje;//费用金额
@property (nonatomic, strong) NSString *jfsj;//缴费时间

@end

@interface WLPaidRecordModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *message;

+ (instancetype)getPaidRecordModel: (NSDictionary *)dict;

@end
