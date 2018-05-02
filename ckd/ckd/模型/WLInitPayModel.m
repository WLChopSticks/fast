//
//  WLInitPayModel.m
//  ckd
//
//  Created by wanglei on 2018/5/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLInitPayModel.h"

@implementation WLInitPayParametersModel
@end

@implementation WLInitPayModel

+(instancetype)getInitPayModel:(NSDictionary *)dict
{
    WLInitPayModel *model = [[WLInitPayModel alloc]init];
    [WLInitPayModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"data":@"data"
                 };
    }];
    model = [WLInitPayModel mj_objectWithKeyValues:dict];
    return model;
}

@end
