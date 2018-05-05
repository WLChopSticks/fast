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
#import "WLSettingDetailViewController.h"
#import "WLProfileDetailsViewController.h"
#import "WLMyAccountController.h"
#import "WLMyApplyChargerRecordViewController.h"
#import "WLCertificationController.h"

@interface WLProfileViewController ()<ProfileviewDelegate>

@property (weak, nonatomic) IBOutlet UIView *profileInfoView;
@property (weak, nonatomic) IBOutlet UIView *myExchangeView;
@property (weak, nonatomic) IBOutlet UIView *myAccountView;
@property (weak, nonatomic) IBOutlet UIView *SettingsView;
@property (weak, nonatomic) IBOutlet UIView *ProfileItemsView;





@end

@implementation WLProfileViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
    
    //定义此页面导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    WLProfileView *view = [[WLProfileView alloc]initWithFrame:self.view.bounds];
//    view.itemsArr = [self getItemsForProfile];
//    view.delegate = self;
//    [self.view addSubview:view];
    
    self.title = @"个人中心";
    
    
    //添加点击事件
    [self addGesturesToViews];
    
    //设置圆角边框
    self.ProfileItemsView.layer.cornerRadius = 8;
    self.ProfileItemsView.layer.masksToBounds = YES;
    
}

- (void)addGesturesToViews
{
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profileInfoViewDidClicking:)];
    [self.profileInfoView addGestureRecognizer:tapGesture1];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MyexchangeViewDidClicking:)];
    [self.myExchangeView addGestureRecognizer:tapGesture2];
    
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myAccountViewDidClicking:)];
    [self.myAccountView addGestureRecognizer:tapGesture3];
    
    UITapGestureRecognizer *tapGesture4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingsViewDidClicking:)];
    [self.SettingsView addGestureRecognizer:tapGesture4];
}

- (void)profileInfoViewDidClicking:(id)sender
{
    NSLog(@"我的信息点击了");
    if ([WLUtilities isUserRealNameRegist])
    {
        NSLog(@"跳转我的信息页面");
    }else
    {
        NSLog(@"跳转实名认证页面");
        WLCertificationController *certificationVC = [[WLCertificationController alloc]init];
        [self.navigationController pushViewController:certificationVC animated:YES];
    }
}

- (void)MyexchangeViewDidClicking:(id)sender
{
    NSLog(@"我的换电点击了");
    WLMyApplyChargerRecordViewController *chargerRecordVC = [[WLMyApplyChargerRecordViewController alloc]init];
    [self.navigationController pushViewController:chargerRecordVC animated:YES];
}

- (void)myAccountViewDidClicking:(id)sender
{
    NSLog(@"我的账户点击了");
    WLMyAccountController *destinatinVC = [[WLMyAccountController alloc]initWithNibName:@"WLMyAccountView" bundle:nil];
    [self.navigationController pushViewController:destinatinVC animated:YES];
}

- (void)settingsViewDidClicking:(id)sender
{
    NSLog(@"我的设置点击了");
    WLSettingDetailViewController *destinatinVC = [[WLSettingDetailViewController alloc]initWithNibName:@"WLSettingDetailViewController" bundle:nil];
    [self.navigationController pushViewController:destinatinVC animated:YES];
}




-(void)ProfileView:(WLProfileView *)view backBtnDidClicking:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ProfileView:(WLProfileView *)view userImageBtnDidClicking:(UIButton *)sender
{
    //取出stroryboard里面的控制器：
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"WLSettingsViewController" bundle:nil];
    //将取出的storyboard里面的控制器被所需的控制器指着。
    WLProfileDetailsViewController *profileDetailsVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"profileDetail"];
    [self.navigationController pushViewController:profileDetailsVC animated:YES];
}

-(void)ProfileView:(WLProfileView *)view itemTableView:(UITableView *)tableView didSelectItem:(NSDictionary *)item
{
    //如果配置的有跳转的目的控制器, 在此处创建控制器跳转
    if ([item objectForKey:@"destination"])
    {
        id destinatinVC = [[NSClassFromString([item objectForKey:@"destination"])alloc]init];
        [self.navigationController pushViewController:destinatinVC animated:YES];
    }else if ([[item objectForKey:@"destination_xib"] isEqualToString:@"WLMyAccountController"])
    {
        WLMyAccountController *destinatinVC = [[WLMyAccountController alloc]initWithNibName:@"WLMyAccountView" bundle:nil];
//        id destinatinVC = [[NSClassFromString([item objectForKey:@"destination_xib"])alloc]];
        [self.navigationController pushViewController:destinatinVC animated:YES];
//        //取出stroryboard里面的控制器：
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"WLSettingsViewController" bundle:nil];
//        //将取出的storyboard里面的控制器被所需的控制器指着。
//        WLMyAccountController *myAccountVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"myAccount"];
//        [self.navigationController pushViewController:myAccountVC animated:YES];
    }else if ([[item objectForKey:@"destination_xib"] isEqualToString:@"WLSettingDetailViewController"])
    {
        WLSettingDetailViewController *destinatinVC = [[WLSettingDetailViewController alloc]initWithNibName:@"WLSettingDetailViewController" bundle:nil];
        [self.navigationController pushViewController:destinatinVC animated:YES];
    }

//    else if ([[item objectForKey:@"destination_storyboard"] isEqualToString:@"myAccount"])
//    {
//        //取出stroryboard里面的控制器：
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"WLSettingsViewController" bundle:nil];
//        //将取出的storyboard里面的控制器被所需的控制器指着。
//        WLMyAccountController *myAccountVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"myAccount"];
//        [self.navigationController pushViewController:myAccountVC animated:YES];
//    }
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
                                  @"", @"itemRemark",
//                                  @"13次", @"itemRemark",
                                  @"ic_more", @"itemArrow",
                                  @"WLMyApplyChargerRecordViewController", @"destination",nil];
    
    NSDictionary *myAccount = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"me_ic_02", @"itemIcon",
                               @"我的账户", @"itemName",
                               @"", @"itemRemark",
//                               @"剩余12天", @"itemRemark",
                               @"ic_more", @"itemArrow",
                               @"WLMyAccountController", @"destination_xib",nil];
    
//    NSDictionary *myCollect = [NSDictionary dictionaryWithObjectsAndKeys:
//                               @"me_ic_03", @"itemIcon",
//                               @"我的收藏", @"itemName",
//                               @"", @"itemRemark",
//                               @"ic_more", @"itemArrow",nil];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"me_ic_04", @"itemIcon",
                              @"设置", @"itemName",
                              @"", @"itemRemark",
                              @"ic_more", @"itemArrow",
                              @"WLSettingDetailViewController", @"destination_xib",nil];
    
//    NSDictionary *helpCenter = [NSDictionary dictionaryWithObjectsAndKeys:
//                                @"me_ic_05", @"itemIcon",
//                                @"帮助中心", @"itemName",
//                                @"", @"itemRemark",
//                                @"ic_more", @"itemArrow",nil];
    
    //此处是设置了两个section 分别展示profile中的选项
    NSArray *itemsArr1 = @[exchangPower, myAccount];
    NSArray *itemsArr2 = @[settings];
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
