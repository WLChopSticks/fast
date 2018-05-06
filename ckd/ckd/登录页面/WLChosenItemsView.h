//
//  WLChosenItemsView.h
//  ckd
//
//  Created by 王磊 on 2018/5/6.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WLChosenItemsView;
@protocol chosenViewDelegate<NSObject>
- (void)chosenView: (WLChosenItemsView *)view didSelectItemInListView: (id)item;
@end
@interface WLChosenItemsView : UIView

@property (nonatomic, strong) NSArray *chosenItems;
@property (nonatomic, weak) id<chosenViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andChosenItems: (NSArray *)chosenItems;

@end
