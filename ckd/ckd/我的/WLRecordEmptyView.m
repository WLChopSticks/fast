//
//  WLRecordEmptyView.m
//  ckd
//
//  Created by 王磊 on 2018/5/6.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLRecordEmptyView.h"
#import "WLPlatform.h"

@implementation WLRecordEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *backImageView = [[UIImageView alloc]initWithFrame:Screen_Bounds];
        [self addSubview:backImageView];
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.text = @"空空如也, 啥也没有";
        tipLabel.textColor = LightGrayStyle;
        [self addSubview:tipLabel];
        backImageView.image = [UIImage imageNamed:@"no_product"];
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.height.mas_equalTo(100);
        }];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backImageView.mas_bottom).offset(5);
            make.centerX.equalTo(backImageView.mas_centerX);
        }];
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
