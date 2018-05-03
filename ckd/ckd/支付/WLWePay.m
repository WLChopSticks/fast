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
#import "WLDataMD5.h"


#define PartnerId @"1503148131"

@interface WLWePay()

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *partnerId;
@property (nonatomic, strong) NSString *prepayId;
@property (nonatomic, strong) NSString *package;
@property (nonatomic, strong) NSString *nonceStr;
@property (nonatomic, strong) NSString *tradeType;
@property (nonatomic, strong) NSString *outTradeNo;
@property (nonatomic, strong) NSString *price;


@end

@implementation WLWePay

- (void)createWePayRequestWithMoney: (NSString *)fee
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *total_fee = [NSString stringWithFormat:@"{total_fee:%@}",fee];
    [parameters setObject:total_fee forKey:@"inputParameter"];
    NSString *URL = @"http://47.104.85.148:18070/ckdhd/addWxPayHy.action";
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        WLInitPayModel *initPayModel = [WLInitPayModel getInitPayModel:result];
        if ([initPayModel.code integerValue] == 1)
        {
            self.appId = initPayModel.data.appid;
            self.partnerId = initPayModel.data.mch_id;
            self.prepayId = initPayModel.data.prepay_id;
            self.package = @"Sign=WXPay";
            self.nonceStr = initPayModel.data.nonce_str;
            self.tradeType = initPayModel.data.trade_type;
            self.outTradeNo = initPayModel.data.out_trade_no;
            self.price = fee;
            
            
            
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = initPayModel.data.mch_id;
            request.prepayId= initPayModel.data.prepay_id;
            request.package = @"Sign=WXPay";
            request.nonceStr= initPayModel.data.nonce_str;

            // 将当前时间转化成时间戳
            NSDate *datenow = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            UInt32 timeStamp =[timeSp intValue];
            request.timeStamp= timeStamp;
            // 签名加密
            WLDataMD5 *md5 = [[WLDataMD5 alloc] init];
            request.sign = [md5.dic objectForKey:@"sign"];
            request.sign=[md5 createMD5SingForPay:self.appId
                                        partnerid:self.partnerId
                                         prepayid:self.prepayId
                                          package:self.package
                                         noncestr:self.nonceStr
                                        timestamp:timeStamp];
            
            
            NSLog(@"初始化支付成功");
    
    
//                        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//            NSTimeInterval a=[dat timeIntervalSince1970];
//            request.timeStamp= (UInt32)a;
//            request.timeStamp= (UInt32)[[WLUtilities getNowTimeTimestamp]longLongValue / 1000];
//            request.sign= initPayModel.data.sign;
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
