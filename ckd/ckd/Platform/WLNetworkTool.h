//
//  WLNetworkTool.h
//  ckd
//
//  Created by 王磊 on 2018/4/30.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLPlatform.h"

@interface WLNetworkTool : NSObject

@property (nonatomic, strong) NSDictionary *queryAPIList;

+ (instancetype)sharedNetworkToolManager;

- (void)POST_queryWithURL: (NSString *)urlString andParameters: (NSDictionary *)parameters success:(nullable void (^)(id _Nullable responseObject))success failure:(nullable void (^)(NSError *error))failure;

- (void)GET_queryWithURL: (NSString *)urlString andParameters: (NSDictionary *)parameters success:(nullable void (^)(id _Nullable responseObject))success failure:(nullable void (^)(NSError *error))failure;
@end



