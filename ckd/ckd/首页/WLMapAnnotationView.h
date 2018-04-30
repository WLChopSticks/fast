//
//  WLMapAnnotationView.h
//  ckd
//
//  Created by 王磊 on 2018/4/30.
//  Copyright © 2018年 wanglei. All rights reserved.
//

//#import <BaiduMapAPI_Map/BaiduMapAPI_Map.h>
#import <BaiduMapAPI_Map/BMKAnnotationView.h>


@interface WLMapAnnotationView : BMKAnnotationView

@property (nonatomic, strong) UIImageView *bgImageView;

@end
