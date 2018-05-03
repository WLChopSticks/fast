//
//  WLHomeViewController.m
//  ckd
//
//  Created by wanglei on 2018/4/28.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLHomeViewController.h"
#import "WLPlatform.h"
#import "WLProfileViewController.h"
#import "WLLoginViewController.h"
#import "MapViewBaseDemoViewController.h"
#import "WLMapViewController.h"
#import "WLScanBitCodeViewController.h"
#import "WLChargerStationModel.h"
#import "WLRealNameAuthenticationViewController.h"
#import "WLNewsCenterViewController.h"
#import "WLEachChargerStationModel.h"
#import "WLPaidDepositViewController.h"

typedef enum : NSUInteger {
    UnRegistRealName,
    UnPaidDeposit,
    Unlogin,
    Login
} AccountStatus;

@interface WLHomeViewController ()

@property (nonatomic, weak)WLMapViewController *mapVC;

@end

@implementation WLHomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
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
    
    //查看用户账户状态, 是否显示提示bar, 引导用户完善信息
    [self decorateUserStatusPromptBar:[self judegeAccountStatus]];

    //请求充电站的位置节点
    [self aquireChargerStations];
    
    
    
}

- (AccountStatus)judegeAccountStatus
{
    if (![WLUtilities isUserLogin])
    {
        return Unlogin;
    }
    if (![WLUtilities isUserRealNameRegist])
    {
        return UnRegistRealName;
    }
    if ([WLUtilities isUserDepositPaid])
    {
        return UnPaidDeposit;
    }
    return Login;
}

- (void)aquireChargerStations
{
    [ProgressHUD show];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *cityCode = [NSString stringWithFormat:@"{csdm:1}"];
//    NSString *cityCode = [NSString stringWithFormat:@"{csdm:%@}",[WLUtilities getCurrentCityCode]];
    [parameters setObject:cityCode forKey:@"inputParameter"];
    NSString *URL = @"http://47.104.85.148:18070/ckdhd/queryCsZd.action";
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
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
    self.title = @"诚快达";
    
    UIImage *profileImage = [[UIImage imageNamed:@"nav_defaultavatar"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *profileBtn = [[UIBarButtonItem alloc]initWithImage:profileImage style:UIBarButtonItemStylePlain target:self action:@selector(profileBtnDidClicking)];
    self.navigationItem.leftBarButtonItem = profileBtn;
    
    UIImage *newsImage = [[UIImage imageNamed:@"nav_message"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *newsCenterBtn = [[UIBarButtonItem alloc]initWithImage:newsImage style:UIBarButtonItemStylePlain target:self action:@selector(newsCenterBtnDidClicking)];
    self.navigationItem.rightBarButtonItem = newsCenterBtn;
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
    
    UIButton *collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    [collectBtn setImage:[UIImage imageNamed:@"home_ic_collect"] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(hehe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectBtn];
    
    UIButton *serviceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    [serviceBtn setImage:[UIImage imageNamed:@"home_ic_service"] forState:UIControlStateNormal];
    [serviceBtn addTarget:self action:@selector(hehe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:serviceBtn];

    UIButton *iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
//    [iconBtn setImage:[UIImage imageNamed:@"icon_code"] forState:UIControlStateNormal];
    [iconBtn setBackgroundImage:[UIImage imageNamed:@"icon_code"] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(iconBtnDidClicking) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:iconBtn];
    
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.width.height.equalTo(self.view.mas_width).multipliedBy(0.4);
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
    
    [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconBtn.mas_centerY).offset(-20);
        make.right.equalTo(self.view.mas_right).offset(-Margin);
        make.width.mas_equalTo(Func_Btn_Width);
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
    //用户信息完美
    if (status == Login)
    {
        return;
    }
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    UILabel *promptLabel = [[UILabel alloc]init];
    [backView addSubview:promptLabel];
    UIButton *improveBtn = [[UIButton alloc]init];
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

- (void)hehe
{
    NSLog(@"123");
}

- (void)profileBtnDidClicking
{
    WLProfileViewController *profileVC = [[WLProfileViewController alloc]init];
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)iconBtnDidClicking
{
    WLScanBitCodeViewController *scanBitCodeVC = [[WLScanBitCodeViewController alloc]init];
    [self.navigationController pushViewController:scanBitCodeVC animated:YES];
}

- (void)newsCenterBtnDidClicking
{
    WLNewsCenterViewController *newsCenterVC = [[WLNewsCenterViewController alloc]init];
    [self.navigationController pushViewController:newsCenterVC animated:YES];
}

- (void)improveBtnDidClicking: (UIButton *)sender
{
    if (sender.tag == UnRegistRealName)
    {
        WLRealNameAuthenticationViewController *realNameIdentifyVC = [[WLRealNameAuthenticationViewController alloc]init];
        [self.navigationController pushViewController:realNameIdentifyVC animated:YES];
    }else if (sender.tag == UnPaidDeposit)
    {
        NSLog(@"跳转交押金页面");
        WLPaidDepositViewController *paidDepositVC = [[WLPaidDepositViewController alloc]init];
        [self.navigationController pushViewController:paidDepositVC animated:YES];
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
