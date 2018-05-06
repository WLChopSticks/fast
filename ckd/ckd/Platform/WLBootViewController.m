//
//  WLBootViewController.m
//  ckd
//
//  Created by 王磊 on 2018/5/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLBootViewController.h"
#import "WLPlatform.h"
#import "WLHomeViewController.h"
#import "WLLoginViewController.h"


#import "WLCertificationController.h"

@interface WLBootViewController ()

@end

@implementation WLBootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //判断是否处于登录状态, 如果不, 则显示手机号码登录页面, 否则呈现首页
//    if ([WLUtilities isUserLogin])
//    {
//        [self jumpToHomeVC];
//    }else
//    {
//        [self jumpToLoginVC];
//    }
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

- (void)jumpToHomeVC
{
    WLHomeViewController *vc = [[WLHomeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)jumpToLoginVC
{
    WLLoginViewController *loginVC = [[WLLoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:NO];
}

@end
