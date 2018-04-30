//
//  WLMapAnnotationView.m
//  ckd
//
//  Created by 王磊 on 2018/4/30.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLMapAnnotationView.h"

@implementation WLMapAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.centerOffset = CGPointMake(0, 0);
        //定义改标注总的大小
        self.frame = CGRectMake(0, 0, 39, 39);
        
        _bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
        _bgImageView.image = [UIImage imageNamed:@"station_available"];
        [self addSubview:_bgImageView];
    }
    return self;
}

@end
