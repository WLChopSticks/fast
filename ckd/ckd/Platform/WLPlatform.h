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
#import "WLBaseUIViewController.h"
#import "WLBaseNavigationViewController.h"

//屏幕尺寸
#define Screen_Bounds [UIScreen mainScreen].bounds
#define Screen_Size [UIScreen mainScreen].bounds.size
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

//小功能按钮尺寸
#define Func_Btn_Width 50
#define Func_Btn_Height 50

#define Margin 10

//字体颜色风格
#define LightGrayStyle [UIColor lightGrayColor]

//灰色背景
#define LightGrayBackground [UIColor colorWithRed:251/255.0 green:249/255.0 blue:250/255.0 alpha:1.0]










