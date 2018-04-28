//
//  WLLoginViewController.m
//  ckd
//
//  Created by wanglei on 2018/4/28.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLLoginViewController.h"
#import "WLPlatform.h"

@interface WLLoginViewController ()

@end

@implementation WLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self decorateUI];
}

- (void)decorateUI
{
    UIImageView *logoView = [[UIImageView alloc]init];
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    logoView.image = logoImage;
    [self.view addSubview:logoView];
    
    UILabel *telephoneLabel = [[UILabel alloc]init];
    telephoneLabel.text = @"手机号";
    [self.view addSubview:telephoneLabel];
    
    UITextField *telephoneField = [[UITextField alloc]init];
    [self.view addSubview:telephoneField];
    
    UIView *seperateView = [[UIView alloc]init];
    seperateView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperateView];
    
    UILabel *checkNumberLabel = [[UILabel alloc]init];
    checkNumberLabel.text = @"验证码";
    [self.view addSubview:checkNumberLabel];
    
    UITextField *checkNumberField = [[UITextField alloc]init];
    [self.view addSubview:checkNumberField];
    
    UIView *seperateView2 = [[UIView alloc]init];
    seperateView2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:seperateView2];
    
    UIButton *aquireCheckNumBtn = [[UIButton alloc]init];
    [aquireCheckNumBtn setBackgroundColor:[UIColor grayColor]];
    [aquireCheckNumBtn addTarget:self action:@selector(hehe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aquireCheckNumBtn];
    
    UIButton *loginBtn = [[UIButton alloc]init];
    [loginBtn setBackgroundColor:[UIColor grayColor]];
    [loginBtn addTarget:self action:@selector(hehe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(50);
        make.width.height.mas_offset(100);
    }];
    
    [telephoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoView.mas_bottom).offset(50);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [telephoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(telephoneLabel.mas_bottom).offset(Margin);
        make.left.equalTo(telephoneLabel.mas_left);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [seperateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(telephoneField.mas_bottom).offset(Margin);
        make.left.equalTo(self.view.mas_left).offset(Margin);
        make.right.equalTo(self.view.mas_right).offset(-Margin);
        make.height.mas_equalTo(1);
    }];
    
    [checkNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seperateView.mas_bottom).offset(Margin);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [checkNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(checkNumberLabel.mas_bottom).offset(Margin);
        make.left.equalTo(telephoneLabel.mas_left);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [seperateView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(checkNumberField.mas_bottom).offset(Margin);
        make.left.equalTo(self.view.mas_left).offset(Margin);
        make.right.equalTo(self.view.mas_right).offset(-Margin);
        make.height.mas_equalTo(1);
    }];
    
    [aquireCheckNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(checkNumberLabel.mas_top);
        make.right.equalTo(seperateView2.mas_right).offset(-Margin);
        make.bottom.equalTo(seperateView2.mas_top).offset(-Margin * 2);
        make.width.mas_equalTo(100);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seperateView2.mas_bottom).offset(Margin * 3);
        make.left.equalTo(self.view.mas_left).offset(Margin);
        make.right.equalTo(self.view.mas_right).offset(-Margin);
        make.height.mas_equalTo(50);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)hehe
{
    NSLog(@"123");
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
