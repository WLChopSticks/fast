//
//  WLProfileView.m
//  ckd
//
//  Created by 王磊 on 2018/4/29.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLProfileView.h"
#import "WLPlatform.h"
#import "WLProfileItemsCell.h"

#define IDENFI @"item_cell"

@interface WLProfileView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation WLProfileView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self decorateUI];
    }
    return self;
}

- (void)decorateUI
{
    //后边弧形背景
    UIImageView *iconBackgourndView = [[UIImageView alloc]init];
    iconBackgourndView.image = [UIImage imageNamed:@"bg_me"];
    [self addSubview:iconBackgourndView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_ic_back"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_ic_back_pressed"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backBtnDidClicking:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    //用户名字
    UILabel *userNameLabel = [[UILabel alloc]init];
    [userNameLabel setTextColor:[UIColor whiteColor]];
    userNameLabel.text = @"名字";
    [self addSubview:userNameLabel];
    
    //用户头像
    UIButton *userImageBtn = [[UIButton alloc]init];
    [userImageBtn setImage:[UIImage imageNamed:@"me_defaultavatar"] forState:UIControlStateNormal];
    [userImageBtn addTarget:self action:@selector(userImageBtnDidClicking:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:userImageBtn];
    
    //选项列表
    UITableView *itemsView = [[UITableView alloc]init];
    itemsView.bounces = NO;
    itemsView.backgroundColor = [UIColor clearColor];
    itemsView.dataSource = self;
    itemsView.delegate = self;
    [self addSubview:itemsView];
    
    //布局
    [iconBackgourndView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(self.mas_height).multipliedBy(0.25);
    }];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(Margin * 1.5);
        make.left.equalTo(self.mas_left).offset(Margin);
        make.width.height.mas_equalTo(30);
    }];
    
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(backBtn.mas_bottom);
    }];
    
    [userImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(userNameLabel.mas_bottom).offset(Margin * 2);
        make.width.height.mas_equalTo(80);
    }];
    
    [itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconBackgourndView.mas_bottom).offset(Margin * 5);
        make.left.right.bottom.equalTo(self);
    }];
    
}

- (void)backBtnDidClicking: (UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(ProfileView:backBtnDidClicking:)])
    {
        [self.delegate ProfileView:self backBtnDidClicking:sender];
    }
    NSLog(@"back按了");
}

- (void)userImageBtnDidClicking: (UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(ProfileView:userImageBtnDidClicking:)])
    {
        [self.delegate ProfileView:self userImageBtnDidClicking:sender];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsArr[section]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WLProfileItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENFI];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WLProfileItemsCell" owner:self options:nil]lastObject];
    }
    NSArray *items = self.itemsArr[indexPath.section];
    NSDictionary *itemDict = items[indexPath.row];
    if (itemDict)
    {
        cell.itemIcon.image = [UIImage imageNamed:[itemDict objectForKey:@"itemIcon"]];
        cell.itemName.text = [itemDict objectForKey:@"itemName"];
        cell.itemRemark.text = [itemDict objectForKey:@"itemRemark"];
        cell.itemArrow.image = [UIImage imageNamed:[itemDict objectForKey:@"itemArrow"]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items = self.itemsArr[indexPath.section];
    NSDictionary *itemDict = items[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(ProfileView:itemTableView:didSelectItem:)])
    {
        [self.delegate ProfileView:self itemTableView:tableView didSelectItem:itemDict];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        seperateView.backgroundColor = [UIColor clearColor];
        return seperateView;
    }
    else
    {
        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 0)];
        return seperateView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
