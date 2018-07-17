//
//  WLRentMotorRecordModel.m
//  ckd
//
//  Created by wanglei on 2018/7/17.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLRentMotorRecordModel.h"
#import <MJExtension.h>

@implementation WLRentMotorRecordDetailModel

@end

@implementation WLRentMotorRecordModel

+(instancetype)getRentModelRecordModel:(NSDictionary *)dict
{
    WLRentMotorRecordModel *model = [[WLRentMotorRecordModel alloc]init];
    model = [WLRentMotorRecordModel mj_objectWithKeyValues:dict];
    model.data = [WLRentMotorRecordDetailModel mj_objectArrayWithKeyValuesArray:(NSArray *)dict[@"data"][@"list"]];
    return model;
}

@end
