//
//  WLDepositStatusModel.m
//  ckd
//
//  Created by wanglei on 2018/5/3.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLDepositStatusModel.h"
#import <MJExtension.h>

@implementation WLIDepositStatusInfoModel
@end

@implementation WLDepositStatusModel

+(instancetype)getDepositStatusModel:(NSDictionary *)dict
{
    WLDepositStatusModel *model = [[WLDepositStatusModel alloc]init];
    model = [WLDepositStatusModel mj_objectWithKeyValues:dict];
    
    return model;
}

@end

