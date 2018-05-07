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
@property (nonatomic, strong) NSString *api_id;
@property (nonatomic, strong) NSString *order_id;



@property (nonatomic, strong) NSString *type;// 类别 0 电动车 1电池
@property (nonatomic, strong) NSString *typeCode;// 费用类型代码1 押金 2租金
@property (nonatomic, strong) NSString *priceDetailCode;

@end

@implementation WLWePay

static WLWePay *_instance;
+(instancetype)sharedWePay
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[WLWePay alloc]init];

    });
    return _instance;
}

- (void)createWePayRequestWithPriceType: (PriceType)type andPriceTypeCode: (PriceTypeCode)typeCode andPriceDetailCode: (PriceDetailCode)priceDetailCode
{

    self.type = [NSString stringWithFormat:@"%lu",(unsigned long)type];
    self.typeCode = [NSString stringWithFormat:@"%lu",(unsigned long)typeCode];
    self.priceDetailCode = [NSString stringWithFormat:@"%lu",(unsigned long)priceDetailCode];
    
    [self queryPriceForDifferentPriceTypeComplete:^(NSString *fee) {
        if (fee)
        {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            NSString *total_fee = [NSString stringWithFormat:@"{total_fee:%@}",fee];
            [parameters setObject:total_fee forKey:@"inputParameter"];
            WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
            NSString *URL = networkTool.queryAPIList[@"InitWePay"];
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
                    self.api_id = initPayModel.data.api_key;
                    self.order_id = initPayModel.data.out_trade_no;
                    self.price = fee;
                    
                    
                    [self uploadWepayFinishStatus];
                    
                    PayReq *request = [[PayReq alloc] init];
                    request.partnerId = initPayModel.data.mch_id;
                    request.prepayId= initPayModel.data.prepay_id;
                    request.package = @"Sign=WXPay";
                    request.nonceStr= initPayModel.data.nonce_str;
                    request.sign = initPayModel.data.sign;
                    
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
                                                timestamp:timeStamp app_id:self.api_id];
                    
                    //监听支付状态
//                    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadWepayFinishStatus) name:WePayResponseNotification object:nil];
                    [WXApi sendReq:request];
                    NSLog(@"初始化支付成功");
                    
                    
                    //                        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                    //            NSTimeInterval a=[dat timeIntervalSince1970];
                    //            request.timeStamp= (UInt32)a;
                    //            request.timeStamp= (UInt32)[[WLUtilities getNowTimeTimestamp]longLongValue / 1000];
                    //            request.sign= initPayModel.data.sign;
                }else
                {
                    NSLog(@"初始化支付失败");
                }
            } failure:^(NSError *error) {
                NSLog(@"初始化支付失败");
                NSLog(@"%@",error);
            }];
        }else
        {
            NSLog(@"查询费用失败");
        }
    }];
    
}

- (void)queryPriceForDifferentPriceTypeComplete: (void(^)(NSString *fee))completion
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *parametersStr = [NSString stringWithFormat:@"{fylxdm:%@,fylb:%@,fyxqdm:%@,user_id:%@}",self.typeCode, self.type, self.priceDetailCode, [WLUtilities getUserID]];
    [parameters setObject:parametersStr forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"AquirePriceDetailInformation"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if ([result[@"code"] integerValue] == 1)
        {
            NSLog(@"查询今日换电次数成功");
            completion(result[@"data"][@"fyje"]);
            
        }else
        {
            NSLog(@"查询今日换电次数失败");
            completion(nil);
        }
    } failure:^(NSError *error) {
        NSLog(@"获取缴费记录失败");
        NSLog(@"%@",error);
        completion(nil);
    }];
}

- (void)wePayFinishProcess: (NSNotification *)notice
{
    NSDictionary *dict = notice.userInfo;
    PaidResult result = [dict[@"result"]integerValue];
    switch (result) {
        case Paid_Success:
        {
            //将支付订单号等上传服务器
            [self uploadWepayFinishStatus];
            break;
        }
        case Paid_Fail:
        {
            [ProgressHUD showError:@"支付失败"];
            break;
        }
        case Paid_Cancel:
        {
            [ProgressHUD showError:@"用户取消"];
            break;
        }
            
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)uploadWepayFinishStatus
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *payInfo = [NSString stringWithFormat:@"{order_id:%@,jffs:%@,user_id:%@,fyje:%@,fyxqdm:%@,fylxdm:%@,Fylb:%@}",self.order_id, @"03", [WLUtilities getUserID], self.price, self.priceDetailCode, self.typeCode,self.type];
    [parameters setObject:payInfo forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"UploadPaidResult"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
//
//        if ([result[@"code"] integerValue] == 1)
//        {
//            NSLog(@"支付结果上传成功");
//        }else
//        {
//            NSLog(@"支付结果上传失败");
//        }
    } failure:^(NSError *error) {
        NSLog(@"支付结果上传失败");
        NSLog(@"%@",error);
    }];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
