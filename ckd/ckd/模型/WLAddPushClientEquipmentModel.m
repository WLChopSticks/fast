//
//  WLAddPushClientEquipmentModel.m
//  ckd
//
//  Created by 王磊 on 2018/12/16.
//  Copyright © 2018 wanglei. All rights reserved.
//

#import "WLAddPushClientEquipmentModel.h"
#import <MJExtension.h>

@implementation WLPushDataModel

@end

@implementation WLAddPushClientEquipmentModel

+ (instancetype)getAddPushClientEquipmentModel: (NSDictionary *)dict
{
    WLAddPushClientEquipmentModel *model = [[WLAddPushClientEquipmentModel alloc]init];
    model = [WLAddPushClientEquipmentModel mj_objectWithKeyValues:dict];
    return model;
}

@end
