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


@end

@implementation WLChangeTelephoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"更换手机号码";
    self.view.backgroundColor = LightGrayBackground;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)aquireCheckNumberBtnDidClicking:(id)sender
{
    NSLog(@"获取验证码按钮点击了");
}
- (IBAction)finishBtnDidClicking:(id)sender
{
    NSLog(@"完成按钮点击了");
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
