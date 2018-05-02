//
//  WLStationDetailPromptView.h
//  ckd
//
//  Created by wanglei on 2018/5/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLStationDetailPromptView : UIView
@property (weak, nonatomic) IBOutlet UILabel *stationName;
@property (weak, nonatomic) IBOutlet UILabel *stationAddress;
@property (weak, nonatomic) IBOutlet UILabel *stationTelephone;
@property (weak, nonatomic) IBOutlet UILabel *chargerCount;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;


+ (instancetype)instanceView;
@end
