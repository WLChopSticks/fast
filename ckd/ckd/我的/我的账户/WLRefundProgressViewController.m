//
//  WLRefundProgressViewController.m
//  ckd
//
//  Created by 王磊 on 2018/9/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLRefundProgressViewController.h"
#import "WLRefundProgressCell.h"
#import "WLRefundProgressModel.h"

#define RefundProgressCell @"RefundProgressCell"
@interface WLRefundProgressViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation WLRefundProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"退款进度";
    [self initialiseView];
}

- (void)initialiseView
{
    UILabel *caption = [[UILabel alloc]init];
    caption.text = @"退款进度";
    caption.textColor = [UIColor grayColor];
    [self.view addSubview:caption];
    
    [caption mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
    }];
    
    UITableView *progressList = [[UITableView alloc]init];
    progressList.dataSource = self;
    progressList.delegate = self;
    progressList.estimatedRowHeight = 40;
    progressList.rowHeight = UITableViewAutomaticDimension;
    progressList.separatorStyle = UITableViewCellSeparatorStyleNone;
    progressList.backgroundColor = [UIColor whiteColor];
    progressList.scrollEnabled = NO;
    [self.view addSubview:progressList];
    
    [progressList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caption.mas_bottom).offset(20);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [progressList registerNib:[UINib nibWithNibName:@"WLRefundProgressCell" bundle:nil] forCellReuseIdentifier:RefundProgressCell];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.progressList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WLRefundProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:RefundProgressCell forIndexPath:indexPath];
    WLRefundProgressDetailModel *model = self.progressList[indexPath.row];
    cell.progressState.text = [self changeStateCodeToWord:model.thzt andrefundMoney:model.thje];
    if (![cell.progressState.text isEqualToString:@"审核中"])
    {
        cell.date.text = model.thsj;
    }
    if ([cell.progressState.text containsString:@"未通过"])
    {
        cell.isTickSymbol = NO;
    }else
    {
        cell.isTickSymbol = YES;
    }
    cell.backgroundColor = [UIColor clearColor];
    //最后一个cell需要隐藏竖线的图片
    if (indexPath.row == self.progressList.count -1 )
    {
        cell.progressLine.hidden = YES;
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];
    header.backgroundColor = [UIColor whiteColor];
    return header;
}

- (NSString *)changeStateCodeToWord: (NSString *)stateCode andrefundMoney: (NSString *)money
{
    if ([stateCode isEqualToString:@"0"])
    {
        return @"退还申请";
    }else if ([stateCode isEqualToString:@"2"])
    {
        return @"审核中";
    }else if ([stateCode isEqualToString:@"3"])
    {
        return @"审核中";
    }else if ([stateCode isEqualToString:@"1"])
    {
        return [NSString stringWithFormat:@"已退款: %@元",money];
    }else if ([stateCode isEqualToString:@"4"])
    {
        return @"审核未通过";
    }
    return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
