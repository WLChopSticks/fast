//
//  WLBankCardListViewController.m
//  ckd
//
//  Created by 王磊 on 2018/9/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLBankCardListViewController.h"
#import "WLMyExistingBankCardModel.h"
#import "WLMyBankCardCell.h"
#import "WLAddBankCardViewController.h"

#define MyBankCardCell @"MyBankCardCell"

@interface WLBankCardListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *myBankCardList;

@end

@implementation WLBankCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的银行卡";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //每次进入页面都要请求一次当前绑定的银行卡
    [self queryExistingBankCard];
}

- (void)queryExistingBankCard
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *para_String = [NSString stringWithFormat:@"{user_id:%@}",[WLUtilities getUserID]];
    [parameters setObject:para_String forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"AquireExistingBankCard"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        WLMyExistingBankCardModel *model = [[WLMyExistingBankCardModel alloc]init];
        model = [WLMyExistingBankCardModel getMyExistingBankCardModel: result];
        if ([model.code isEqualToString:@"1"])
        {
            NSLog(@"查询我的银行卡成功");
            self.myBankCardList = model.data;
            [self showMyBankCardView];

        }else
        {
            [ProgressHUD showError:model.message];
            NSLog(@"查询我的银行卡失败");
            self.myBankCardList = nil;
        }
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"查询银行卡失败"];
        self.myBankCardList = nil;
    }];
}

- (void)showMyBankCardView
{
    if (self.myBankCardList.count > 0)
    {
        UITableView *myBankCardList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        myBankCardList.dataSource = self;
        myBankCardList.delegate = self;
        myBankCardList.estimatedRowHeight = 40;
        myBankCardList.rowHeight = UITableViewAutomaticDimension;
        myBankCardList.separatorInset = UIEdgeInsetsZero;
        //没有内容时不显示分割线
        myBankCardList.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:myBankCardList];
        
        [myBankCardList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.view);
        }];
        
        [myBankCardList registerNib:[UINib nibWithNibName:@"WLMyBankCardCell" bundle:nil] forCellReuseIdentifier:MyBankCardCell];
    }else
    {
        [self showAddBankCardBtn];
    }
    
}

- (void)showAddBankCardBtn
{
    UIButton *addBankCardBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [addBankCardBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
    [addBankCardBtn setBackgroundImage:[UIImage imageNamed:@"btn_orange"] forState:UIControlStateNormal];
    addBankCardBtn.layer.cornerRadius = 8;
    addBankCardBtn.layer.masksToBounds = YES;
    [self.view addSubview:addBankCardBtn];
    
    [addBankCardBtn addTarget:self action:@selector(addBankCardBtnDidClicking) forControlEvents:UIControlEventTouchUpInside];
    
    [addBankCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(Margin);
        make.right.equalTo(self.view.mas_right).offset(-Margin);
        make.bottom.equalTo(self.view.mas_bottom).offset(-Margin);
        make.height.mas_equalTo(45);
    }];
}

- (void)addBankCardBtnDidClicking
{
    [self jumpToBankCardDetailPage:-1];
}

#pragma --mark tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myBankCardList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WLMyBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:MyBankCardCell forIndexPath:indexPath];
    WLBankCardModel *model = self.myBankCardList[indexPath.row];
    cell.bankName.text = model.yhmc;
    cell.bankCardNumber.text = model.yhkh;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self jumpToBankCardDetailPage:indexPath.row];
}

- (void)jumpToBankCardDetailPage: (NSInteger)index
{
    WLAddBankCardViewController *vc = [[WLAddBankCardViewController alloc]init];
    //index为-1时, 则为新增银行卡
    if (index < 0)
    {
        vc.bankCardInfo = nil;
        vc.defaultCardPara = self.myBankCardList.count == 0 ? @"0" : @"1";
    }else
    {
        WLBankCardModel *model = self.myBankCardList[index];
        vc.bankCardInfo = model;
        vc.defaultCardPara = model.sfmr;
    }
    [self.navigationController pushViewController:vc animated:YES];
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
