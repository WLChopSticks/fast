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

@interface WLLoginViewController ()<LoginviewDelegate>

@end

@implementation WLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    WLLoginView *loginView = [[WLLoginView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:loginView];
    loginView.delegate = self;
    
}

-(void)LoginView:(WLLoginView *)view aquireCheckNumBtnDidclicking:(UIButton *)sender
{
    NSLog(@"请求验证码");
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
