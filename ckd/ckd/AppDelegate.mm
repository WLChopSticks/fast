//
//  AppDelegate.m
//  ckd
//
//  Created by wanglei on 2018/4/28.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "AppDelegate.h"
#import "WLPlatform.h"
#import "WLBaseNavigationViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "WLBootViewController.h"
#import "WLWePay.h"

#import "WLChargerRecord.h"
#import "WLInquireCostDetailModel.h"
#import "WLAquireChargerModel.h"
#import "WLDepositStatusModel.h"

BMKMapManager* _mapManager;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:Screen_Bounds];
    WLBootViewController *bootVC = [[WLBootViewController alloc]init];
    WLBaseNavigationViewController *nav = [[WLBaseNavigationViewController alloc]initWithRootViewController:bootVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    //注册百度地图
    [self startBaiduMap];
    //向微信注册
    [WXApi registerApp:@"wx7e0a8fc77aeaf595"];
    
    WLWePay *we = [[WLWePay alloc]init];
    [we createWePayRequestWithMoney:@"100"];
//    [self queryDepositStatus];
    
    return YES;
}

//查询押金状态
- (void)queryDepositStatus
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *para_String = [NSString stringWithFormat:@"{user_id:c1aff8bcad6e4d1a97713e10f62a00b2}"];
    [parameters setObject:para_String forKey:@"inputParameter"];
    NSString *URL = @"http://47.104.85.148:18070/ckdhd/queryYjzt.action";
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSDictionary *result = (NSDictionary *)responseObject;
        WLDepositStatusModel *depositStatusModel = [[WLDepositStatusModel alloc]init];
        depositStatusModel = [WLDepositStatusModel getDepositStatusModel:result];
        if ([depositStatusModel.code isEqualToString:@"1"])
        {
            NSLog(@"查询押金状态成功");
            
        }else
        {
            [ProgressHUD showError:@"查询押金状态失败"];
            NSLog(@"查询押金状态失败");
        }
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"查询押金状态失败"];
        NSLog(@"查询押金状态失败");
        NSLog(@"%@",error);
    }];
}

//换电池流程
- (void)queryAquireCharger
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *para_String = [NSString stringWithFormat:@"{user_id:c1aff8bcad6e4d1a97713e10f62a00b2,zlbj:KTS000021,hdcbj:0}"];
    [parameters setObject:para_String forKey:@"inputParameter"];
    NSString *URL = @"http://47.104.85.148:18070/ckdhd/HdlcCz.action";
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSDictionary *result = (NSDictionary *)responseObject;
        WLAquireChargerModel *aquireChargerModel = [[WLAquireChargerModel alloc]init];
        aquireChargerModel = [WLAquireChargerModel getAquireChargerModel:result];
        if ([aquireChargerModel.code isEqualToString:@"1"])
        {
            NSLog(@"查询换电流程成功");
            
        }else
        {
            [ProgressHUD showError:@"查询换电流程失败"];
            NSLog(@"查询换电流程失败");
        }
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"查询换电流程失败"];
        NSLog(@"查询换电流程失败");
        NSLog(@"%@",error);
    }];
}

//查询信息费用
- (void)queryCostDetail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *para_String = [NSString stringWithFormat:@"{fylxdm:1,fylb:0}"];
    [parameters setObject:para_String forKey:@"inputParameter"];
    NSString *URL = @"http://47.104.85.148:18070/ckdhd/queryFyxx.action";
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSDictionary *result = (NSDictionary *)responseObject;
        WLInquireCostDetailModel *costDetailModel = [[WLInquireCostDetailModel alloc]init];
        costDetailModel = [WLInquireCostDetailModel getInquireCostDetailModel:result];
        if ([costDetailModel.code isEqualToString:@"1"])
        {
            NSLog(@"查询换电记录成功");
            
        }else
        {
            [ProgressHUD showError:@"查询换电记录失败"];
            NSLog(@"查询换电记录失败");
        }
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"查询换电记录失败"];
        NSLog(@"查询换电记录失败");
        NSLog(@"%@",error);
    }];
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma --mark 微信相关
//-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    return [WXApi handleOpenURL:url delegate:self];
//}
//
//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return [WXApi handleOpenURL:url delegate:self];
//}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(void)onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}

#pragma --mark 百度地图方法
- (void)startBaiduMap
{
    _mapManager = [[BMKMapManager alloc]init];
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    BOOL ret = [_mapManager start:@"od8frLbiZOnpGXqEhDFTvl75EUXamOtn" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}




@end
