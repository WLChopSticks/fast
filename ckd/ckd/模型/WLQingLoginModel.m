//
//  WLQingLoginModel.m
//  ckd
//
//  Created by 王磊 on 2018/5/5.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLQingLoginModel.h"
#import <MJExtension.h>

@implementation WLUserExpireTimeModel

@end

@implementation WLUserPaidListModel

@end

@implementation WLUserInfoModel

@end

@implementation WLQingLoginModel

+(instancetype)getQingLoginModel:(NSDictionary *)dict
{    
    WLQingLoginModel *model = [[WLQingLoginModel alloc]init];
    model = [WLQingLoginModel mj_objectWithKeyValues:dict];
    model.data.list = [WLUserExpireTimeModel mj_objectArrayWithKeyValuesArray:(NSArray *)dict[@"data"][@"list"]];
    model.data.list1 = [WLUserPaidListModel mj_objectArrayWithKeyValuesArray:(NSArray *)dict[@"data"][@"list1"]];
    return model;
}

@end
