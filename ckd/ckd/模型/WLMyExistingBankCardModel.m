//
//  WLMyExistingBankCardModel.m
//  ckd
//
//  Created by 王磊 on 2018/9/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLMyExistingBankCardModel.h"
#import <MJExtension.h>

@implementation WLBankCardModel
@end

//@implementation WLBankCardListModel
//@end

@implementation WLMyExistingBankCardModel

+(instancetype)getMyExistingBankCardModel:(NSDictionary *)dict
{
    WLMyExistingBankCardModel *model = [[WLMyExistingBankCardModel alloc]init];
    model = [WLMyExistingBankCardModel mj_objectWithKeyValues:dict];
    model.data = [WLBankCardModel mj_objectArrayWithKeyValuesArray:(NSArray *)dict[@"data"][@"list"]];
    return model;
}

@end
