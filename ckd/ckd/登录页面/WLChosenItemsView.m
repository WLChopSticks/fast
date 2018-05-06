//
//  WLChosenItemsView.m
//  ckd
//
//  Created by 王磊 on 2018/5/6.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLChosenItemsView.h"
#import <Masonry.h>
#import "WLChargerStationModel.h"

#define Cell_ID @"cityName"
#define Cell_Height_Citylist 45

@interface WLChosenItemsView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UIView *backView;

@end

@implementation WLChosenItemsView

- (instancetype)initWithFrame:(CGRect)frame andChosenItems: (NSArray *)chosenItems
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.chosenItems = chosenItems;
        
        UIView *backView = [[UIView alloc]init];
        self.backView = backView;
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.5;
        [self addSubview:backView];
        
        UITableView *listView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        listView.delegate = self;
        listView.dataSource = self;
        [self addSubview:listView];
        [listView registerClass:[UITableViewCell class] forCellReuseIdentifier:Cell_ID];
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
        
        [listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(Cell_Height_Citylist * self.chosenItems.count);
        }];
    }
    return self;
}

#pragma --mark tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chosenItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_ID forIndexPath:indexPath];
    id item = self.chosenItems[indexPath.row];
    if ([item isKindOfClass:[WLCityData class]])
    {
        WLCityData *model = (WLCityData *)item;
        cell.textLabel.text = model.csmc;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.hidden = YES;
    self.backView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(chosenView:didSelectItemInListView:)])
    {
        [self.delegate chosenView:self didSelectItemInListView:self.chosenItems[indexPath.row]];
    }
    [tableView removeFromSuperview];
    [self.backView removeFromSuperview];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Cell_Height_Citylist;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
