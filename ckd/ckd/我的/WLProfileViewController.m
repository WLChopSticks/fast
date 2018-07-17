//
//  WLProfileViewController.m
//  ckd
//
//  Created by wanglei on 2018/4/28.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLProfileViewController.h"
#import "WLPlatform.h"
#import "WLSettingDetailViewController.h"
#import "WLMyAccountController.h"
#import "WLMyApplyChargerRecordViewController.h"
#import "WLCertificationController.h"
#import "WLProfileInformationViewController.h"
#import "WLUserInfoMaintainance.h"
#import "WLMyRentMotorViewController.h"

@interface WLProfileViewController ()

@property (weak, nonatomic) IBOutlet UIView *profileInfoView;
@property (weak, nonatomic) IBOutlet UIView *myExchangeView;
@property (weak, nonatomic) IBOutlet UIView *myAccountView;
@property (weak, nonatomic) IBOutlet UIView *SettingsView;
@property (weak, nonatomic) IBOutlet UIView *ProfileItemsView;
@property (weak, nonatomic) IBOutlet UILabel *exchangeChargerTime;
@property (weak, nonatomic) IBOutlet UILabel *expireTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *myRentMotorView;





@end

@implementation WLProfileViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
    
    //定义此页面导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:93/255.0 blue:67/255.0 alpha:1.0];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIImage *navBackImage = [[UIImage imageNamed:@"nav_ic_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:navBackImage style:UIBarButtonItemStylePlain target:self action:@selector(backBtnDidClicking)];
    self.navigationItem.leftBarButtonItem = backBtn;

    
    //查询当天换电次数
    [self queryExchangeChargerTimeForToday];
    //查询月卡到期时间
    [self queryQinglogin];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    WLProfileView *view = [[WLProfileView alloc]initWithFrame:self.view.bounds];
//    view.itemsArr = [self getItemsForProfile];
//    view.delegate = self;
//    [self.view addSubview:view];
    
    self.title = @"个人中心";
    
    
    //添加点击事件
    [self addGesturesToViews];
    
    //设置圆角边框
    self.ProfileItemsView.layer.cornerRadius = 8;
    self.ProfileItemsView.layer.masksToBounds = YES;
    self.ProfileItemsView.backgroundColor = LightGrayBackground;
    
}

- (void)queryExchangeChargerTimeForToday
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *parametersStr = [NSString stringWithFormat:@"{user_id:%@}",[WLUtilities getUserID]];
    [parameters setObject:parametersStr forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"AquireExchangeTimesEveryday"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if ([result[@"code"] integerValue] == 1)
        {
            NSLog(@"查询今日换电次数成功");
            NSString *timesForToday = result[@"data"][@"hdcs"];
            self.exchangeChargerTime.text = [NSString stringWithFormat:@"今日换电: %@次", timesForToday];
            
        }else
        {
            NSLog(@"查询今日换电次数失败");
        }
    } failure:^(NSError *error) {
        NSLog(@"获取缴费记录失败");
        NSLog(@"%@",error);
    }];
}

- (void)queryQinglogin
{
    [[WLUserInfoMaintainance sharedMaintain]queryUserInfo:^(NSNumber *result) {
        //如果成功则显示到期时间
        if ([result boolValue])
        {
            NSArray *expireTimeArr = [[[[WLUserInfoMaintainance sharedMaintain]model]data]list];
            for (WLUserExpireTimeModel *model in expireTimeArr)
            {
                //租金
                if ([model.fylxdm isEqualToString:@"2"])
                {
                    self.expireTimeLabel.text = [NSString stringWithFormat:@"%@ 到期",model.jssj];
                    break;
                }
            }
        }
    }];
}

- (void)addGesturesToViews
{
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profileInfoViewDidClicking:)];
    [self.profileInfoView addGestureRecognizer:tapGesture1];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myExchangeViewDidClicking:)];
    [self.myExchangeView addGestureRecognizer:tapGesture2];
    
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myAccountViewDidClicking:)];
    [self.myAccountView addGestureRecognizer:tapGesture3];
    
    UITapGestureRecognizer *tapGesture4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingsViewDidClicking:)];
    [self.SettingsView addGestureRecognizer:tapGesture4];
    
    UITapGestureRecognizer *tapGesture5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myRentMotorViewDidClicking:)];
    [self.myRentMotorView addGestureRecognizer:tapGesture5];
}

- (void)profileInfoViewDidClicking:(id)sender
{
    NSLog(@"我的信息点击了");
    WLUserInfoMaintainance *userInfo = [WLUserInfoMaintainance sharedMaintain];
    if (userInfo.model.data.ztm.integerValue != 0)
    {
        NSLog(@"跳转我的信息页面");
        WLProfileInformationViewController *vc = [[WLProfileInformationViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        NSLog(@"跳转实名认证页面");
        WLCertificationController *certificationVC = [[WLCertificationController alloc]init];
        [self.navigationController pushViewController:certificationVC animated:YES];
    }
}

- (void)myExchangeViewDidClicking:(id)sender
{
    NSLog(@"我的换电点击了");
    WLMyApplyChargerRecordViewController *chargerRecordVC = [[WLMyApplyChargerRecordViewController alloc]init];
    [self.navigationController pushViewController:chargerRecordVC animated:YES];
}

- (void)myRentMotorViewDidClicking:(id)sender
{
    NSLog(@"我的租车点击了");
    WLMyRentMotorViewController *chargerRecordVC = [[WLMyRentMotorViewController alloc]init];
    [self.navigationController pushViewController:chargerRecordVC animated:YES];
}

- (void)myAccountViewDidClicking:(id)sender
{
    NSLog(@"我的账户点击了");
    WLMyAccountController *destinatinVC = [[WLMyAccountController alloc]initWithNibName:@"WLMyAccountView" bundle:nil];
    [self.navigationController pushViewController:destinatinVC animated:YES];
}

- (void)settingsViewDidClicking:(id)sender
{
    NSLog(@"我的设置点击了");
    WLSettingDetailViewController *destinatinVC = [[WLSettingDetailViewController alloc]initWithNibName:@"WLSettingDetailViewController" bundle:nil];
    [self.navigationController pushViewController:destinatinVC animated:YES];
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
