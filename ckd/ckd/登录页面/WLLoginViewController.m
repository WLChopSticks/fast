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
#import "WLQuickLoginModel.h"
#import "WLCertificationController.h"

@interface WLLoginViewController ()<LoginviewDelegate>

@property (nonatomic, weak) WLLoginView *loginView;

@end

@implementation WLLoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

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
        WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
        NSString *URL = networkTool.queryAPIList[@"AquireCheckSMS"];
        [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
            NSDictionary *result = (NSDictionary *)responseObject;
            if ([result[@"code"]integerValue] == 1)
            {
                NSLog(@"获取验证码成功");
                [ProgressHUD showSuccess:@"发送验证码成功"];
            }else
            {
                NSLog(@"获取验证码失败");
                [ProgressHUD showError:@"发送验证码失败"];
            }
        } failure:^(NSError *error) {
            NSLog(@"获取验证码失败");
            NSLog(@"%@",error);
            [ProgressHUD showError:@"发送验证码失败"];
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
    [self.loginView.checkNumberField resignFirstResponder];
    
    if (self.loginView.telephoneField.text.length != 11)
    {
        [ProgressHUD showError:@"请输入手机号"];
        return;
    }
    if (self.loginView.checkNumberField.text.length != 6)
    {
        [ProgressHUD showError:@"请输入验证码"];
        return;
    }
    [ProgressHUD show];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *telephone = self.loginView.telephoneField.text;
    NSString *checkNumber = self.loginView.checkNumberField.text;
    NSString *parameter_string = [NSString stringWithFormat:@"{user_name:%@,user_phone:%@,yzm:%@}",telephone,telephone,checkNumber];
    [parameters setObject:parameter_string forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"QuickLogin"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        [ProgressHUD showSuccess];
        WLQuickLoginModel *quickLoginModel = [WLQuickLoginModel mj_objectWithKeyValues:result];
        if ([quickLoginModel.code isEqualToString:@"1"])
        {
            //存储登录状态
            [WLUtilities setUserLogin];
            
            NSString *user_id = quickLoginModel.data.user_id;
            [WLUtilities saveUserID:user_id];
            NSLog(@"登录成功");
            //登录成功跳转首页
            WLHomeViewController *homeVC = [[WLHomeViewController alloc]init];
            [self.navigationController pushViewController:homeVC animated:YES];

        }else
        {
            NSLog(@"登录失败");
            [ProgressHUD showError:quickLoginModel.message];
        }
        
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"登录失败"];
        NSLog(@"登录失败");
    }];

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
