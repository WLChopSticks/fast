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





