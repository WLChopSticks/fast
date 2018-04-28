//
//  WLProfileViewController.m
//  ckd
//
//  Created by wanglei on 2018/4/28.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLProfileViewController.h"
#import "WLPlatform.h"

@interface WLProfileViewController ()

@end

@implementation WLProfileViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@",self.description);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
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
