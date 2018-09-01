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

- (UITableViewCell *)ListView: (WLListView *)view cellForEachListItem: (UITableViewCell *)originalCell atIndexPath: (NSIndexPath *)indexPath;
- (void)ListView: (WLListView *)view selectListItem: (UITableViewCell *)sender andClickInfo: (NSString *)info;


//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
@end

@interface WLListView : UIView

//tableView的数据
@property (nonatomic, strong) NSArray *listItems;
@property (nonatomic, weak) UITableView *listView;
//cell name用来确定tableView要使用哪种类型的cell
@property (nonatomic, strong) NSString *cellName;
//tableView是否可以拖动
@property (nonatomic, assign) BOOL notScroll;
//tableView是否圆角, 若要改变圆角的级别, 先设置圆角的数量, 在设置bool值
@property (nonatomic, assign) BOOL isRadious;
@property (nonatomic, assign) NSInteger radiousNumber;
//设置cell的高度
@property (nonatomic, assign) NSInteger rowHeight;
//如果需要实现点击事件, 则需要使用代理
@property (nonatomic, weak) id<ListViewDelegate> delegate;



@end
