//
//  WLProfileViewController.m
//  ckd
//
//  Created by wanglei on 2018/4/28.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLProfileViewController.h"
#import "WLPlatform.h"
#import "WLProfileView.h"

@interface WLProfileViewController ()<ProfileviewDelegate>

@end

@implementation WLProfileViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:251/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
    WLProfileView *view = [[WLProfileView alloc]initWithFrame:self.view.bounds];
    view.itemsArr = [self getItemsForProfile];
    view.delegate = self;
    [self.view addSubview:view];
}

-(void)ProfileView:(WLProfileView *)view backBtnDidClicking:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)getItemsForProfile
{
    
    NSDictionary *exchangPower = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"me_ic_01", @"itemIcon",
                                  @"我的换电", @"itemName",
                                  @"13次", @"itemRemark",
                                  @"ic_more", @"itemArrow",nil];
    
    NSDictionary *myAccount = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"me_ic_02", @"itemIcon",
                               @"我的账户", @"itemName",
                               @"剩余12天", @"itemRemark",
                               @"ic_more", @"itemArrow",nil];
    
    NSDictionary *myCollect = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"me_ic_03", @"itemIcon",
                               @"我的收藏", @"itemName",
                               @"", @"itemRemark",
                               @"ic_more", @"itemArrow",nil];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"me_ic_04", @"itemIcon",
                              @"设置", @"itemName",
                              @"", @"itemRemark",
                              @"ic_more", @"itemArrow",nil];
    
    NSDictionary *helpCenter = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"me_ic_05", @"itemIcon",
                                @"帮助中心", @"itemName",
                                @"", @"itemRemark",
                                @"ic_more", @"itemArrow",nil];
    
    NSArray *itemsArr1 = @[exchangPower, myAccount, myCollect];
    NSArray *itemsArr2 = @[settings, helpCenter];
    NSArray *itemsArr = @[itemsArr1, itemsArr2];
    return itemsArr;
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
