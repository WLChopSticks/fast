//
//  WLNetworkTool.m
//  ckd
//
//  Created by 王磊 on 2018/4/30.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLNetworkTool.h"

@interface WLNetworkTool()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation WLNetworkTool

static WLNetworkTool *_instance;
+(instancetype)sharedNetworkToolManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        _instance = [[WLNetworkTool alloc]init];
        _instance.manager = manager;
    });
    return _instance;
}

-(void)POST_queryWithURL:(NSString *)urlString andParameters:(NSDictionary *)parameters success:(void (^)(id _Nullable))success failure:(void (^)(NSError *))failure
{
    [_instance.manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)GET_queryWithURL:(NSString *)urlString andParameters:(NSDictionary *)parameters success:(void (^)(id _Nullable))success failure:(void (^)(NSError *))failure
{
    [_instance.manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
