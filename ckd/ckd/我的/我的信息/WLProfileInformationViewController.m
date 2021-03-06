//
//  WLProfileInformationViewController.m
//  ckd
//
//  Created by 王磊 on 2018/5/5.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLProfileInformationViewController.h"
#import "WLQingLoginModel.h"
#import "WLChangeTelephoneNumberViewController.h"
#import "WLPlatform.h"
#import "WLChargerStationModel.h"
#import "WLChosenItemsView.h"
#import "WLCertificationController.h"
#import "WLScanBitCodeViewController.h"
#import "WLBankCardListViewController.h"

@interface WLProfileInformationViewController ()<chosenViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ID_numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UIView *telephoneView;
@property (weak, nonatomic) IBOutlet UIView *bankCardView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIView *cityView;

@property (nonatomic, strong) NSArray *cityList;
@property (nonatomic, strong) WLCityData *currentCity;
@property (nonatomic, strong) WLQingLoginModel *qingLoginModel;
@property (weak, nonatomic) IBOutlet UILabel *borrowCharger;
@property (weak, nonatomic) IBOutlet UIButton *returnChargerBtn;
@property (weak, nonatomic) IBOutlet UILabel *rentMotor;
@property (weak, nonatomic) IBOutlet UIButton *returnMotorBtn;


@end

@implementation WLProfileInformationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的信息";
    [WLCommonTool makeViewShowingWithRoundCorner:self.returnChargerBtn andRadius:Btn_Radius];
    [WLCommonTool makeViewShowingWithRoundCorner:self.returnMotorBtn andRadius:Btn_Radius];
    
    //选项添加点击事件
    [self addViewGestures];
    //如果没有租电池, 则退电池按钮是隐藏的
    self.returnChargerBtn.hidden = YES;
    //如果没有租电动车, 则还车按钮是隐藏的
    self.returnMotorBtn.hidden = YES;
    
    //请求个人详细信息
    [self queryProfileInfo];
   
}

- (void)addViewGestures
{
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(telephoneItemDidClicking)];
    [self.telephoneView addGestureRecognizer:tapGesture1];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bankCardItemDidClicking)];
    [self.bankCardView addGestureRecognizer:tapGesture2];
    //城市目前不支持更换
//    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cityItemDidClicking)];
//    [self.cityView addGestureRecognizer:tapGesture2];
}

- (void)queryProfileInfo
{
    [ProgressHUD show];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *parametersStr = [NSString stringWithFormat:@"{user_id:%@}",[WLUtilities getUserID]];
    [parameters setObject:parametersStr forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"QingLogin"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSDictionary *result = (NSDictionary *)responseObject;
        WLQingLoginModel *model = [WLQingLoginModel getQingLoginModel:result];
        self.qingLoginModel = model;
        if ([model.code integerValue] == 1)
        {
            NSLog(@"获取个人信息成功");
            [self showProfileInfoDetails:model];
        }else
        {
            NSLog(@"获取个人信息失败");
            [ProgressHUD showError:model.message];
        }
    } failure:^(NSError *error) {
        NSLog(@"获取个人信息失败");
        NSLog(@"%@",error);
        [ProgressHUD showError:@"获取个人信息失败"];
    }];
}

- (void)showProfileInfoDetails: (WLQingLoginModel *)model
{
    self.nameLabel.text = model.data.user_realname;
    self.ID_numberLabel.text = model.data.idcard;
    self.telephoneLabel.text = model.data.user_phone;
    self.cityLabel.text = model.data.csmc;
    self.borrowCharger.text = model.data.dcdm;
    if (self.borrowCharger.text.length > 0)
    {
        self.returnChargerBtn.hidden = NO;
    }else
    {
        self.returnChargerBtn.hidden = YES;
    }
    self.rentMotor.text = model.data.ddcdm;
    if (self.rentMotor.text.length > 0)
    {
        self.returnMotorBtn.hidden = NO;
    }else
    {
        self.returnMotorBtn.hidden = YES;
    }
}

- (void)telephoneItemDidClicking
{
    NSLog(@"电话号码点击了");
    WLChangeTelephoneNumberViewController *changeTelNumberVC = [[WLChangeTelephoneNumberViewController alloc]init];
    [self.navigationController pushViewController:changeTelNumberVC animated:YES];
}

