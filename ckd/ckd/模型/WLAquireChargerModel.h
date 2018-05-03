//
//  WLAquireChargerModel.h
//  ckd
//
//  Created by wanglei on 2018/5/3.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLAquireChargerInfoModel : NSObject

@property (nonatomic, strong) NSString *zlbj;///种类标记
@property (nonatomic, strong) NSString *hdcbj;///换电池标记

@end

@interface WLAquireChargerModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) WLAquireChargerInfoModel *data;
@property (nonatomic, strong) NSString *message;

+ (instancetype)getAquireChargerModel: (NSDictionary *)dict;
@end



