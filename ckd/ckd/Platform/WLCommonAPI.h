//
//  WLCommonAPI.h
//  ckd
//
//  Created by 王磊 on 2018/5/6.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLCommonAPI : NSObject

+(instancetype)sharedCommonAPIManager;

//获取城市列表
- (void)aquireCityList:(void (^)(id result))completeQuery;
//换电流程
- (void)queryAquireChargerWithCode: (NSString *)code andActionType: (NSString *)actionType success:(void (^)(id _Nullable))success failure:(void (^)(NSError *))failure;

@end
