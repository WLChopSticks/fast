//
//  WLLoginView.m
//  ckd
//
//  Created by 王磊 on 2018/4/29.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLLoginView.h"
#import "WLPlatform.h"

@interface WLLoginView()

@property (nonatomic, weak) UIButton *loginBtn;
@property (nonatomic, weak) UIButton *checkboxBtn;

@end

@implementation WLLoginView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self decorateUI];
    }
    return self;
}

- (void)decorateUI
{
    UIImageView *logoView = [[UIImageView alloc]init];
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    logoView.image = logoImage;
    [self addSubview:logoView];
    
    UILabel *telephoneLabel = [[UILabel alloc]init];
    [telephoneLabel setTextColor:LightGrayStyle];
    telephoneLabel.text = @"手机号";
    [self addSubview:telephoneLabel];
    
    UITextField *telephoneField = [[UITextField alloc]init];
    [self addSubview:telephoneField];
    
    UIView *seperateView = [[UIView alloc]init];
    seperateView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:seperateView];
    
    UILabel *checkNumberLabel = [[UILabel alloc]init];
    [checkNumberLabel setTextColor:LightGrayStyle];
    checkNumberLabel.text = @"验证码";
    [self addSubview:checkNumberLabel];
    
    UITextField *checkNumberField = [[UITextField alloc]init];
    [self addSubview:checkNumberField];
    
    UIView *seperateView2 = [[UIView alloc]init];
    seperateView2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:seperateView2];
    
    UIButton *aquireCheckNumBtn = [[UIButton alloc]init];
    [aquireCheckNumBtn setBackgroundImage:[UIImage imageNamed:@"btn_code"] forState:UIControlStateNormal];
    [aquireCheckNumBtn setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateSelected];
    [aquireCheckNumBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [aquireCheckNumBtn setTitle:@"58'S" forState:UIControlStateSelected];
    [aquireCheckNumBtn addTarget:self action:@selector(aquireCheckNumBtnDidClicking:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:aquireCheckNumBtn];
    
    UIButton *loginBtn = [[UIButton alloc]init];
    self.loginBtn = loginBtn;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_orange"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateDisabled];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnDidClicking:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    
    UIButton *checkBoxBtn = [[UIButton alloc]init];
    self.checkboxBtn = checkBoxBtn;
    [checkBoxBtn setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateSelected];
    [checkBoxBtn setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    checkBoxBtn.selected = YES;
    [checkBoxBtn addTarget:self action:@selector(checkboxBtnDidClicking:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:checkBoxBtn];
    
    UILabel *templateLabel = [[UILabel alloc]init];
    [templateLabel setTextColor:LightGrayStyle];
    templateLabel.font = [UIFont systemFontOfSize:14];
    templateLabel.text = @"我已仔细查阅并同意";
    [self addSubview:templateLabel];
    
    UIButton *userAgreementBtn = [[UIButton alloc]init];
    [userAgreementBtn setTitle:@"<诚快达用户协议>" forState:UIControlStateNormal];
    userAgreementBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [userAgreementBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [userAgreementBtn addTarget:self action:@selector(userAgreementBtnDidClicking:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:userAgreementBtn];
    
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(50);
        make.width.height.mas_offset(100);
    }];
    
    [telephoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoView.mas_bottom).offset(50);
        make.left.equalTo(self.mas_left).offset(20);
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
        make.top.equalTo(telephoneField.mas_bottom);
        make.left.equalTo(self.mas_left).offset(Margin);
        make.right.equalTo(self.mas_right).offset(-Margin);
        make.height.mas_equalTo(1);
    }];
    
    [checkNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seperateView.mas_bottom).offset(Margin);
        make.left.equalTo(self.mas_left).offset(20);
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
        make.top.equalTo(checkNumberField.mas_bottom);
        make.left.equalTo(self.mas_left).offset(Margin);
        make.right.equalTo(self.mas_right).offset(-Margin);
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
        make.left.equalTo(self.mas_left).offset(Margin);
        make.right.equalTo(self.mas_right).offset(-Margin);
        make.height.mas_equalTo(50);
    }];
    
    [checkBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(Margin * 2);
        make.left.equalTo(self.mas_left).offset(Margin * 3);
        make.width.height.mas_equalTo(30);
    }];
    
    [templateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(checkBoxBtn.mas_centerY);
        make.left.equalTo(checkBoxBtn.mas_right).offset(Margin);
        //        make.right.equalTo(self.mas_right).offset(-Margin);
        //        make.height.mas_equalTo(50);
    }];
    
    [userAgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(checkBoxBtn.mas_centerY);
        make.left.equalTo(templateLabel.mas_right).offset(Margin);
        //        make.width.height.mas_equalTo(50);
    }];
    
    
}

- (void)aquireCheckNumBtnDidClicking: (UIButton *)sender
{
    sender.selected = YES;
    if ([self.delegate respondsToSelector:@selector(LoginView:aquireCheckNumBtnDidclicking:)])
    {
        [self.delegate LoginView:self aquireCheckNumBtnDidclicking:sender];
    }
}

- (void)loginBtnDidClicking: (UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(LoginView:loginBtnDidclicking:)])
    {
        [self.delegate LoginView:self loginBtnDidclicking:sender];
    }
}

- (void)checkboxBtnDidClicking: (UIButton *)sender
{
    self.checkboxBtn.selected = !self.checkboxBtn.selected;
    if (sender.isSelected)
    {
        
        self.loginBtn.enabled = YES;
    }
    else
    {
        self.loginBtn.enabled = NO;
    }
//    if ([self.delegate respondsToSelector:@selector(LoginView:checkboxBtnDidclicking:)])
//    {
//        [self.delegate LoginView:self checkboxBtnDidclicking:sender];
//    }
}

- (void)userAgreementBtnDidClicking: (UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(LoginView:userAgreementBtnDidclicking:)])
    {
        [self.delegate LoginView:self userAgreementBtnDidclicking:sender];
    }
}

- (void)hehe
{
    NSLog(@"123");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
