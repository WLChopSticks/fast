//
//  AppDelegate.h
//  ckd
//
//  Created by wanglei on 2018/4/28.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <WXApi.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSString *user_id;


@end

