//
//  WLSettingDetailViewController.m
//  ckd
//
//  Created by 王磊 on 2018/5/3.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLSettingDetailViewController.h"
#import "WLScanBitCodeViewController.h"
#import "WLLoginViewController.h"
#import "WLBootViewController.h"
#import "WLChangeTelephoneNumberViewController.h"

@interface WLSettingDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;



@end

@implementation WLSettingDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"版本v%@",version];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma --mark 各个按钮点击事件, 此处cell都是通过盖一个btn实现点击的

- (IBAction)changeTelNumberBtnDidClicking:(id)sender
{
    NSLog(@"更换手机号按钮点击了");
    WLChangeTelephoneNumberViewController *changeTelNumberVC = [[WLChangeTelephoneNumberViewController alloc]init];
    [self.navigationController pushViewController:changeTelNumberVC animated:YES];
}
- (IBAction)returnChargerBtnDidClicking:(id)sender
{
    NSLog(@"退电按钮点击了");
    WLScanBitCodeViewController *scanBitCodeVC = [[WLScanBitCodeViewController alloc]init];
    [self.navigationController pushViewController:scanBitCodeVC animated:YES];
}
- (IBAction)logoutBtnDidClicking:(id)sender
{
    NSLog(@"退出登录点击了");
    WLLoginViewController *loginVC = [[WLLoginViewController alloc]init];
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[WLBootViewController class]])
        {
            [self.navigationController popToViewController:vc animated:NO];
            [vc.navigationController pushViewController:loginVC animated:YES];
        }
    } 
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
