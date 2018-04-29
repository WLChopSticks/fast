//
//  WLSettingsViewController.m
//  ckd
//
//  Created by 王磊 on 2018/4/29.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLSettingsViewController.h"
#import "WLPlatform.h"
#import "WLSettings.h"

@interface WLSettingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation WLSettingsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self decorateUI];
}

- (void)decorateUI
{
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //取出stroryboard里面的控制器：
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"WLSettingsViewController" bundle:nil];
    //将取出的storyboard里面的控制器被所需的控制器指着。
    WLSettings *jVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"settings"];
    [self.view addSubview:jVC.view];
    [self addChildViewController:jVC];
    
    //列表
//    UITableView *tableView = [[UITableView alloc]init];
//    tableView.dataSource = self;
//    tableView.delegate = self;
//    [self.view addSubview:tableView];
    
    //退出登录按钮
//    UIButton *quitBtn = [[UIButton alloc]init];
//    [quitBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
//    [self.view addSubview:quitBtn];
//
//    [quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-Margin * 50);
//    }];
//
//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.bottom.equalTo(quitBtn.mas_top).offset(-Margin * 30);
//    }];
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
