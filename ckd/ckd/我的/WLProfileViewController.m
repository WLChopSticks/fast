//
//  WLProfileViewController.m
//  ckd
//
//  Created by wanglei on 2018/4/28.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLProfileViewController.h"
#import "WLPlatform.h"
#import "WLProfileView.h"
#import "WLSettingDetailViewController.h"
#import "WLMyAccountController.h"
#import "WLMyApplyChargerRecordViewController.h"
#import "WLCertificationController.h"
#import "WLProfileInformationViewController.h"

@interface WLProfileViewController ()<ProfileviewDelegate>

@property (weak, nonatomic) IBOutlet UIView *profileInfoView;
@property (weak, nonatomic) IBOutlet UIView *myExchangeView;
@property (weak, nonatomic) IBOutlet UIView *myAccountView;
@property (weak, nonatomic) IBOutlet UIView *SettingsView;
@property (weak, nonatomic) IBOutlet UIView *ProfileItemsView;





@end

@implementation WLProfileViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
    
    //定义此页面导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
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
}

- (void)profileInfoViewDidClicking:(id)sender
{
    NSLog(@"我的信息点击了");
    if ([WLUtilities isUserRealNameRegist])
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
