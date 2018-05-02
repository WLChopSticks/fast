//
//  WLWePay.m
//  ckd
//
//  Created by wanglei on 2018/5/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLWePay.h"
#import "WLPlatform.h"
#import "WLInitPayModel.h"
#import <WXApi.h>

@implementation WLWePay

- (void)createWePayRequestWithMoney: (NSString *)fee
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *total_fee = [NSString stringWithFormat:@"{total_fee:%@}",fee];
    [parameters setObject:total_fee forKey:@"inputParameter"];
    NSString *URL = @"http://47.104.85.148:18070/dlwlsj/addWxPayHy.action";
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        WLInitPayModel *initPayModel = [WLInitPayModel getInitPayModel:result];
        if ([initPayModel.code integerValue] == 1)
        {
            NSLog(@"初始化支付成功");
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = initPayModel.data.appid;
            request.prepayId= initPayModel.data.prepay_id;
            request.package = @"Sign=WXPay";
            request.nonceStr= initPayModel.data.nonce_str;
            request.timeStamp= (UInt32)[[WLUtilities getNowTimeTimestamp]longLongValue];
            request.sign= initPayModel.data.sign;
            [WXApi sendReq:request];
        }else
        {
            NSLog(@"初始化支付失败");
        }
    } failure:^(NSError *error) {
        NSLog(@"初始化支付失败");
        NSLog(@"%@",error);
    }];
}

- (void)uploadWepayFinishStatus: (WLInitPayModel *)model
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *payInfo = [NSString stringWithFormat:@"{order_id:%@,jffs:%@,user_id:%@,fyje:%@,fyxqdm:%@,fylxdm:%@,Fylb:%@}",@"", @"03", [WLUtilities getUserID], @"", @"", @"",@""];
    [parameters setObject:payInfo forKey:@"inputParameter"];
    NSString *URL = @"http://47.104.85.148:18070/ckdhd/queryBljlPayRusult.action";
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if ([result[@"code"] integerValue] == 1)
        {
            NSLog(@"支付结果上传成功");
        }else
        {
            NSLog(@"支付结果上传失败");
        }
    } failure:^(NSError *error) {
        NSLog(@"支付结果上传失败");
        NSLog(@"%@",error);
    }];
}

@end
