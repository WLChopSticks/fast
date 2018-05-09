//
//  WLPlatform.h
//  ckd
//
//  Created by wanglei on 2018/4/28.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#ifndef WLPlatform_h
#define WLPlatform_h


#endif /* WLPlatform_h */

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif

#import <Masonry.h>
#import <AFNetworking.h>
#import <MJExtension.h>
#import <ProgressHUD.h>
#import "WLUtilities.h"
#import "WLCommonTool.h"
#import "WLNetworkTool.h"
#import "WLBaseUIViewController.h"
#import "WLBaseNavigationViewController.h"
#import "WLCommonAPI.h"
#import "WLUserInfoMaintainance.h"

#define APP (AppDelegate *)[[UIApplication sharedApplication]delegate ]


//屏幕尺寸
#define Screen_Bounds [UIScreen mainScreen].bounds
#define Screen_Size [UIScreen mainScreen].bounds.size
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

//小功能按钮尺寸
#define Func_Btn_Width 50
#define Func_Btn_Height 50

#define Margin 10
#define Btn_Radius 8

//字体颜色风格
#define LightGrayStyle [UIColor lightGrayColor]

//灰色背景
#define LightGrayBackground [UIColor colorWithRed:251/255.0 green:249/255.0 blue:250/255.0 alpha:1.0]

//扫码动作类型
typedef enum : NSUInteger {
    Scan_Canbin,
    Get_Charger,
    Return_Charger,
} Scan_Code_Action;

//到时候按钮时长
#define CountDownTime 30

//支付类型
//扫码动作类型
typedef enum : NSUInteger {
    Paid_Deposit,
    Paid_Rent,
} Paid_Type;

//支付完成通知
#define WePayResponseNotification @"WePayResponseNotification"
typedef enum : NSInteger {
    Paid_Success,
    Paid_Fail,
    Paid_Cancel,
} PaidResult;

//判断设备型号
#define IS_IPAD()       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE()     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_LANDSCAPE()  (UIDeviceOrientationIsLandscape((UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation]))
#define IS_PORTRAIT()   (UIDeviceOrientationIsPortrait((UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation]))
#define IS_IPHONE4()    (IS_IPHONE() && (([[UIScreen mainScreen] bounds].size.height == 480.0) || \
([[UIScreen mainScreen] bounds].size.width == 480.0)))
#define IS_IPHONE5()    (IS_IPHONE() && (([[UIScreen mainScreen] bounds].size.height == 568.0) || \
([[UIScreen mainScreen] bounds].size.width == 568.0)))
#define IS_IPHONE6()    (IS_IPHONE() && (([[UIScreen mainScreen] bounds].size.height == 667.0) || \
([[UIScreen mainScreen] bounds].size.width == 667.0)))
#define IS_IPHONEX() (IS_IPHONE() && (([[UIScreen mainScreen] bounds].size.width == 375.0) && ([[UIScreen mainScreen] bounds].size.height == 812.0) || ([[UIScreen mainScreen] bounds].size.width == 812.0) && ([[UIScreen mainScreen] bounds].size.height == 375.0)))
#define IS_IPHONE6PLUS() (IS_IPHONE() && ([UIScreen mainScreen].scale == 3.0) && !IS_IPHONEX())
#define IS_IPHONE6PLUS_STANDARD()   (IS_IPHONE() && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_IPHONE6PLUS_ZOOMED()     (IS_IPHONE() && [[UIScreen mainScreen] bounds].size.height == 667.0 && \
IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale < [UIScreen mainScreen].scale)




