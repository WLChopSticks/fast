//
//  WLChargerRecord.m
//  ckd
//
//  Created by wanglei on 2018/5/3.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLChargerRecord.h"
#import <MJExtension.h>

@implementation WLChargerRecordListModel

@end

@implementation WLChargerRecord

+(instancetype)getChargerRecordModel:(NSDictionary *)dict
{
    WLChargerRecord *model = [[WLChargerRecord alloc]init];
    model = [WLChargerRecord mj_objectWithKeyValues:dict];
    model.data = [WLChargerRecordListModel mj_objectArrayWithKeyValuesArray:(NSArray *)dict[@"data"][@"list"]];
    return model;
}

@end
