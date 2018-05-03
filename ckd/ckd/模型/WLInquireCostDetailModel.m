//
//  WLInquireCostDetailModel.m
//  ckd
//
//  Created by wanglei on 2018/5/3.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLInquireCostDetailModel.h"
#import <MJExtension.h>

@implementation WLInquireCostDetailInfoModel
@end

@implementation WLInquireCostDetailModel

+(instancetype)getInquireCostDetailModel:(NSDictionary *)dict
{
    WLInquireCostDetailModel *model = [[WLInquireCostDetailModel alloc]init];
    model = [WLInquireCostDetailModel mj_objectWithKeyValues:dict];
    if (![[dict objectForKey:@"data"] isEqual:[NSNull null]])
    {
        model.data = [WLInquireCostDetailInfoModel mj_objectArrayWithKeyValuesArray:(NSArray *)dict[@"data"][@"list"]];
    }

    return model;
}

@end
