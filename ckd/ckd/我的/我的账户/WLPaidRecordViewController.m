//
//  WLPaidRecordViewController.m
//  ckd
//
//  Created by 王磊 on 2018/5/6.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLPaidRecordViewController.h"
#import "WLRecordEmptyView.h"
#import "WLPlatform.h"
#import "WLPaidRecordModel.h"
#import "WLPaidRecordCell.h"
#import "WLListView.h"

@interface WLPaidRecordViewController ()<ListViewDelegate>

@property (nonatomic, strong) NSArray *paidList;

@end

@implementation WLPaidRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"缴费记录";
    
    if ([WLUtilities isUserLogin])
    {
        [self queryPaidRecordDetail];
    }else
    {
        [self showEmptyRecordView];
    }
    
}

- (void)queryPaidRecordDetail
{
    [ProgressHUD show];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *parametersStr = [NSString stringWithFormat:@"{user_id:%@}",[WLUtilities getUserID]];
    [parameters setObject:parametersStr forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"AquirePaidRecordList"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        WLPaidRecordModel *model = [WLPaidRecordModel getPaidRecordModel:result];
        [ProgressHUD dismiss];
        if ([model.code integerValue] == 1)
        {
            NSLog(@"获取缴费记录成功");
            self.paidList = model.data;
            if (self.paidList.count > 0)
            {
                [self showPaidRecordView];
            }else
            {
                [self showEmptyRecordView];
            }
        }else
        {
            NSLog(@"获取缴费记录失败");
            [ProgressHUD showError:model.message];
            [self showEmptyRecordView];
        }
    } failure:^(NSError *error) {
        NSLog(@"获取缴费记录失败");
        NSLog(@"%@",error);
        [ProgressHUD showError:@"获取缴费记录失败"];
        [self showEmptyRecordView];
    }];
}

- (void)showPaidRecordView
{
    WLListView *listView = [[WLListView alloc]initWithFrame:Screen_Bounds];
    listView.listItems = self.paidList;
    listView.cellName = @"PaidRecordCell";
    listView.delegate = self;
    listView.rowHeight = 150;
    [self.view addSubview:listView];
}

- (void)showEmptyRecordView
{
    WLRecordEmptyView *emptyView = [[WLRecordEmptyView alloc]initWithFrame:Screen_Bounds];
    [self.view addSubview:emptyView];
}

#pragma --mark tableview delegate
-(UITableViewCell *)ListView:(WLListView *)view cellForEachListItem:(UITableViewCell *)originalCell atIndexPath:(NSIndexPath *)indexPath
{
    WLPaidRecordCell *cell = (WLPaidRecordCell *)originalCell;
    WLPaidRecordDetailModel *model = self.paidList[indexPath.row];
    cell.order_idLabel.text = model.orderid;
    cell.priceDetaiLabel.text = model.fxqmc;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@ 元",model.fyje];
    cell.paidTimeLabel.text = model.jfsj;
    
    return cell;
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
