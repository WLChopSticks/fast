//
//  WLRentRecordViewCell.h
//  ckd
//
//  Created by wanglei on 2018/7/17.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLRentRecordViewCell : UITableViewCell

@property (nonatomic, weak) UILabel *motorNoLabel;
@property (nonatomic, weak) UILabel *motorNo;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *time;
@property (nonatomic, weak) UILabel *subTimeLabel;
@property (nonatomic, weak) UILabel *subTime;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andLines: (NSInteger)lines;

@end
