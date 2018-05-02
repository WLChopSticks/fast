//
//  WLStationDetailPromptView.m
//  ckd
//
//  Created by wanglei on 2018/5/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLStationDetailPromptView.h"

@implementation WLStationDetailPromptView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
//        WLStationDetailPromptView * view = [[[NSBundle mainBundle]loadNibNamed:@"WLStationDetailPromptView" owner:nil options:nil]lastObject];
//        view.frame = self.bounds;
//        [self addSubview:view];
    }
   
    return self;
    
}
- (IBAction)collectionBtnDidClicking:(id)sender
{
    NSLog(@"收藏按钮点击了");
}

+ (instancetype)instanceView
{
    return [[NSBundle mainBundle]loadNibNamed:@"WLStationDetailPromptView" owner:nil options:nil].lastObject;
}


@end
