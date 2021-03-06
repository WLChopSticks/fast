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
#import "WLQueryPriceInfoModel.h"

//轮询次数, 间隔为2s
#define Repeat_Query_Count 5

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


@property (nonatomic, assign) PriceType type;
@property (nonatomic, strong) NSString *priceType;// 类别 0 电动车 1电池
@property (nonatomic, strong) NSString *priceTypeCode;// 费用类型代码1 押金 2租金
@property (nonatomic, strong) NSString *priceDetailName;//fyxqmc
@property (nonatomic, strong) NSString *priceDetailCode;//fyxqdm
@property (nonatomic, strong) NSString *cityCode;//csmc
@property (nonatomic, strong) NSString *priceNumber;//fyje



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
    self.type = type;
    self.priceType = [NSString stringWithFormat:@"%lu",(unsigned long)type];
    self.priceTypeCode = [NSString stringWithFormat:@"%lu",(unsigned long)typeCode];
    self.priceDetailCode = [NSString stringWithFormat:@"%02lu",(unsigned long)priceDetailCode];
    
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
                    
                    
                    [self uploadWepayOrder];
                    
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
    NSString *parametersStr = [NSString stringWithFormat:@"{fylxdm:%@,fylb:%@,fyxqdm:%@,user_id:%@}",self.priceTypeCode, self.priceType, self.priceDetailCode, [WLUtilities getUserID]];
    [parameters setObject:parametersStr forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"AquirePriceDetailInformation"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        WLQueryPriceInfoModel *model = [WLQueryPriceInfoModel getQueryPriceInfoModel:result];
        if ([model.code integerValue] == 1)
        {
            NSLog(@"查询费用详情成功");
            /*
             @property (nonatomic, strong) NSString *priceType;// 类别 0 电动车 1电池
             @property (nonatomic, strong) NSString *priceTypeCode;// 费用类型代码1 押金 2租金
             @property (nonatomic, strong) NSString *priceDetailName;//fyxqmc
             @property (nonatomic, strong) NSString *priceDetailCode;//fyxqdm
             @property (nonatomic, strong) NSString *cityCode;//csmc
             @property (nonatomic, strong) NSString *priceNumber;//fyje
             */
            self.priceType = model.data.fylb;
            self.priceTypeCode = model.data.fylxdm;
            self.priceDetailName = model.data.fyxqmc;
            self.priceDetailCode = model.data.fyxqdm;
            self.cityCode = model.data.csdm;
            self.priceNumber = model.data.fyje;
            //此处存储的费用金额为了付押金后, 本地处理付款成功的状态
//            [WLUtilities deletePaidPrice];
//            [WLUtilities savePaidPrice:result[@"data"][@"fyje"]];
            
            
            
            completion(self.priceNumber);
            
        }else
        {
            NSLog(@"查询费用详情失败");
            completion(nil);
        }
    } failure:^(NSError *error) {
        NSLog(@"查询费用详情失败");
        NSLog(@"%@",error);
        completion(nil);
    }];
}

- (void)uploadWepayOrder
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *payInfo = [NSString stringWithFormat:@"{orderid:%@,jffs:%@,user_id:%@,fyje:%@,fyxqdm:%@,fylxdm:%@,fylb:%@}",self.order_id, @"03", [WLUtilities getUserID], self.priceNumber, self.priceDetailCode, self.priceTypeCode,self.priceType];
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


//轮询押金状态
- (void)repeatQueryUserDepositType: (PriceType)priceType andStatus: (NSString *)expectStatus
{
    WLUserInfoMaintainance *userInfo = [WLUserInfoMaintainance sharedMaintain];
    [userInfo queryUserInfo:^(NSNumber *result) {
        if (self.queryCount > 0)
        {
            if (priceType == Motor && ![userInfo.model.data.ddcyj isEqualToString:expectStatus])
            {
                [[WLUserInfoMaintainance sharedMaintain]queryUserInfo:^(NSNumber *result) {
                    //            [self checkUserPaidStatus];
                    if (![userInfo.model.data.ddcyj isEqualToString:expectStatus])
                    {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self repeatQueryUserDepositType:priceType andStatus:expectStatus];
                        });
                        self.queryCount--;
                    }else
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"RepeatQueryUserDepositStatusComplete" object:nil userInfo:nil];
                    }
                }];
            }else if (priceType == Motor && [userInfo.model.data.ddcyj isEqualToString:expectStatus])
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RepeatQueryUserDepositStatusComplete" object:nil userInfo:nil];
            }else if (priceType == Charger && ![userInfo.model.data.yj isEqualToString:expectStatus])
            {
                [[WLUserInfoMaintainance sharedMaintain]queryUserInfo:^(NSNumber *result) {
                    //            [self checkUserPaidStatus];
                    if (![userInfo.model.data.yj isEqualToString:expectStatus])
                    {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self repeatQueryUserDepositType:priceType andStatus:expectStatus];
                        });
                        self.queryCount--;
                    }else
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"RepeatQueryUserDepositStatusComplete" object:nil userInfo:nil];
                    }
                }];
            }else if (priceType == Charger && [userInfo.model.data.yj isEqualToString:expectStatus])
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RepeatQueryUserDepositStatusComplete" object:nil userInfo:nil];
            }
            
        }else
        {
            NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"repeatQueryFail"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RepeatQueryUserDepositStatusComplete" object:nil userInfo:dict];
        }
    }];
    
}

//轮询租金状态
- (void)repeatQueryUserPaidRentStatus: (PriceType)priceType andStatus: (NSString *)expectStatus
{
    WLUserInfoMaintainance *userInfo = [WLUserInfoMaintainance sharedMaintain];
    
    [userInfo queryUserInfo:^(NSNumber *result) {
        if (self.queryCount > 0)
        {
            if (priceType == Motor && ![userInfo.model.data.ddczj isEqualToString:expectStatus])
            {
                [[WLUserInfoMaintainance sharedMaintain]queryUserInfo:^(NSNumber *result) {
                    //            [self checkUserPaidStatus];
                    if (![userInfo.model.data.ddczj isEqualToString:expectStatus])
                    {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self repeatQueryUserDepositType:priceType andStatus:expectStatus];
                        });
                        self.queryCount--;
                    }else
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"RepeatQueryUserPaidRentStatus" object:nil userInfo:nil];
                    }
                }];
            }else if (priceType == Motor && [userInfo.model.data.ddczj isEqualToString:expectStatus])
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RepeatQueryUserPaidRentStatus" object:nil userInfo:nil];
            }else if (priceType == Charger && ![userInfo.model.data.zj isEqualToString:expectStatus])
            {
                [[WLUserInfoMaintainance sharedMaintain]queryUserInfo:^(NSNumber *result) {
                    //            [self checkUserPaidStatus];
                    if (![userInfo.model.data.zj isEqualToString:expectStatus])
                    {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self repeatQueryUserPaidRentStatus:priceType andStatus:expectStatus];
                        });
                        self.queryCount--;
                    }else
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"RepeatQueryUserPaidRentStatus" object:nil userInfo:nil];
                    }
                }];
            }else if (priceType == Charger && [userInfo.model.data.zj isEqualToString:expectStatus])
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RepeatQueryUserPaidRentStatus" object:nil userInfo:nil];
            }
            
        }else
        {
            NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"repeatQueryFail"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RepeatQueryUserPaidRentStatus" object:nil userInfo:dict];
        }
    }];
    
    
    
}


@end
