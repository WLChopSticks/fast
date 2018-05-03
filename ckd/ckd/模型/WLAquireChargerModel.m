//
//  WLAquireChargerModel.m
//  ckd
//
//  Created by wanglei on 2018/5/3.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLAquireChargerModel.h"
#import <MJExtension.h>

@implementation WLAquireChargerInfoModel

@end

@implementation WLAquireChargerModel

+(instancetype)getAquireChargerModel:(NSDictionary *)dict
{
    WLAquireChargerModel *model = [[WLAquireChargerModel alloc]init];
    model = [WLAquireChargerModel mj_objectWithKeyValues:dict];
    return model;
}

@end




