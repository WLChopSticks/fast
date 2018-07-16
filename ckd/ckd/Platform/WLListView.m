//
//  WLListView.m
//  ckd
//
//  Created by wanglei on 2018/7/16.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLListView.h"
#import "WLDefaultCell.h"
#import <Masonry.h>

@interface WLListView()<UITableViewDataSource, UITableViewDelegate>


@end

@implementation WLListView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UITableView *listView = [[UITableView alloc]initWithFrame:self.bounds];
        listView.delegate = self;
        listView.dataSource = self;
        if (!self.scrollEnable)
        {
            listView.scrollEnabled = NO;
        }
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
        if ([self.cellName isEqualToString:@""])
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellName];
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
    NSString *rowHeight = itemDict[@"rowHeight"] == nil ? @"30": itemDict[@"rowHeight"];
    return rowHeight.integerValue;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
