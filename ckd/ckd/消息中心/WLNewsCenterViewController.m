//
//  WLNewsCenterViewController.m
//  ckd
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLNewsCenterViewController.h"
#import "WLPlatform.h"

@interface WLNewsCenterViewController ()

@end

@implementation WLNewsCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息中心";
    self.view.backgroundColor = LightGrayBackground;
    UIImageView *placeholderBackView = [[UIImageView alloc]init];
    placeholderBackView.image = [UIImage imageNamed:@"message_defaultpage"];
    [self.view addSubview:placeholderBackView];
    
    [placeholderBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(200);
        make.width.height.mas_equalTo(100);
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
