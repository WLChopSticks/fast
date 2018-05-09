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
#import "WLWebViewController.h"


@interface WLSettingDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *appIcon;

@end

@implementation WLSettingDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
    //4s时需要缩小图标
    if (IS_IPHONE4())
    {
        [self.appIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(70);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置";
    [WLCommonTool makeViewShowingWithRoundCorner:self.exitBtn andRadius:Btn_Radius];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"版本v%@",version];
    
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma --mark 各个按钮点击事件, 此处cell都是通过盖一个btn实现点击的

- (IBAction)aboutUsItemDidClicking:(id)sender
{
    NSLog(@"关于我们点击了");
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    [self jumpToWebViewWithTitle:@"关于我们" andURL:networkTool.queryAPIList[@"AboutUs"]];
}
- (IBAction)UserAgreementItemDidClicking:(id)sender
{
    NSLog(@"用户协议点击了");
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    [self jumpToWebViewWithTitle:@"用户协议" andURL:networkTool.queryAPIList[@"UserAgreement"]];
}
- (IBAction)PurchaseIntroducitonItemDidClicking:(id)sender
{
    NSLog(@"购买说明点击了");
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    [self jumpToWebViewWithTitle:@"购买说明" andURL:networkTool.queryAPIList[@"PurchaseIntroduction"]];
}
- (IBAction)DepositIntroductionDidClicking:(id)sender
{
    NSLog(@"押金说明点击了");
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    [self jumpToWebViewWithTitle:@"押金说明" andURL:networkTool.queryAPIList[@"DepositIntrduction"]];
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

//跳转webview页面
- (void)jumpToWebViewWithTitle: (NSString *)title andURL: (NSString *)urlString
{
    WLWebViewController *webVC = [[WLWebViewController alloc]init];
    webVC.title = title;
    webVC.requestURL = urlString;
    [self.navigationController pushViewController:webVC animated:YES];
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
