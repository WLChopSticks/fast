//
//  WLWePay.h
//  ckd
//
//  Created by wanglei on 2018/5/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Motor,
    Charger,
} PriceType;

typedef enum : NSUInteger {
    DepositPrice = 1,
    RentPrice,
} PriceTypeCode;

typedef enum : NSUInteger {
    ChargerDeposit = 1,
    ChargerRent,
    MotorDeposit,
    MotorRent,
} PriceDetailCode;

@interface WLWePay : NSObject

//轮询押金租金状态的次数
@property (nonatomic, assign) NSInteger queryCount;

+ (instancetype)sharedWePay;
- (void)createWePayRequestWithPriceType: (PriceType)type andPriceTypeCode: (PriceTypeCode)typeCode andPriceDetailCode: (PriceDetailCode)priceDetailCode;

- (void)repeatQueryUserDepositStatus: (NSString *)expectStatus;
- (void)repeatQueryUserPaidRentStatus: (NSString *)expectStatus;

@end
