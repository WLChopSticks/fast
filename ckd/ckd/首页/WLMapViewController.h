//
//  WLMapViewController.h
//  ckd
//
//  Created by 王磊 on 2018/4/30.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLBaseUIViewController.h"

@interface WLMapViewController : WLBaseUIViewController

@property (nonatomic, strong) NSArray *LocationOfStations;

//获取当前位置
- (void)startGetUserPosition;
//显示当前城市站点位置
- (void)getLocationOfStationsInCurrentCity;


@end
