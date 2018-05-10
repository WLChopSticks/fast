//
//  WLBaseUIViewController.m
//  ckd
//
//  Created by wanglei on 2018/4/28.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLBaseUIViewController.h"
#import <UMAnalytics/MobClick.h>

@interface WLBaseUIViewController ()

@end

@implementation WLBaseUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //在navigation下页面自动下串
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //全局设置返回按键
    UIImage *navBackImage = [[UIImage imageNamed:@"nav_ic_back_pressed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:navBackImage style:UIBarButtonItemStylePlain target:self action:@selector(backBtnDidClicking)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    //全局设置控制器背景颜色
    self.view.backgroundColor = LightGrayBackground;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",self.description);
    [super viewWillAppear:animated];
    //全局设置导航条颜色
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    [MobClick beginLogPageView:self.description]; //("Pagename"为页面名称，可自定义)
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.description];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnDidClicking
{
    [self.navigationController popViewControllerAnimated:YES];
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
