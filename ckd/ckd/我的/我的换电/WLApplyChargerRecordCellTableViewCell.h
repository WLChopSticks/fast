//
//  WLApplyChargerRecordCellTableViewCell.h
//  ckd
//
//  Created by 王磊 on 2018/5/3.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLApplyChargerRecordCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chargerNumber;
@property (weak, nonatomic) IBOutlet UILabel *stationName;
@property (weak, nonatomic) IBOutlet UILabel *getTime;
@property (weak, nonatomic) IBOutlet UILabel *returnTime;

@end
