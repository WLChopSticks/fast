//
//  WLInquireCostDetailModel.h
//  ckd
//
//  Created by wanglei on 2018/5/3.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLInquireCostDetailInfoModel : NSObject

@property (nonatomic, strong) NSString *fyxqdm;///费用详情代码
@property (nonatomic, strong) NSString *lsh;///流水号
@property (nonatomic, strong) NSString *fylb;///费用类别
@property (nonatomic, strong) NSString *fylxdm;///费用类型代码
@property (nonatomic, strong) NSString *fyxqmc;///费用详情名称
@property (nonatomic, strong) NSString *csdm;///城市代码
@property (nonatomic, strong) NSString *fyje;///费用金额

@end

@interface WLInquireCostDetailModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *message;

+ (instancetype)getInquireCostDetailModel: (NSDictionary *)dict;
@end


