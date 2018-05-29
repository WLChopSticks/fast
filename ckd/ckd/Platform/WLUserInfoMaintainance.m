//
//  WLUserInfoMaintainance.m
//  ckd
//
//  Created by 王磊 on 2018/5/6.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLUserInfoMaintainance.h"
#import "WLNetworkTool.h"

@implementation WLUserInfoMaintainance


static WLUserInfoMaintainance *_instance;
+(instancetype)sharedMaintain
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[WLUserInfoMaintainance alloc]init];
    });
    return _instance;
}

-(void)queryUserInfo:(void (^)(NSNumber *))complete
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *parametersStr = [NSString stringWithFormat:@"{user_id:%@}",[WLUtilities getUserID]];
    [parameters setObject:parametersStr forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"QingLogin"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        WLQingLoginModel *model = [WLQingLoginModel getQingLoginModel:result];
        self.model = model;
        if ([model.code integerValue] == 1)
        {
            NSLog(@"获取个人信息成功");
            complete([NSNumber numberWithBool:YES]);
        }else
        {
            NSLog(@"获取个人信息失败");
            complete([NSNumber numberWithBool:NO]);
        }
    } failure:^(NSError *error) {
        NSLog(@"获取个人信息失败");
        NSLog(@"%@",error);
        complete([NSNumber numberWithBool:NO]);
    }];
}

@end
