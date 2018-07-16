//
//  WLListView.h
//  ckd
//
//  Created by wanglei on 2018/7/16.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WLListView;
@protocol ListViewDelegate<NSObject>

- (void)ListView: (WLListView *)view selectListItem: (UITableViewCell *)sender andClickInfo: (NSString *)info;

@end

@interface WLListView : UIView
//tableView的数据
@property (nonatomic, strong) NSArray *listItems;
//cell name用来确定tableView要使用哪种类型的cell
@property (nonatomic, strong) NSString *cellName;
//tableView是否可以拖动
@property (nonatomic, assign) BOOL scrollEnable;
//如果需要实现点击事件, 则需要使用代理
@property (nonatomic, weak) id<ListViewDelegate> delegate;


@end
