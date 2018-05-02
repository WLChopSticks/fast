//
//  WLEachChargerStationModel.m
//  ckd
//
//  Created by wanglei on 2018/5/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLEachChargerStationModel.h"
#import <MJExtension.h>

@implementation WLEachChargerStationInfoModel
@end

@implementation WLEachChargerStationModel

-(instancetype)getEachChargerStationModel:(NSDictionary *)dict
{
    WLEachChargerStationModel *model = [[WLEachChargerStationModel alloc]init];
    [WLEachChargerStationModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"data":@"data.list"
                 };
    }];
    model = [WLEachChargerStationModel mj_objectWithKeyValues:dict];
    model.data = [WLEachChargerStationInfoModel mj_objectArrayWithKeyValuesArray:(NSArray *)dict[@"data"][@"list"]];
    return model;
}

@end
