//
//  WLMyExistingBankCardModel.h
//  ckd
//
//  Created by 王磊 on 2018/9/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLBankCardModel : NSObject

@property (nonatomic, strong) NSString *sfmr;//
@property (nonatomic, strong) NSString *scbj;//
@property (nonatomic, strong) NSString *lsh;//流水号
@property (nonatomic, strong) NSString *yhmc;//银行名称
@property (nonatomic, strong) NSString *yhkh;//银行卡号
@property (nonatomic, strong) NSString *ckrxm;//持卡人姓名
@end

@interface WLMyExistingBankCardModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *message;

+ (instancetype)getMyExistingBankCardModel: (NSDictionary *)dict;

@end
