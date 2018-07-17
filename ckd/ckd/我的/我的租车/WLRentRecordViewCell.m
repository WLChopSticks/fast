//
//  WLRentRecordViewCell.m
//  ckd
//
//  Created by wanglei on 2018/7/17.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLRentRecordViewCell.h"
#import <Masonry.h>

@interface WLRentRecordViewCell()

@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, weak) UILabel *lastLeftLabel;
@property (nonatomic, weak) UILabel *lastRightLabel;

@end

@implementation WLRentRecordViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andLines: (NSInteger)lines
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        UILabel *motorNoLabel = [[UILabel alloc]init];
        self.motorNoLabel = motorNoLabel;
        [self addSubview:motorNoLabel];
        UILabel *motorNo = [[UILabel alloc]init];
        self.motorNo = motorNo;
        [self addSubview:motorNo];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        self.timeLabel = timeLabel;
        [self addSubview:timeLabel];
        UILabel *time = [[UILabel alloc]init];
        self.time = time;
        [self addSubview:time];
        
        //布局
        [motorNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(20);
            make.left.equalTo(self.mas_left).offset(10);
            //                make.height.mas_equalTo(40);
        }];
        [motorNo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(motorNoLabel.mas_centerY);
            make.left.equalTo(motorNoLabel.mas_right).offset(40);
            //                make.height.mas_equalTo(40);
        }];
        
       
        
        //如果需要三行的cell, 则添加第三行
        UILabel *subTimeLabel = [[UILabel alloc]init];
        self.subTimeLabel = subTimeLabel;
        UILabel *subTime = [[UILabel alloc]init];
        self.subTime = subTime;
        
        if (lines == 3)
        {
            [self addSubview:subTimeLabel];
            [self addSubview:subTime];
            
            [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(motorNoLabel.mas_bottom).offset(10);
                make.left.equalTo(self.mas_left).offset(10);
                //                make.height.mas_equalTo(40);
            }];
            [time mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(timeLabel.mas_centerY);
                make.left.equalTo(motorNo.mas_left);
                //                make.height.mas_equalTo(40);
            }];
            [subTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(timeLabel.mas_bottom).offset(10);
                make.left.equalTo(self.mas_left).offset(10);
                //                make.height.mas_equalTo(40);
                make.bottom.equalTo(self.mas_bottom).offset(-20);
            }];
            [subTime mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(subTimeLabel.mas_centerY);
                make.left.equalTo(motorNo.mas_left);
                //                make.height.mas_equalTo(40);
            }];
        }else
        {
            [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(motorNoLabel.mas_bottom).offset(10);
                make.left.equalTo(self.mas_left).offset(10);
                //                make.height.mas_equalTo(40);
                make.bottom.equalTo(self.mas_bottom).offset(-20);
            }];
            [time mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(timeLabel.mas_centerY);
                make.left.equalTo(motorNo.mas_left);
                //                make.height.mas_equalTo(40);
            }];
        }
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
