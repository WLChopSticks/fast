//
//  WLHomeViewController.m
//  ckd
//
//  Created by wanglei on 2018/4/28.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLHomeViewController.h"
#import "WLProfileViewController.h"
#import "WLLoginViewController.h"
#import "WLMapViewController.h"
#import "WLScanBitCodeViewController.h"
#import "WLChargerStationModel.h"
#import "WLEachChargerStationModel.h"
#import "WLCustomerServiceViewController.h"
#import "WLMyAccountController.h"
#import "WLCertificationController.h"
#import "WLUserInfoMaintainance.h"
#import "WLBootViewController.h"

typedef enum : NSUInteger {
    UnRegistRealName,//未实名
    UnPaidDeposit,//未缴纳押金
    UnPaidRent,//未缴纳租金
    Unlogin,//未登录
    Login//登录
} AccountStatus;

@interface WLHomeViewController ()

@property (nonatomic, weak)WLMapViewController *mapVC;
@property (nonatomic, weak) UIView *promptStatusView;
@property (nonatomic, weak) UIButton *lock_unlock_btn;

@end

@implementation WLHomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
    
    //在请求国轻登录接口后, 每次显示页面都要判断是否需要提示用户实名认证交押金交租金
    if ([[WLUserInfoMaintainance sharedMaintain]model] != nil)
    {
        [self decorateUserStatusPromptBar:[self judegeAccountStatus]];
        //确认电动车开锁, 锁车按钮状态
        [self setLockUnlockMotorBtnStatus];
    }
    //如果有别的页面的loading view先消除
    [ProgressHUD dismiss];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //导航栏布局
    [self decorateNavigationBar];
    //地图页面
    [self decorateMapView];
    //功能按钮布局
    [self decorateFunctionsButtons];
    
    //第一次加载home也的请求轻登录接口, 之后在viewWillAppear直接查看数据, 不在请求
    //查看用户账户状态, 是否显示提示bar, 引导用户完善信息
    [[WLUserInfoMaintainance sharedMaintain]queryUserInfo:^(NSNumber *result) {
        if (result.boolValue)
        {
            NSLog(@"获取个人信息成功");
            [self decorateUserStatusPromptBar:[self judegeAccountStatus]];
            //请求充电站的位置节点
            [self aquireChargerStations];
            
        }else
        {
            NSLog(@"获取个人信息失败");
            //查询失败, 退出登录
//            WLLoginViewController *loginVC = [[WLLoginViewController alloc]init];
//            for (UIViewController *vc in self.navigationController.viewControllers)
//            {
//                if ([vc isKindOfClass:[WLBootViewController class]])
//                {
//                    [self.navigationController popToViewController:vc animated:NO];
//                    [vc.navigationController pushViewController:loginVC animated:YES];
//                }
//            }
        }
    }];
}

- (AccountStatus)judegeAccountStatus
{
    if (![WLUtilities isUserLogin])
    {
        return Unlogin;
    }
   
    WLUserInfoMaintainance *userInfo = [WLUserInfoMaintainance sharedMaintain];
    if (userInfo.model.data.ztm.integerValue == 0)
    {
        return UnRegistRealName;
    }
    if (userInfo.model.data.yj.integerValue == 0)
    {
        return UnPaidDeposit;
    }
    if (userInfo.model.data.zj.integerValue == 0)
    {
        return UnPaidRent;
    }
    return Login;
}

- (void)setLockUnlockMotorBtnStatus
{
    WLUserInfoModel *model = [WLUserInfoMaintainance sharedMaintain].model.data;
    if (model.sfddc.integerValue == 0 || model.ddcdm.length == 0)
    {
        self.lock_unlock_btn.hidden = YES;
        return;
    }
    if (model.ddc_lock_type.integerValue == 1)
    {
        self.lock_unlock_btn.selected = YES;
    }else
    {
        self.lock_unlock_btn.selected = NO;
    }
}

- (void)aquireChargerStations
{
    [ProgressHUD show];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    WLUserInfoMaintainance *userInfo = [WLUserInfoMaintainance sharedMaintain];
        NSString *cityCode = [NSString stringWithFormat:@"{csdm:%@}",userInfo.model.data.area_id];
    [parameters setObject:cityCode forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"AquireStationsOfCity"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSDictionary *result = (NSDictionary *)responseObject;
        WLEachChargerStationModel *eachChargerStationModel = [[WLEachChargerStationModel alloc]init];
        eachChargerStationModel = [eachChargerStationModel getEachChargerStationModel:result];
        if ([eachChargerStationModel.code isEqualToString:@"1"])
        {
            NSLog(@"查询城市信息成功");
            self.mapVC.LocationOfStations = eachChargerStationModel.data;
            [self.mapVC getLocationOfStationsInCurrentCity];
        }else
        {
            [ProgressHUD showError:@"查询城市信息失败"];
            NSLog(@"查询城市信息失败");
        }
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"查询城市信息失败"];
        NSLog(@"查询城市信息失败");
        NSLog(@"%@",error);
    }];
}

