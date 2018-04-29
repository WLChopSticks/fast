//
//  WLProfileItemsCell.h
//  ckd
//
//  Created by 王磊 on 2018/4/29.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLProfileItemsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemIcon;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *itemRemark;
@property (weak, nonatomic) IBOutlet UIImageView *itemArrow;

@end
