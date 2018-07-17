//
//  WLRentMotorRecordModel.h
//  ckd
//
//  Created by wanglei on 2018/7/17.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLRentMotorRecordDetailModel : NSObject

@property (nonatomic, strong) NSString *user_id;//用户id
@property (nonatomic, strong) NSString *ddcdm;//电动车代码
@property (nonatomic, strong) NSString *jqsj;//借取时间/锁车/开锁时间
@property (nonatomic, strong) NSString *ghsj;//归还时间（只有借取的电动车有归还时间）
@property (nonatomic, strong) NSString *scbs;//锁车标识(0锁车，1开锁，2借取）

@end

@interface WLRentMotorRecordModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *message;

+ (instancetype)getRentModelRecordModel: (NSDictionary *)dict;

@end


