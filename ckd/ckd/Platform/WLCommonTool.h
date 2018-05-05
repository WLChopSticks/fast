//
//  WLCommonTool.h
//  ckd
//
//  Created by 王磊 on 2018/5/5.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLCommonTool : NSObject

//开启每秒执行的timer
+ (void)createEverySecondTimer:(void(^)(dispatch_source_t timer))block;

@end
