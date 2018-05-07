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
    UIImage *logoImage = [UIImage imageNamed:@"app_icon"];
    logoView.image = logoImage;
    [self addSubview:logoView];
    
    UILabel *telephoneLabel = [[UILabel alloc]init];
    [telephoneLabel setTextColor:LightGrayStyle];
    telephoneLabel.text = @"手机号";
    [self addSubview:telephoneLabel];
    
    UITextField *telephoneField = [[UITextField alloc]init];
    telephoneField.keyboardType = UIKeyboardTypePhonePad;
    self.telephoneField = telephoneField;
    [self addSubview:telephoneField];
    
    UIView *seperateView = [[UIView alloc]init];
    seperateView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:seperateView];
    
    UILabel *checkNumberLabel = [[UILabel alloc]init];
    [checkNumberLabel setTextColor:LightGrayStyle];
    checkNumberLabel.text = @"验证码";
    [self addSubview:checkNumberLabel];
    
    UITextField *checkNumberField = [[UITextField alloc]init];
    checkNumberField.keyboardType = UIKeyboardTypePhonePad;
    self.checkNumberField = checkNumberField;
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
        make.width.mas_equalTo(200);
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
        make.width.mas_equalTo(120);
    }];
    
    [checkNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(checkNumberLabel.mas_bottom).offset(Margin);
        make.left.equalTo(telephoneLabel.mas_left);
        make.right.equalTo(aquireCheckNumBtn.mas_left).offset(-Margin);
        make.height.mas_equalTo(30);
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
    
    //点击view使键盘消失
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:gesture];

}

- (void)tapView
{
    [self.telephoneField resignFirstResponder];
}

- (void)aquireCheckNumBtnDidClicking: (UIButton *)sender
{
    //按钮点击后更改状态, 并且进入倒计时, 并跳转处理逻辑
    if (self.telephoneField.text.length == 11)
    {
        sender.selected = YES;
        [self.checkNumberField becomeFirstResponder];
    }
    [self createCountdown:sender];
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

// 开启倒计时效果
-(void)createCountdown: (UIButton *)sender
{
    __block NSInteger time = CountDownTime; //倒计时时间
    [WLCommonTool createEverySecondTimer:^(dispatch_source_t timer) {
        //倒计时结束，关闭
        if(time <= 0)
        {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                sender.userInteractionEnabled = YES;
                sender.selected = NO;
            });
        }else
        {
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [sender setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateSelected];
                sender.userInteractionEnabled = NO;
            });
            time--;
        }
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
