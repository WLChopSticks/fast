//
//  WLQuickLoginModel.m
//  ckd
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLQuickLoginModel.h"
#import <MJExtension.h>

@implementation WLQuickLoginModel

+ (instancetype)getQuickLoginModel:(NSDictionary *)dict
{
    WLQuickLoginModel *model = [[WLQuickLoginModel alloc]init];
    model = [WLQuickLoginModel mj_objectWithKeyValues:dict];
    
    return model;
}

@end
