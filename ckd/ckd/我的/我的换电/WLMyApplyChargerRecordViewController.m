//
//  WLMyApplyChargerRecordViewController.m
//  ckd
//
//  Created by wanglei on 2018/5/3.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLMyApplyChargerRecordViewController.h"
#import "WLPlatform.h"

@interface WLMyApplyChargerRecordViewController ()

@end

@implementation WLMyApplyChargerRecordViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的换电记录";
    self.view.backgroundColor = LightGrayBackground;
    
    [self showEmptyRecordView];
    
}

- (void)showEmptyRecordView
{
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:Screen_Bounds];
    [self.view addSubview:backImageView];
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"空空如也, 啥也没有";
    tipLabel.textColor = LightGrayStyle;
    [self.view addSubview:tipLabel];
    backImageView.image = [UIImage imageNamed:@"no_product"];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.height.mas_equalTo(100);
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_bottom).offset(5);
        make.centerX.equalTo(backImageView.mas_centerX);
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
