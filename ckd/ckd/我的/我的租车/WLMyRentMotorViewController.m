//
//  WLMyRentMotorViewController.m
//  ckd
//
//  Created by wanglei on 2018/7/17.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLMyRentMotorViewController.h"
#import "WLRentRecordViewCell.h"
#import "WLRentMotorRecordModel.h"
#import "WLRecordEmptyView.h"

#define cellID @"rent_motor_record"

@interface WLMyRentMotorViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *recordListView;
@property (nonatomic, strong) NSArray *recordArr;

@end

@implementation WLMyRentMotorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的租车记录";
    
    if (![WLUtilities isUserLogin])
    {
        [self showEmptyRecordView];
        
    }else
    {
        [self queryRentMotorRecord];
    }
}

//租车记录查询
- (void)queryRentMotorRecord
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *para_String = [NSString stringWithFormat:@"{user_id:%@}",[WLUtilities getUserID]];
    [parameters setObject:para_String forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"AquireExchangeRentMotorRecord"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
//        WLRentMotorRecordDetailModel *model = [[WLRentMotorRecordDetailModel alloc]init];
        WLRentMotorRecordModel *model = [WLRentMotorRecordModel getRentModelRecordModel:result];
        if ([model.code isEqualToString:@"1"])
        {
            NSLog(@"查询换电记录成功");
            self.recordArr = model.data;
            [self showApplyChargerRecordList];
        }else
        {
            [ProgressHUD showError:@"查询换电记录失败"];
            NSLog(@"查询换电记录失败");
            self.recordArr = nil;
            [self showEmptyRecordView];
        }
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"查询换电记录失败"];
        NSLog(@"查询换电记录失败");
        NSLog(@"%@",error);
        self.recordArr = nil;
        [self showEmptyRecordView];
    }];
}

- (void)showApplyChargerRecordList
{
//    if (self.recordArr.count > 0)
//    {
//        WLListView *recordListView = [[WLListView alloc]initWithFrame:self.view.bounds];
//        recordListView.delegate = self;
//        recordListView.listItems = self.recordArr;
//        recordListView.cellName = @"ApplyChargerRecordCell";
//        recordListView.rowHeight = 170;
//        [self.view addSubview:recordListView];
        UITableView *recordListView = [[UITableView alloc]initWithFrame:self.view.bounds];
        self.recordListView = recordListView;
        recordListView.delegate = self;
        recordListView.dataSource = self;
        [self.view addSubview:recordListView];
        
//    }else
//    {
//        [self showEmptyRecordView];
//    }
}

- (void)showEmptyRecordView
{
    WLRecordEmptyView *emptyView = [[WLRecordEmptyView alloc]initWithFrame:Screen_Bounds];
    [self.view addSubview:emptyView];
}


#pragma --mark tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WLRentMotorRecordDetailModel *model = self.recordArr[indexPath.row];
    
    WLRentRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[WLRentRecordViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID andLines:[self getRentRocordListCellLines:model.scbs]];
    }
    cell.motorNoLabel.text = @"电动车编号:";
    cell.motorNo.text = model.ddcdm;
    if ([model.scbs isEqualToString:@"0"])
    {
        cell.timeLabel.text = @"关锁时间:";
    }else if ([model.scbs isEqualToString:@"1"])
    {
        cell.timeLabel.text = @"开锁时间:";
    }else
    {
        cell.timeLabel.text = @"租车时间:";
        cell.subTimeLabel.text = @"还车时间:";
        cell.subTime.text = model.ghsj;
    }
    cell.time.text = model.jqsj;

    
    return cell;
}

- (NSInteger)getRentRocordListCellLines: (NSString *)ID
{
    if ([ID isEqualToString:@"0"])
    {
        return 2;
    }else if ([ID isEqualToString:@"1"])
    {
        return 2;
    }else
    {
        return 3;
    }
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
