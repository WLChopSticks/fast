//
//  WLNetworkAPIs.m
//  ckd
//
//  Created by 王磊 on 2018/12/16.
//  Copyright © 2018 wanglei. All rights reserved.
//

#import "WLNetworkAPIs.h"
#import "WLPlatform.h"
#import "WLAddPushClientEquipmentModel.h"

@implementation WLNetworkAPIs

+ (void)AddPushClientEquipment
{
    /*
     http://localhost:8090/ckdhd/addPushClientEquipment.action?inputParameter={m_equ_id:159,m_user_phone:1,m_client_id:123,m_app_id:chl,m_create_time:1,m_update_time:0,m_equipment_flag:1}
     */

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    WLUserInfoMaintainance *userInfo = [WLUserInfoMaintainance sharedMaintain];
    NSString *para_String = [NSString stringWithFormat:@"{m_user_phone:%@,m_client_id:%@,m_app_id:1,m_equipment_flag:2}",userInfo.model.data.user_phone,userInfo.model.data.user_id];
    [parameters setObject:para_String forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"AddPushClientEquipment"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        WLAddPushClientEquipmentModel *model = [WLAddPushClientEquipmentModel getAddPushClientEquipmentModel:result];

        if ([model.code isEqualToString:@"1"])
        {
            NSLog(@"绑定推送客户端成功");
        }else
        {
            NSLog(@"绑定推送客户端失败");
        }
        
    } failure:^(NSError *error) {
        NSLog(@"绑定推送客户端失败");
        NSLog(@"%@",error);

    }];
}

@end
