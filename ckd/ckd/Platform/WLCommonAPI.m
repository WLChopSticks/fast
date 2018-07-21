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

//获取城市列表
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

//换电流程
- (void)queryAquireChargerWithCode:(NSString *)code andActionType:(NSString *)actionType success:(void (^)(id _Nullable))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *para_String = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"zlbj\":\"%@\",\"hdcbj\":\"%@\"}",[WLUtilities getUserID], code, actionType];
    [parameters setObject:para_String forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"ExchangeChargerProgress"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSError *error) {
        NSLog(@"查询换电流程失败");
        NSLog(@"%@",error);
        failure(error);
    }];
}

@end
