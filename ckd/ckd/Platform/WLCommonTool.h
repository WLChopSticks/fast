//
//  WLCommonTool.h
//  ckd
//
//  Created by 王磊 on 2018/5/5.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WLCommonTool : NSObject

//开启每秒执行的timer
+ (void)createEverySecondTimer:(void(^)(dispatch_source_t timer))block;

//给控件一个圆角
+ (void)makeViewShowingWithRoundCorner: (UIView *)view andRadius: (CGFloat)radius;

@end
