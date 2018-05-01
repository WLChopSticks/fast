//
//  WLChargerStationModel.h
//  ckd
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface WLCityData : NSObject

@property (nonatomic, strong) NSString *csmc;
@property (nonatomic, strong) NSString *csdm;

@end
@interface WLChargerStationModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *message;

-(instancetype)getChargerStationModel: (NSDictionary *)dict;

@end



