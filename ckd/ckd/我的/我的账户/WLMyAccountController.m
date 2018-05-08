//
//  WLMyAccountController.m
//  ckd
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLMyAccountController.h"
#import "WLWePay.h"
#import "WLPaidRecordViewController.h"
#import "WLUserInfoMaintainance.h"

//轮询次数, 间隔为2s
#define Repeat_Query_Count 5

@interface WLMyAccountController ()
@property (weak, nonatomic) IBOutlet UIView *name;
@property (weak, nonatomic) IBOutlet UILabel *rentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *depositPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *paidMonthCardBtn;
@property (weak, nonatomic) IBOutlet UIButton *paidDepositBtn;

@property (nonatomic, assign) NSInteger queryCount;
@property (nonatomic, assign) Paid_Type paidType;

@end

@implementation WLMyAccountController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
    
    //每次都要检查用户是否缴纳了押金与租金
    [self checkUserPaidStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的账户";
    [WLCommonTool makeViewShowingWithRoundCorner:self.paidDepositBtn andRadius:Btn_Radius];
    [WLCommonTool makeViewShowingWithRoundCorner:self.paidMonthCardBtn andRadius:Btn_Radius];

    
    [self decorateNavigationBar];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)decorateNavigationBar
{
    UIBarButtonItem *paidRecord = [[UIBarButtonItem alloc]initWithTitle:@"缴费记录" style:UIBarButtonItemStylePlain target:self action:@selector(paidRecordDidClicking)];
    self.navigationItem.rightBarButtonItem = paidRecord;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)checkUserPaidStatus
{
    WLUserInfoMaintainance *userInfo = [WLUserInfoMaintainance sharedMaintain];
    //如果APP还没有请求过个人数据, 需要再请求一次
    if (userInfo.model == nil)
    {
        [ProgressHUD show];
        [userInfo queryUserInfo:^(NSNumber *result) {
            [ProgressHUD dismiss];
            [self checkUserPaidStatus];
        }];
        return;
    }
    //查看是否交押金
    if (userInfo.model.data.yj.integerValue)
    {
        for (WLUserPaidListModel *model in userInfo.model.data.list1)
        {
            //押金
            if ([model.fylxdm isEqualToString:@"1"])
            {
                self.depositPriceLabel.text = [NSString stringWithFormat:@"%@ 元",model.fyje];
                [self.paidDepositBtn setTitle:@"退押金" forState:UIControlStateNormal];
                break;
            }
        }
    }else
    {
        [self changeCellStatusToUnpaidDeposit];
    }
    
    //查看是否交租金
    if (userInfo.model.data.zj.integerValue)
    {
        for (WLUserExpireTimeModel *model in userInfo.model.data.list)
        {
            //押金
            if ([model.fylxdm isEqualToString:@"2"])
            {
                self.rentTimeLabel.text = model.jssj;
                break;
            }
        }
    }else
    {
        self.rentTimeLabel.text = @"未缴纳租金";
    }
}

- (void)paidRecordDidClicking
{
    NSLog(@"缴费记录按钮点击了");
    WLPaidRecordViewController *paidRecordVC = [[WLPaidRecordViewController alloc]init];
    [self.navigationController pushViewController:paidRecordVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)extendMonthTimeBtnDidClicking:(id)sender
{
    NSLog(@"立即续费按钮点击了");
    //未缴纳押金需要先交押金
    WLUserInfoMaintainance *userInfo = [WLUserInfoMaintainance sharedMaintain];
    if (!userInfo.model.data.yj.integerValue)
    {
        [ProgressHUD showError:@"请先缴纳押金"];
    }else
    {
        self.paidType = Paid_Rent;
        [[WLWePay sharedWePay]createWePayRequestWithPriceType:Charger andPriceTypeCode:RentPrice andPriceDetailCode:ChargerRent];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wePayFinishProcess:) name:WePayResponseNotification object:nil];
    }
}
- (IBAction)PaidDepositBtnDidClicking:(id)sender
{
    WLUserInfoMaintainance *userInfo = [WLUserInfoMaintainance sharedMaintain];
    if (userInfo.model.data.yj.integerValue)
    {
        //退押金
        [self queryReturnDeposit];
    }else
    {
        //交押金
        self.paidType = Paid_Deposit;
        [[WLWePay sharedWePay]createWePayRequestWithPriceType:Charger andPriceTypeCode:DepositPrice andPriceDetailCode:ChargerDeposit];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wePayFinishProcess:) name:WePayResponseNotification object:nil];
    }
    NSLog(@"缴纳/退押金按钮点击了");
}

