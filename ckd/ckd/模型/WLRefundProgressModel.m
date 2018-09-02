//
//  WLRefundProgressModel.m
//  ckd
//
//  Created by 王磊 on 2018/9/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLRefundProgressModel.h"
#import <MJExtension.h>

@implementation WLRefundProgressDetailModel
@end

@implementation WLRefundProgressModel
+(instancetype)getRefundProgressModel:(NSDictionary *)dict
{
    WLRefundProgressModel *model = [[WLRefundProgressModel alloc]init];
    model = [WLRefundProgressModel mj_objectWithKeyValues:dict];
    model.data = [WLRefundProgressDetailModel mj_objectArrayWithKeyValuesArray:(NSArray *)dict[@"data"][@"list"]];
    return model;
}
@end
