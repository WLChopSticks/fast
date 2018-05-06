//
//  WLPaidRecordModel.m
//  ckd
//
//  Created by 王磊 on 2018/5/6.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLPaidRecordModel.h"
#import <MJExtension.h>

@implementation WLPaidRecordDetailModel
@end

@implementation WLPaidRecordModel

+(instancetype)getPaidRecordModel:(NSDictionary *)dict
{
    WLPaidRecordModel *model = [[WLPaidRecordModel alloc]init];
    model = [WLPaidRecordModel mj_objectWithKeyValues:dict];
    if (![[dict objectForKey:@"data"] isEqual:[NSNull null]])
    {
        model.data = [WLPaidRecordDetailModel mj_objectArrayWithKeyValuesArray:(NSArray *)dict[@"data"][@"list"]];
    }
    
    return model;
}

@end

