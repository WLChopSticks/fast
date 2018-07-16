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

#import "WLListView.h"


@interface WLSettingDetailViewController ()<ListViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *appIcon;

@property (nonatomic, strong) NSArray *items;

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
    
    
    WLListView *lists = [[WLListView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    lists.listItems = self.items;
    lists.delegate = self;
    [self.view addSubview:lists];
    [lists mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appIcon.mas_bottom).offset(50);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma --mark 各个按钮点击事件, 此处cell都是通过盖一个btn实现点击的
- (void)ListView:(WLListView *)view selectListItem:(UITableViewCell *)sender andClickInfo:(NSString *)info
{
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    if ([info isEqualToString:@"关于我们"])
    {
        [self jumpToWebViewWithTitle:@"关于我们" andURL:networkTool.queryAPIList[@"AboutUs"]];
    }else if ([info isEqualToString:@"用户协议"])
    {
        [self jumpToWebViewWithTitle:@"用户协议" andURL:networkTool.queryAPIList[@"UserAgreement"]];
    }else if ([info isEqualToString:@"购买说明"])
    {
        [self jumpToWebViewWithTitle:@"购买说明" andURL:networkTool.queryAPIList[@"PurchaseIntroduction"]];
    }else if ([info isEqualToString:@"押金说明"])
    {
        [self jumpToWebViewWithTitle:@"押金说明" andURL:networkTool.queryAPIList[@"DepositIntrduction"]];
    }
}

- (IBAction)logoutBtnDidClicking:(id)sender
{
    NSLog(@"退出登录点击了");
    [WLUtilities setUserLogout];
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


-(NSArray *)items
{
    if (_items == nil)
    {
        _items = [NSArray arrayWithObjects:
                  @{@"icon":@"", @"title":@"关于我们", @"subTitle":@"", @"subImage":@"ic_more", @"rowHeight":@"50", @"click": @"关于我们"},
                  @{@"icon":@"", @"title":@"用户协议", @"subTitle":@"", @"subImage":@"ic_more", @"rowHeight":@"50", @"click": @"用户协议"},
                  @{@"icon":@"", @"title":@"购买说明", @"subTitle":@"", @"subImage":@"ic_more", @"rowHeight":@"50", @"click": @"购买说明"},
                  @{@"icon":@"", @"title":@"押金说明", @"subTitle":@"", @"subImage":@"ic_more", @"rowHeight":@"50", @"click": @"押金说明"}, nil];
    }
    return _items;
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
