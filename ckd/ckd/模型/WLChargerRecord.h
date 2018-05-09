//
//  WLChargerRecord.h
//  ckd
//
//  Created by wanglei on 2018/5/3.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLChargerRecordListModel : NSObject

@property (nonatomic, strong) NSString *dcdm;///电池代码
@property (nonatomic, strong) NSString *jqsj;///借取时间
@property (nonatomic, strong) NSString *zdmc;///站点名称
@property (nonatomic, strong) NSString *ghsj;///归还时间
@property (nonatomic, strong) NSString *user_id;///用户id
@property (nonatomic, strong) NSString *fjgmc;///放入机柜名称
@property (nonatomic, strong) NSString *qjgmc;///取出机柜名称

@end

@interface WLChargerRecord : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *message;

+ (instancetype)getChargerRecordModel: (NSDictionary *)dict;
@end


