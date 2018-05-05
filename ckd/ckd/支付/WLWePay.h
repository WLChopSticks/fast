//
//  WLWePay.h
//  ckd
//
//  Created by wanglei on 2018/5/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLWePay : NSObject

+ (instancetype)sharedWePay;
- (void)createWePayRequestWithMoney: (NSString *)fee;

@end
