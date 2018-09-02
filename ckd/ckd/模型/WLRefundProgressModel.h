//
//  WLRefundProgressModel.h
//  ckd
//
//  Created by 王磊 on 2018/9/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLRefundProgressDetailModel : NSObject

@property (nonatomic, strong) NSString *thzt;
//退还状态（0已申请，1已退还，2运营人员审核通过，3财务人员审核通过，4未通过审核）2、3状态审核中
@property (nonatomic, strong) NSString *dqzt;//当前状态  （1当前状态）
@property (nonatomic, strong) NSString *thje;//总金额
@property (nonatomic, strong) NSString *thsj;//退还时间
@end

@interface WLRefundProgressModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *message;

+ (instancetype)getRefundProgressModel: (NSDictionary *)dict;

@end
