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
#import <UMCommon/UMCommon.h>
#import "WLUserInfoMaintainance.h"

#import "WLChargerRecord.h"
#import "WLInquireCostDetailModel.h"
#import "WLAquireChargerModel.h"
#import "WLDepositStatusModel.h"

#import <UserNotifications/UserNotifications.h>
#import <GTSDK/GeTuiSdk.h>

BMKMapManager* _mapManager;

#ifdef DEBUG
#define kGtAppId           @"TF7jpF2vrB9w8CjvNcvxj"
#define kGtAppKey          @"jnmXZrpU5s8AXTmGgKNsD"
#define kGtAppSecret       @"0veK1vJS3D8GiHO2JVFRy9"
#else
#define kGtAppId           @"yZ3xODxDMcA43JhXaOqXc1"
#define kGtAppKey          @"tahKvs6fDZ5nJUIuIM6VJA"
#define kGtAppSecret       @"M9XjcwCpgt71y1u39Ke0L6"
#endif



/*
 //开发
 AppID： TF7jpF2vrB9w8CjvNcvxj
 AppSecret： 0veK1vJS3D8GiHO2JVFRy9
 AppKey： jnmXZrpU5s8AXTmGgKNsD
 MasterSecret： JPRz7VNOEd6eXbgWIftA69
 
 //生产
 AppID： yZ3xODxDMcA43JhXaOqXc1
 AppSecret： M9XjcwCpgt71y1u39Ke0L6
 AppKey： tahKvs6fDZ5nJUIuIM6VJA
 MasterSecret： qHuBxdhlxY6O11zLG38dc2
 */

@interface AppDelegate ()<UNUserNotificationCenterDelegate, GeTuiSdkDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //如果用户已经登录, 则获取用户信息
    self.window = [[UIWindow alloc]initWithFrame:Screen_Bounds];
    WLBootViewController *bootVC = [[WLBootViewController alloc]init];
    WLBaseNavigationViewController *nav = [[WLBaseNavigationViewController alloc]initWithRootViewController:bootVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    //注册百度地图
    [self startBaiduMap];
    //向微信注册
    [WXApi registerApp:@"wxbeb444ea61fe3901"];
    
    [UMConfigure initWithAppkey:@"5af19409b27b0a33a4000044" channel:@"App Store"];
//    [self queryDepositStatus];
    
    // [ GTSdk ]：使用APPID/APPKEY/APPSECRENT创建个推实例
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    [self registerRemoteNotification];
    
    return YES;
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
    [application setApplicationIconBadgeNumber:0]; //清除角标
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
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
        switch(response.errCode)
        {
            case WXSuccess:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [resultDict setObject:[NSNumber numberWithInteger:Paid_Success] forKey:@"result"];
                break;
            }
            case WXErrCodeUserCancel:
            {
                NSLog(@"用户取消支付");
                [resultDict setObject:[NSNumber numberWithInteger:Paid_Cancel] forKey:@"result"];
                break;
            }
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                [resultDict setObject:[NSNumber numberWithInteger:Paid_Fail] forKey:@"result"];
                break;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:WePayResponseNotification object:nil userInfo:resultDict];
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
    BOOL ret = [_mapManager start:@"yKoLnP7NBN4EBssm4kZnqkgvaGcwYNwT" generalDelegate:self];
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

#pragma mark - 用户通知(推送) _自定义方法

/** 注册远程通知 */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8的需要手动开启“TARGETS -> Capabilities -> Push Notifications”
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据APP支持的iOS系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的iOS系统都能获取到DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
                if (!error) {
                    NSLog(@"request authorization succeeded!");
                }
            }];
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        } else {
            // Fallback on earlier versions
        }
        
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    } else
    {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

#pragma mark - 远程通知(推送)回调
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [GeTuiSdk registerDeviceToken:deviceToken.description];
    NSLog(@"\n>>>[DeviceToken]: %@\n\n", deviceToken.description);
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送
/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    
    // 控制台打印接收APNs信息
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - iOS 10中收到推送消息

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}
#endif

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    [WLUtilities savePushNotificationClientId:clientId];
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
        {
            [self registerNotification:1 andMessage:payloadMsg];
        }else
        {
            [self registerLocalNotificationInOldWay:1 andMessage:payloadMsg];
        }
    }

    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
}

//使用 UNNotification 本地通知
- (void)registerNotification:(NSInteger )alerTime andMessage: (NSString *)msg
{
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
//    content.title = [NSString localizedUserNotificationStringForKey:@"Hello!" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:msg
                                                         arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    // 在 alertTime 后推送本地推送
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:alerTime repeats:NO];
    
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                          content:content trigger:trigger];
    
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

- (void)registerLocalNotificationInOldWay:(NSInteger)alertTime andMessage: (NSString *)msg
{
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    NSLog(@"fireDate=%@",fireDate);
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitSecond;
    
    // 通知内容
    notification.alertBody =  msg;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
//    // ios8后，需要添加这个注册，才能得到授权
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
//                                                                                 categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//        // 通知重复提示的单位，可以是天、周、月
//        notification.repeatInterval = NSCalendarUnitDay;
//    } else {
//        // 通知重复提示的单位，可以是天、周、月
//        notification.repeatInterval = NSDayCalendarUnit;
//    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


@end
