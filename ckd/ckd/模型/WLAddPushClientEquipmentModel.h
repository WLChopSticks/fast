//
//  WLAddPushClientEquipmentModel.h
//  ckd
//
//  Created by 王磊 on 2018/12/16.
//  Copyright © 2018 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLPushDataModel : NSObject

@property (nonatomic, strong) NSString *push;

@end

@interface WLAddPushClientEquipmentModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSString *message;

+ (instancetype)getAddPushClientEquipmentModel: (NSDictionary *)dict;

@end

