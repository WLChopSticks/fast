//
//  WLChangeTelephoneNumberViewController.m
//  ckd
//
//  Created by 王磊 on 2018/5/3.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLChangeTelephoneNumberViewController.h"

@interface WLChangeTelephoneNumberViewController ()

@property (weak, nonatomic) IBOutlet UITextField *telephoneField;
@property (weak, nonatomic) IBOutlet UITextField *checkNumField;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;


@end

@implementation WLChangeTelephoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"更换手机号码";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)aquireCheckNumberBtnDidClicking:(id)sender
{
    NSLog(@"获取验证码按钮点击了");
    if (self.telephoneField.text.length < 11)
    {
        NSLog(@"手机号码不正确");
        [ProgressHUD showError:@"请输入手机号码"];
    }else
    {
        //先检查手机号是否被注册过, 没有则请求验证码
        [self queryIfTelephoneIsValid];
    }
}
- (IBAction)finishBtnDidClicking:(id)sender
{
    NSLog(@"完成按钮点击了");
    if (self.telephoneField.text.length != 11)
    {
        [ProgressHUD showError:@"请输入手机号码"];
        return;
    }
    if (self.checkNumField.text.length != 6)
    {
        [ProgressHUD showError:@"请输入验证码"];
        return;
    }
    [self queryChangeTelephoneNumber];
}

- (void)aquireSMSCheckNumber
{
    NSString *telephone = self.telephoneField.text;
    
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

- (void)queryChangeTelephoneNumber
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *user_phone_string = [NSString stringWithFormat:@"{user_id:%@,user_phone:%@,yzm=%@}",[WLUtilities getUserID], self.telephoneField.text, self.checkNumField.text];
    [parameters setObject:user_phone_string forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"ChangeTelephoneNumber"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"]integerValue] == 1)
        {
            NSLog(@"手机号更改成功");
            [ProgressHUD showSuccess:@"手机号更改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else
        {
            NSLog(@"手机号更改失败");
            [ProgressHUD showError:@"手机号更改失败"];
        }
    } failure:^(NSError *error) {
        NSLog(@"手机号更改失败");
        NSLog(@"%@",error);
        [ProgressHUD showError:@"手机号更改失败"];
    }];
}

- (void)queryIfTelephoneIsValid
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *parametersStr = [NSString stringWithFormat:@"{user_phone:%@}",self.telephoneField.text];
    [parameters setObject:parametersStr forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"JudgeAvailableOfTelephoneNumber"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if ([result[@"code"] integerValue] == 1)
        {
            NSLog(@"查询手机号成功");
            //手机号可用, 发送验证码
            [self aquireSMSCheckNumber];
            
        }else
        {
            NSLog(@"查询手机号失败");
        }
    } failure:^(NSError *error) {
        NSLog(@"查询手机号失败");
        NSLog(@"%@",error);
    }];
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
