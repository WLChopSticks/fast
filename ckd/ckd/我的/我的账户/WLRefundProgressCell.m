//
//  WLRefundProgressCell.m
//  ckd
//
//  Created by 王磊 on 2018/9/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLRefundProgressCell.h"

@implementation WLRefundProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setIsTickSymbol:(BOOL)isTickSymbol
{
    _isTickSymbol = isTickSymbol;
    if (isTickSymbol)
    {
        self.flagImage.image = [UIImage imageNamed:@"wancheng"];
    }else
    {
        self.flagImage.image = [UIImage imageNamed:@"shibai"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
