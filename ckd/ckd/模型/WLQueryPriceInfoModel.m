//
//  WLQueryPriceInfoModel.m
//  ckd
//
//  Created by 王磊 on 2018/5/7.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLQueryPriceInfoModel.h"
#import <MJExtension.h>

@implementation WLQueryPriceInfoDetailModel
@end

@implementation WLQueryPriceInfoModel

+(instancetype)getQueryPriceInfoModel:(NSDictionary *)dict
{
    WLQueryPriceInfoModel *model = [[WLQueryPriceInfoModel alloc]init];
    model = [WLQueryPriceInfoModel mj_objectWithKeyValues:dict];
    
    return model;
}

@end

