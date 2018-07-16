//
//  WLMyApplyChargerRecordViewController.m
//  ckd
//
//  Created by wanglei on 2018/5/3.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLMyApplyChargerRecordViewController.h"
#import "WLPlatform.h"
#import "WLChargerRecord.h"
#import "WLApplyChargerRecordCellTableViewCell.h"
#import "WLRecordEmptyView.h"
#import "WLListView.h"

@interface WLMyApplyChargerRecordViewController ()<ListViewDelegate,UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *recordArr;

@end

@implementation WLMyApplyChargerRecordViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的换电记录";
    
    if (![WLUtilities isUserLogin])
    {
        [self showEmptyRecordView];
        
    }else
    {
        [self queryChargerRecord];
    }
   
    
}


//换电记录查询
- (void)queryChargerRecord
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *para_String = [NSString stringWithFormat:@"{user_id:%@}",[WLUtilities getUserID]];
    [parameters setObject:para_String forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"AquireExchangeChargerRecord"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        WLChargerRecord *chargerRecordModel = [[WLChargerRecord alloc]init];
        chargerRecordModel = [WLChargerRecord getChargerRecordModel:result];
        if ([chargerRecordModel.code isEqualToString:@"1"])
        {
            NSLog(@"查询换电记录成功");
            self.recordArr = chargerRecordModel.data;
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
    if (self.recordArr.count > 0)
    {
        WLListView *recordListView = [[WLListView alloc]initWithFrame:self.view.bounds];
        recordListView.delegate = self;
        recordListView.listItems = self.recordArr;
        recordListView.cellName = @"ApplyChargerRecordCell";
        recordListView.rowHeight = 170;
        [self.view addSubview:recordListView];
        
    }else
    {
        [self showEmptyRecordView];
    }    
}

- (void)showEmptyRecordView
{
    WLRecordEmptyView *emptyView = [[WLRecordEmptyView alloc]initWithFrame:Screen_Bounds];
    [self.view addSubview:emptyView];
}


#pragma --mark tableView delegate
-(UITableViewCell *)ListView:(WLListView *)view cellForEachListItem:(UITableViewCell *)originalCell atIndexPath:(NSIndexPath *)indexPath
{
    WLApplyChargerRecordCellTableViewCell *cell = (WLApplyChargerRecordCellTableViewCell *)originalCell;
    WLChargerRecordListModel *model = self.recordArr[indexPath.section];
    cell.chargerNumber.text = model.dcdm;
    cell.getStationName.text = model.qjgmc;
    cell.returnStationName.text = model.fjgmc;
    cell.getTime.text = model.jqsj;
    cell.returnTime.text = model.ghsj;
    cell.lineView.backgroundColor = [UIColor colorWithRed:255/255.0 green:93/255.0 blue:67/255.0 alpha:1.0];
    
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