- (void)decorateNavigationBar
{
    self.title = @"诚快达换电";
    
    UIImage *profileImage = [[UIImage imageNamed:@"nav_defaultavatar"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *profileBtn = [[UIBarButtonItem alloc]initWithImage:profileImage style:UIBarButtonItemStylePlain target:self action:@selector(profileBtnDidClicking)];
    self.navigationItem.leftBarButtonItem = profileBtn;
}

- (void)decorateMapView
{
    WLMapViewController *mapVC = [[WLMapViewController alloc]init];
    self.mapVC = mapVC;
    mapVC.view.frame = Screen_Bounds;
    mapVC.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:mapVC.view];
    [self addChildViewController:mapVC];
}

- (void)decorateFunctionsButtons
{
    UIButton *refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    [refreshBtn setImage:[UIImage imageNamed:@"home_ic_refresh"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshBtnDidClicking) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn];
    
    UIButton *mapBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    [mapBtn setImage:[UIImage imageNamed:@"home_ic_map"] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(mapBtnDidClicking:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapBtn];
    
    UIButton *lock_unlockBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.lock_unlock_btn = lock_unlockBtn;
    [lock_unlockBtn setImage:[UIImage imageNamed:@"YS"] forState:UIControlStateNormal];
    [lock_unlockBtn setImage:[UIImage imageNamed:@"YK"] forState:UIControlStateSelected];
    [lock_unlockBtn addTarget:self action:@selector(lockUnlockBtnDidClicking:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lock_unlockBtn];
    
    UIButton *serviceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    [serviceBtn setImage:[UIImage imageNamed:@"home_ic_service"] forState:UIControlStateNormal];
    [serviceBtn addTarget:self action:@selector(serviceBtnDidClicking) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:serviceBtn];

    UIButton *iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
//    [iconBtn setImage:[UIImage imageNamed:@"icon_code"] forState:UIControlStateNormal];
    [iconBtn setBackgroundImage:[UIImage imageNamed:@"icon_code"] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(iconBtnDidClicking) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:iconBtn];
    
    UILabel *introductionLabel = [[UILabel alloc]init];
    introductionLabel.text = @"换电/租车";
    introductionLabel.textColor = [UIColor whiteColor];
    [iconBtn addSubview:introductionLabel];
    
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.width.height.equalTo(self.view.mas_width).multipliedBy(0.4);
    }];
    
    [introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iconBtn.mas_centerX);
        make.bottom.equalTo(iconBtn.mas_bottom).multipliedBy(0.65);
    }];
    
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconBtn.mas_centerY).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(Margin);
        make.width.mas_equalTo(Func_Btn_Width);
        make.height.mas_equalTo(Func_Btn_Height);
    }];
    
    [mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconBtn.mas_centerY).offset(+40);
        make.left.equalTo(self.view.mas_left).offset(Margin);
        make.width.mas_equalTo(Func_Btn_Width);
        make.height.mas_equalTo(Func_Btn_Height);
    }];
    
    [lock_unlockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconBtn.mas_centerY).offset(-20);
        make.right.equalTo(self.view.mas_right).offset(-Margin);
        make.width.mas_equalTo(Func_Btn_Width + 10);
        make.height.mas_equalTo(Func_Btn_Height);
    }];
    
    [serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconBtn.mas_centerY).offset(+40);
        make.right.equalTo(self.view.mas_right).offset(-Margin);
        make.width.mas_equalTo(Func_Btn_Width);
        make.height.mas_equalTo(Func_Btn_Height);
    }];
}

