//
//  WLWePay.h
//  ckd
//
//  Created by wanglei on 2018/5/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Electrombile,
    Charger,
} PriceType;

typedef enum : NSUInteger {
    DepositPrice = 1,
    RentPrice,
} PriceTypeCode;

typedef enum : NSUInteger {
    ChargerDeposit = 1,
    ChargerRent,
    ElectrombileDeposit,
    ElectrmobileRent,
} PriceDetailCode;

@interface WLWePay : NSObject

+ (instancetype)sharedWePay;
- (void)createWePayRequestWithPriceType: (PriceType)type andPriceTypeCode: (PriceTypeCode)typeCode andPriceDetailCode: (PriceDetailCode)priceDetailCode;

@end
