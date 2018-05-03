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

@interface WLMyApplyChargerRecordViewController ()<UITableViewDelegate, UITableViewDataSource>

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
    NSString *URL = @"http://47.104.85.148:18070/ckdhd/Hdcjl.action";
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        [ProgressHUD dismiss];
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
    UITableView *recordListView = [[UITableView alloc]init];
    recordListView.delegate = self;
    recordListView.dataSource = self;
    [self.view addSubview:recordListView];
    recordListView.backgroundColor = [UIColor whiteColor];
    
    [recordListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    
}

- (void)showEmptyRecordView
{
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:Screen_Bounds];
    [self.view addSubview:backImageView];
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"空空如也, 啥也没有";
    tipLabel.textColor = LightGrayStyle;
    [self.view addSubview:tipLabel];
    backImageView.image = [UIImage imageNamed:@"no_product"];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.height.mas_equalTo(100);
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_bottom).offset(5);
        make.centerX.equalTo(backImageView.mas_centerX);
    }];
}


#pragma --mark tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.recordArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WLApplyChargerRecordCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WLApplyChargerRecordCellTableViewCell" owner:self options:nil]lastObject];
    }
    WLChargerRecordListModel *model = self.recordArr[indexPath.section];
    cell.chargerNumber.text = model.dcdm;
    cell.stationName.text = model.zdmc;
    cell.getTime.text = model.jqsj;
    cell.returnTime.text = model.ghsj;
    cell.backgroundColor = LightGrayBackground;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]init];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
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
