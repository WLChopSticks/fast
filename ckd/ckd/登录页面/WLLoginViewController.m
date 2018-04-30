//
//  WLLoginViewController.m
//  ckd
//
//  Created by wanglei on 2018/4/28.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLLoginViewController.h"
#import "WLPlatform.h"
#import "WLLoginView.h"
#import "AppDelegate.h"
#import "WLHomeViewController.h"
#import "WLBaseNavigationViewController.h"

@interface WLLoginViewController ()<LoginviewDelegate>

@property (nonatomic, weak) WLLoginView *loginView;

@end

@implementation WLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    WLLoginView *loginView = [[WLLoginView alloc]initWithFrame:self.view.bounds];
    self.loginView = loginView;
    [self.view addSubview:loginView];
    loginView.delegate = self;
    
}

-(void)LoginView:(WLLoginView *)view aquireCheckNumBtnDidclicking:(UIButton *)sender
{
    NSLog(@"请求验证码");
    /*
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
     [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     NSLog(@"132");
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     NSLog(@"132");
     }];
     */
    NSString *telephone = self.loginView.telephoneField.text;
    if (telephone.length < 11)
    {
        NSLog(@"手机号码不正确");
    }else
    {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSString *user_phone_string = [NSString stringWithFormat:@"{user_phone:%@}",telephone];
        [parameters setObject:user_phone_string forKey:@"inputParameter"];
        NSString *URL = @"http://47.104.85.148:18070/ckdhd/sendShortMessage.action";
        WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
        [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
            NSDictionary *result = (NSDictionary *)responseObject;
            if ([result[@"code"]integerValue] == 1)
            {
                NSLog(@"获取验证码成功");
            }else
            {
                NSLog(@"获取验证码失败");
            }
        } failure:^(NSError *error) {
            NSLog(@"获取验证码失败");
        }];
    }
}

-(void)LoginView:(WLLoginView *)view userAgreementBtnDidclicking:(UIButton *)sender
{
    NSLog(@"请求用户协议");
}

-(void)LoginView:(WLLoginView *)view loginBtnDidclicking:(UIButton *)sender
{
    NSLog(@"登录按钮点击");
    if (self.loginView.checkNumberField.text.length == 0)
    {
        NSLog(@"请输入验证码");
    }else
    {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSString *telephone = self.loginView.telephoneField.text;
        NSString *checkNumber = self.loginView.checkNumberField.text;
        NSString *URL = @"http://47.104.85.148:18070/ckdhd/quicklogin_quicklogin.action";
        NSString *parameter_string = [NSString stringWithFormat:@"{user_name:%@,user_phone:%@,yzm:%@}",telephone,telephone,checkNumber];
        [parameters setObject:parameter_string forKey:@"inputParameter"];
        WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
        [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
            NSDictionary *result = (NSDictionary *)responseObject;
            if ([result[@"code"]integerValue] == 1)
            {
                NSLog(@"登录成功");
                [WLUtilities setUserLogin];
                WLHomeViewController *homeVC = [[WLHomeViewController alloc]init];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate ];
                WLBaseNavigationViewController *nav = [[WLBaseNavigationViewController alloc]initWithRootViewController:homeVC];
                appDelegate.window.rootViewController = nav;
                [appDelegate.window makeKeyAndVisible];
                
            }else
            {
                NSLog(@"登录失败");
            }
            
        } failure:^(NSError *error) {
            NSLog(@"登录失败");
        }];
    }
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