- (void)bankCardItemDidClicking
{
    NSLog(@"我的银行卡点击了");
    WLBankCardListViewController *myBankCardVC = [[WLBankCardListViewController alloc]init];
    [self.navigationController pushViewController:myBankCardVC animated:YES];
}

- (void)cityItemDidClicking
{
    NSLog(@"城市选项点击了");
    [ProgressHUD show];
    [[WLCommonAPI sharedCommonAPIManager]aquireCityList:^(id result) {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *resultDict = (NSDictionary *)result;
            WLChargerStationModel *chargerStationModel = [[WLChargerStationModel alloc]init];
            chargerStationModel = [chargerStationModel getChargerStationModel:resultDict];
            if ([chargerStationModel.code isEqualToString:@"1"])
            {
                NSLog(@"查询城市信息成功");
                self.cityList= chargerStationModel.data;
                [ProgressHUD dismiss];
                [self createCityListView];
            }else
            {
                NSLog(@"查询城市信息失败");
                [ProgressHUD showError:@"请求城市列表失败"];
            }
        }else
        {
            NSLog(@"请求城市列表失败");
            [ProgressHUD showError:@"请求城市列表失败"];
        }
    }];
}

- (void)createCityListView
{
    WLChosenItemsView *cityListView = [[WLChosenItemsView alloc]initWithFrame:Screen_Bounds andChosenItems:self.cityList];
    cityListView.delegate = self;
    [self.view addSubview:cityListView];
}

#pragma --mark cityListView delegate
-(void)chosenView:(WLChosenItemsView *)view didSelectItemInListView:(id)item
{
    WLCityData *model = (WLCityData *)item;

    NSLog(@"选择了城市%@",model.csmc);
    
    
    NSString *promptStr = [NSString stringWithFormat:@"确定要将您的位置切换到 %@",model.csmc];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:promptStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self queryChangeCurrentCity:model];
    }];
    
    // Add the actions.
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)queryChangeCurrentCity: (WLCityData *)model
{
    [ProgressHUD show];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *user_phone_string = [NSString stringWithFormat:@"{user_id:%@,area_id:%@,user_realname:%@}",[WLUtilities getUserID],model.csdm, self.qingLoginModel.data.user_realname];
    [parameters setObject:user_phone_string forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"CompletePrivateInformation"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqualToString:@"1"])
        {
            NSLog(@"切换城市成功");
            self.cityLabel.text = model.csmc;
            self.currentCity = model;
            [ProgressHUD showSuccess:[NSString stringWithFormat:@"切换城市成功"]];
            [WLUtilities saveCurrentCityCode:model.csdm andCityName:model.csmc];
        }
        else
        {
            NSLog(@"切换城市失败");
            [ProgressHUD showError:[NSString stringWithFormat:@"切换城市失败"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"切换城市失败");
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error.description]];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)returnChargerBtnDidClicking:(id)sender
{
    NSLog(@"退电池点击了");
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要退电池吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        WLScanBitCodeViewController *scanBitCodeVC = [[WLScanBitCodeViewController alloc]init];
        scanBitCodeVC.action = Return_Charger;
        [self.navigationController pushViewController:scanBitCodeVC animated:YES];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (IBAction)returnMotorBtnDidClicking:(id)sender
{
    NSLog(@"还车点击了");
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要还车了吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *motorCode = [WLUserInfoMaintainance sharedMaintain].model.data.ddcdm;
        [[WLCommonAPI sharedCommonAPIManager]queryAquireChargerWithCode:motorCode andActionType:@"4" success:^(id _Nullable responseObject) {
            NSDictionary *response = (NSDictionary *)responseObject;
            NSString *message = response[@"message"];
            if ([message containsString:@"还车成功"])
            {
                [self queryProfileInfo];
            }
            [ProgressHUD show:response[@"message"]];
            //此方法默认不会消失, 此处延迟2秒后消失
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD dismiss];
            });
        } failure:^(NSError *error) {
            [ProgressHUD showError:@"还车失败"];
        }];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
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
