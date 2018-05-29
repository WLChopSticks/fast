//
//  WLPaidRecordCell.h
//  ckd
//
//  Created by 王磊 on 2018/5/6.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLPaidRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *order_idLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceDetaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidTimeLabel;

@end
