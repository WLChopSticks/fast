//
//  WLListView.m
//  ckd
//
//  Created by wanglei on 2018/7/16.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLListView.h"
#import "WLDefaultCell.h"
#import "WLPaidRecordCell.h"
#import <Masonry.h>

@interface WLListView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *listView;

@end

@implementation WLListView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UITableView *listView = [[UITableView alloc]initWithFrame:self.bounds];
        self.listView = listView;
        listView.delegate = self;
        listView.dataSource = self;
        
        [self addSubview:listView];
        
        [listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellName.length == 0)
    {
        self.cellName = @"default_cell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellName];
    if (cell == nil)
    {
        if ([self.cellName isEqualToString:@"PaidRecordCell"])
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"WLPaidRecordCell" owner:nil options:nil]lastObject];
        }else if ([self.cellName isEqualToString:@"ApplyChargerRecordCell"])
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"WLApplyChargerRecordCellTableViewCell" owner:nil options:nil]lastObject];
        }else
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"WLDefaultCell" owner:nil options:nil]lastObject];
        }
    }
    
    if ([self.cellName isEqualToString:@"default_cell"])
    {
        WLDefaultCell *defCell = (WLDefaultCell *)cell;
        NSDictionary *item = self.listItems[indexPath.row];
        if ([item[@"icon"] length] == 0)
        {
            defCell.icon.hidden = YES;
            defCell.titleLeadingConstraint.constant = 0;
        }else
        {
            defCell.icon.image = [UIImage imageNamed:item[@"icon"]];
        }
        
        defCell.title.text = item[@"title"];
        defCell.subTitle.text = item[@"subTitle"];
        
        if ([item[@"subImage"] length] == 0)
        {
            defCell.subImage.hidden = YES;
            defCell.subTitleTrailingConstraint.constant = 0;
        }else
        {
            defCell.subImage.image = [UIImage imageNamed:item[@"subImage"]];
        }
        return defCell;
    }else if ([self.cellName isEqualToString:@"PaidRecordCell"])
    {
        cell = [self.delegate ListView:self cellForEachListItem:cell atIndexPath:indexPath];
        
    }else if ([self.cellName isEqualToString:@"ApplyChargerRecordCell"])
    {
        cell = [self.delegate ListView:self cellForEachListItem:cell atIndexPath:indexPath];
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if ([self.delegate respondsToSelector:@selector(ListView:selectListItem:andClickInfo:)])
    {
        NSDictionary *itemDict = self.listItems[indexPath.row];
        NSString *click_info = itemDict[@"click"] == nil ? @"" : itemDict[@"click"];
        [self.delegate ListView:self selectListItem:cell andClickInfo:click_info];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemDict = self.listItems[indexPath.row];
    if ([itemDict isKindOfClass:[NSDictionary class]] && [itemDict.allKeys containsObject:@"rowHeight"])
    {
        return [itemDict[@"rowHeight"]integerValue];
    }else if (self.rowHeight > 0)
    {
        return self.rowHeight;
    }else
    {
        return 30;
    }
}

-(void)setNotScroll:(BOOL)notScroll
{
    _notScroll = notScroll;
    self.listView.scrollEnabled = !notScroll;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
