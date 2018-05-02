//
//  WLEachChargerStationModel.h
//  ckd
//
//  Created by wanglei on 2018/5/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLEachChargerStationInfoModel : NSObject

@property (nonatomic, strong) NSString *zddm;
@property (nonatomic, strong) NSString *zdmc;
@property (nonatomic, strong) NSString *zdwd;
@property (nonatomic, strong) NSString *zdjd;
@property (nonatomic, strong) NSString *zddz;
@property (nonatomic, strong) NSString *csdm;
@property (nonatomic, strong) NSString *kssj;
@property (nonatomic, strong) NSString *jssj;
@property (nonatomic, strong) NSString *dcsl;

@end

@interface WLEachChargerStationModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *message;

-(instancetype)getEachChargerStationModel: (NSDictionary *)dict;

@end