- (void)decorateUserStatusPromptBar: (AccountStatus)status
{
    if (self.promptStatusView)
    {
        [self.promptStatusView removeFromSuperview];
    }
    //用户信息完美
    if (status == Login)
    {
        return;
    }
    UIView *backView = [[UIView alloc]init];
    self.promptStatusView = backView;
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    UILabel *promptLabel = [[UILabel alloc]init];
    [backView addSubview:promptLabel];
    UIButton *improveBtn = [[UIButton alloc]init];
    improveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [WLCommonTool makeViewShowingWithRoundCorner:improveBtn andRadius:Btn_Radius];
    [backView addSubview:improveBtn];
    [improveBtn setBackgroundImage:[UIImage imageNamed:@"btn_orange"] forState:UIControlStateNormal];
    //用户未实名
    if (status == UnRegistRealName)
    {
        promptLabel.text = @"您未实名认证无法租借设备";
        improveBtn.tag = status;
        [improveBtn setTitle:@"立即认证" forState:UIControlStateNormal];
        [improveBtn addTarget:self action:@selector(improveBtnDidClicking:) forControlEvents:UIControlEventTouchUpInside];
    }else if (status == UnPaidDeposit)
    {
        promptLabel.text = @"您未缴纳押金无法租借设备";
        improveBtn.tag = status;
        [improveBtn setTitle:@"立即缴纳" forState:UIControlStateNormal];
        [improveBtn addTarget:self action:@selector(improveBtnDidClicking:) forControlEvents:UIControlEventTouchUpInside];
    }else if (status == UnPaidRent)
    {
        promptLabel.text = @"您未缴纳租金无法租借设备";
        improveBtn.tag = status;
        [improveBtn setTitle:@"立即缴纳" forState:UIControlStateNormal];
        [improveBtn addTarget:self action:@selector(improveBtnDidClicking:) forControlEvents:UIControlEventTouchUpInside];
    }else if (status == Unlogin)
    {
        promptLabel.text = @"您未登录无法租借设备";
        improveBtn.tag = status;
        [improveBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        [improveBtn addTarget:self action:@selector(improveBtnDidClicking:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(backView.mas_left).offset(Margin);
    }];
    
    [improveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(-Margin);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    
    
}

- (void)mapBtnDidClicking: (UIButton *)sender
{
    [self.mapVC startGetUserPosition];
}

- (void)profileBtnDidClicking
{
    WLProfileViewController *profileVC = [[WLProfileViewController alloc]initWithNibName:@"WLProfileViewController" bundle:nil];
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)lockUnlockBtnDidClicking: (UIButton *)sender
{
    NSLog(@"123");
    NSString *motorCode = [WLUserInfoMaintainance sharedMaintain].model.data.ddcdm;
    //换电池标记参数始终为3, 开锁, 关锁, 扫电动车都是3, 还车为4
    [[WLCommonAPI sharedCommonAPIManager]queryAquireChargerWithCode:motorCode andActionType:@"3" success:^(id _Nullable responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        NSString *message = response[@"message"];
        if ([message containsString:@"成功"])
        {
            self.lock_unlock_btn.selected = !self.lock_unlock_btn.selected;
        }
        [ProgressHUD show:response[@"message"]];
        //此方法默认不会消失, 此处延迟2秒后消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ProgressHUD dismiss];
        });
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"请求失败"];
    }];
}

- (void)iconBtnDidClicking
{
    AccountStatus status = [self judegeAccountStatus];
    if (status == Unlogin)
    {
        [ProgressHUD showError:@"请登录"];
        return;
    }
    if (status == UnRegistRealName)
    {
        [ProgressHUD showError:@"请实名认证"];
        return;
    }
    if (status == UnPaidDeposit)
    {
        [ProgressHUD showError:@"请缴纳押金"];
        return;
    }
    if (status == UnPaidRent)
    {
        [ProgressHUD showError:@"请缴纳租金"];
        return;
    }
    WLScanBitCodeViewController *scanBitCodeVC = [[WLScanBitCodeViewController alloc]init];
    [self.navigationController pushViewController:scanBitCodeVC animated:YES];
}

- (void)serviceBtnDidClicking
{
    WLCustomerServiceViewController *customerServiceVC = [[WLCustomerServiceViewController alloc]init];
    [self.navigationController pushViewController:customerServiceVC animated:YES];
}

- (void)improveBtnDidClicking: (UIButton *)sender
{
    if (sender.tag == UnRegistRealName)
    {
        WLCertificationController *certificationVC = [[WLCertificationController alloc]init];
        [self.navigationController pushViewController:certificationVC animated:YES];
    }else if (sender.tag == UnPaidDeposit || sender.tag == UnPaidRent)
    {
        NSLog(@"跳转交押金/租金页面");
        WLMyAccountController *myAccountVC = [[WLMyAccountController alloc]initWithNibName:@"WLMyAccountView" bundle:nil];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }else if (sender.tag == Unlogin)
    {
        WLLoginViewController *loginVC = [[WLLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

- (void)refreshBtnDidClicking
{
    //重新请求该市站点信息
    [self aquireChargerStations];
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
