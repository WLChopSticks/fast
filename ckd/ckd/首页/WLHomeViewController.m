//
//  WLHomeViewController.m
//  ckd
//
//  Created by wanglei on 2018/4/28.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLHomeViewController.h"
#import "WLPlatform.h"
#import <Masonry.h>
#import "WLProfileViewController.h"
#import "WLLoginViewController.h"

@interface WLHomeViewController ()

@end

@implementation WLHomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    WLLoginViewController *loginVC = [[WLLoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //导航栏布局
    [self decorateNavigationBar];
    //功能按钮布局
    [self decorateFunctionsButtons];
    
}

- (void)decorateNavigationBar
{
    self.title = @"HEHEHE";
    
    UIImage *profileImage = [[UIImage imageNamed:@"nav_defaultavatar"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *profileBtn = [[UIBarButtonItem alloc]initWithImage:profileImage style:UIBarButtonItemStylePlain target:self action:@selector(profileBtnDidClicking)];
    self.navigationItem.leftBarButtonItem = profileBtn;
    
    UIImage *newsImage = [[UIImage imageNamed:@"nav_message"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *newsBtn = [[UIBarButtonItem alloc]initWithImage:newsImage style:UIBarButtonItemStylePlain target:self action:@selector(hehe)];
    self.navigationItem.rightBarButtonItem = newsBtn;
}

- (void)decorateFunctionsButtons
{
    UIButton *refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    [refreshBtn setImage:[UIImage imageNamed:@"home_ic_refresh"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(hehe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn];
    
    UIButton *mapBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    [mapBtn setImage:[UIImage imageNamed:@"home_ic_map"] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(hehe) forControlEvents:UIControlEventTouchUpInside];
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
    iconBtn.backgroundColor = [UIColor blueColor];
    [iconBtn addTarget:self action:@selector(hehe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:iconBtn];
    
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.width.height.equalTo(self.view.mas_width).multipliedBy(0.3);
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

- (void)hehe
{
    NSLog(@"123");
}

- (void)profileBtnDidClicking
{
    WLProfileViewController *profileVC = [[WLProfileViewController alloc]init];
    [self.navigationController pushViewController:profileVC animated:YES];
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
