//
//  WLPaidDepositViewController.m
//  ckd
//
//  Created by 王磊 on 2018/5/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLPaidDepositViewController.h"
#import "WLHomeViewController.h"
#import "WLWePay.h"

@interface WLPaidDepositViewController ()

@end

@implementation WLPaidDepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)paidBtnDidClicking:(id)sender
{
    NSLog(@"点击了充值按钮");
    [[WLWePay sharedWePay]createWePayRequestWithMoney:@"100"];
    //发起微信支付, 成功后返回首页
    [self jumpToHomeVC];
}


- (void)jumpToHomeVC
{
    WLHomeViewController *vc = [[WLHomeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
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