- (void)queryReturnDeposit
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    WLUserInfoMaintainance *userInfo = [WLUserInfoMaintainance sharedMaintain];
    NSArray *expireTimeArr = userInfo.model.data.list;
    //获取流水号
    NSString *serialNumber;
    for (WLUserExpireTimeModel *model in expireTimeArr)
    {
        if ([model.fylxdm isEqualToString:@"1"])
        {
            serialNumber = model.lsh;
            break;
        }
    }
    //获取费用详情代码
    NSString *priceDetailCode;
    for (WLUserPaidListModel *model in userInfo.model.data.list1)
    {
        if ([model.fylxdm isEqualToString:@"1"])
        {
            priceDetailCode = model.fyxqdm;
            break;
        }
    }
    NSString *parametersStr = [NSString stringWithFormat:@"{bljl_lsh:%@,user_id:%@,fyxqdm:%@}",serialNumber, [WLUtilities getUserID], priceDetailCode];
    [parameters setObject:parametersStr forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"ReturnDeposit"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if ([result[@"code"] integerValue] == 1)
        {
            NSLog(@"退押金成功");
            [ProgressHUD showSuccess:result[@"message"]];
            //轮询 未交押金为字符串0
            self.queryCount = Repeat_Query_Count;
            [self repeatQueryUserDepositStatus:@"0"];
            
        }else
        {
            NSLog(@"退押金失败");
            [ProgressHUD showError:result[@"message"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"退押金失败");
        NSLog(@"%@",error);
        [ProgressHUD showError:@"退押金失败"];
    }];
}

//轮询押金状态
- (void)repeatQueryUserDepositStatus: (NSString *)expectStatus
{
    WLUserInfoMaintainance *userInfo = [WLUserInfoMaintainance sharedMaintain];
    
    if (self.queryCount > 0 && ![userInfo.model.data.yj isEqualToString:expectStatus])
    {
        [[WLUserInfoMaintainance sharedMaintain]queryUserInfo:^(NSNumber *result) {
            [self checkUserPaidStatus];
            if (![userInfo.model.data.yj isEqualToString:expectStatus])
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self repeatQueryUserDepositStatus:expectStatus];
                });
                self.queryCount--;
            }
        }];
    }
    
}

//轮询租金状态
- (void)repeatQueryUserPaidRentStatus: (NSString *)expectStatus
{
    WLUserInfoMaintainance *userInfo = [WLUserInfoMaintainance sharedMaintain];
    
    if (self.queryCount > 0 && ![userInfo.model.data.zj isEqualToString:expectStatus])
    {
        [[WLUserInfoMaintainance sharedMaintain]queryUserInfo:^(NSNumber *result) {
            [self checkUserPaidStatus];
            if (![userInfo.model.data.zj isEqualToString:expectStatus])
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self repeatQueryUserPaidRentStatus:expectStatus];
                });
                self.queryCount--;
            }
        }];
    }
    
}

- (void)wePayFinishProcess: (NSNotification *)notice
{
    NSDictionary *dict = notice.userInfo;
    PaidResult result = [dict[@"result"]integerValue];
    switch (result) {
        case Paid_Success:
        {
            [ProgressHUD showSuccess:@"支付成功"];
            if (self.paidType == Paid_Deposit)
            {
                //轮询 交押金为字符串1
                self.queryCount = Repeat_Query_Count;
                [self repeatQueryUserDepositStatus:@"1"];
            }else if (self.paidType == Paid_Deposit)
            {
                //轮询 交租金为字符串1
                self.queryCount = Repeat_Query_Count;
                [self repeatQueryUserPaidRentStatus:@"1"];
            }
//            [[WLUserInfoMaintainance sharedMaintain]queryUserInfo:^(NSNumber *result) {
//                [self checkUserPaidStatus];
//            }];
//            [self changeCellStatusTopaidDeposit];
            break;
        }
        case Paid_Fail:
        {
            [ProgressHUD showError:@"支付失败"];
            break;
        }
        case Paid_Cancel:
        {
            [ProgressHUD showError:@"用户取消"];
            break;
        }
            
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

- (void)changeCellStatusToUnpaidDeposit
{
    self.depositPriceLabel.text = @"未缴纳押金";
    [self.paidDepositBtn setTitle:@"缴纳押金" forState:UIControlStateNormal];
}
- (void)changeCellStatusTopaidDeposit
{
    self.depositPriceLabel.text = [NSString stringWithFormat:@"%@ 元",[WLUtilities getPaidPrice]];
    [self.paidDepositBtn setTitle:@"退押金" forState:UIControlStateNormal];
}


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
