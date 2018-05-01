//
//  WLChargerStationModel.m
//  ckd
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLChargerStationModel.h"

@implementation WLCityData
@end


@implementation WLChargerStationModel

-(instancetype)getChargerStationModel:(NSDictionary *)dict
{
    WLChargerStationModel *model = [[WLChargerStationModel alloc]init];    
    model = [WLChargerStationModel mj_objectWithKeyValues:dict];
    model.data = [WLCityData mj_objectArrayWithKeyValuesArray:(NSArray *)dict[@"data"][@"list"]];
    return model;
}



@end
