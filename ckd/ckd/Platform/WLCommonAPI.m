//
//  WLCommonAPI.m
//  ckd
//
//  Created by 王磊 on 2018/5/6.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLCommonAPI.h"
#import "WLNetworkTool.h"

@implementation WLCommonAPI

static WLCommonAPI *_instance;
+(instancetype)sharedCommonAPIManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[WLCommonAPI alloc]init];
    });
    return _instance;
}

- (void)aquireCityList:(void (^)(id result))completeQuery
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"AquireCityInformation"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        completeQuery(responseObject);
    } failure:^(NSError *error) {
        completeQuery(error);
    }];
}

@end
