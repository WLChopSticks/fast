//
//  UIButton+WLVerticalImageTitle.h
//  ckd
//
//  Created by 王磊 on 2018/5/9.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WLButtonEdgeInsetsStyle) {
    WLButtonEdgeInsetsStyleTop, // image在上，label在下
    WLButtonEdgeInsetsStyleLeft, // image在左，label在右
    WLButtonEdgeInsetsStyleBottom, // image在下，label在上
    WLButtonEdgeInsetsStyleRight // image在右，label在左
};  
@interface UIButton (WLVerticalImageTitle)

- (void)layoutButtonWithEdgeInsetsStyle:(WLButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
