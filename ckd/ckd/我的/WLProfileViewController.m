//
//  WLProfileViewController.m
//  ckd
//
//  Created by wanglei on 2018/4/28.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLProfileViewController.h"
#import "WLPlatform.h"
#import "WLSettingDetailViewController.h"
#import "WLMyAccountController.h"
#import "WLMyApplyChargerRecordViewController.h"
#import "WLCertificationController.h"
#import "WLProfileInformationViewController.h"
#import "WLUserInfoMaintainance.h"
#import "WLMyRentMotorViewController.h"
#import "WLListView.h"

@interface WLProfileViewController ()<ListViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *profileInfoView;
@property (weak, nonatomic) IBOutlet UIView *myExchangeView;
@property (weak, nonatomic) IBOutlet UIView *myAccountView;
@property (weak, nonatomic) IBOutlet UIView *SettingsView;
@property (weak, nonatomic) IBOutlet UIView *ProfileItemsView;
@property (weak, nonatomic) IBOutlet UILabel *exchangeChargerTime;
@property (weak, nonatomic) IBOutlet UILabel *expireTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *myRentMotorView;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackView;

@property (nonatomic, weak) WLListView *listView;
@property (nonatomic, strong) NSMutableArray *items;



@end

@implementation WLProfileViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
    
    //定义此页面导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:93/255.0 blue:67/255.0 alpha:1.0];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIImage *navBackImage = [[UIImage imageNamed:@"nav_ic_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:navBackImage style:UIBarButtonItemStylePlain target:self action:@selector(backBtnDidClicking)];
    self.navigationItem.leftBarButtonItem = backBtn;

    
    //查询当天换电次数
    [self queryExchangeChargerTimeForToday];
    //查询月卡到期时间
    [self queryQinglogin];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    WLProfileView *view = [[WLProfileView alloc]initWithFrame:self.view.bounds];
//    view.itemsArr = [self getItemsForProfile];
//    view.delegate = self;
//    [self.view addSubview:view];
    
    self.title = @"个人中心";
    
    //设置圆角边框
    self.ProfileItemsView.layer.cornerRadius = 8;
    self.ProfileItemsView.layer.masksToBounds = YES;
    self.ProfileItemsView.backgroundColor = LightGrayBackground;
    
    [self initialiseView];
    
}

- (void)initialiseView
{
    WLListView *lists = [[WLListView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    self.listView = lists;
    lists.listItems = self.items;
    lists.delegate = self;
    lists.notScroll = YES;
    lists.isRadious = YES;
    [self.view addSubview:lists];
    NSInteger listViewHeight = 180;
    if ([WLUtilities isSupportMotor])
    {
        listViewHeight += 45;
    }
    [lists mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerBackView.mas_bottom).offset(-20);
        make.left.equalTo(self.view).offset(2*Margin);
        make.right.equalTo(self.view).offset(-2*Margin);
        make.height.mas_equalTo(listViewHeight);
    }];
    
}

- (void)ListView:(WLListView *)view selectListItem:(UITableViewCell *)sender andClickInfo:(NSString *)info
{
    if ([info isEqualToString:@"我的信息"])
    {
        NSLog(@"我的信息点击了");
        WLUserInfoMaintainance *userInfo = [WLUserInfoMaintainance sharedMaintain];
        if (userInfo.model.data.ztm.integerValue != 0)
        {
            NSLog(@"跳转我的信息页面");
            WLProfileInformationViewController *vc = [[WLProfileInformationViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            NSLog(@"跳转实名认证页面");
            WLCertificationController *certificationVC = [[WLCertificationController alloc]init];
            [self.navigationController pushViewController:certificationVC animated:YES];
        }
    }else if ([info isEqualToString:@"我的换电"])
    {
        NSLog(@"我的换电点击了");
        WLMyApplyChargerRecordViewController *chargerRecordVC = [[WLMyApplyChargerRecordViewController alloc]init];
        [self.navigationController pushViewController:chargerRecordVC animated:YES];
    }else if ([info isEqualToString:@"我的租车"])
    {
        NSLog(@"我的租车点击了");
        WLMyRentMotorViewController *chargerRecordVC = [[WLMyRentMotorViewController alloc]init];
        [self.navigationController pushViewController:chargerRecordVC animated:YES];
    }else if ([info isEqualToString:@"我的账户"])
    {
        NSLog(@"我的账户点击了");
        WLMyAccountController *destinatinVC = [[WLMyAccountController alloc]initWithNibName:@"WLMyAccountView" bundle:nil];
        [self.navigationController pushViewController:destinatinVC animated:YES];
    }else if ([info isEqualToString:@"设置"])
    {
        NSLog(@"我的设置点击了");
        WLSettingDetailViewController *destinatinVC = [[WLSettingDetailViewController alloc]initWithNibName:@"WLSettingDetailViewController" bundle:nil];
        [self.navigationController pushViewController:destinatinVC animated:YES];
    }
}

- (void)queryExchangeChargerTimeForToday
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *parametersStr = [NSString stringWithFormat:@"{user_id:%@}",[WLUtilities getUserID]];
    [parameters setObject:parametersStr forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"AquireExchangeTimesEveryday"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if ([result[@"code"] integerValue] == 1)
        {
            NSLog(@"查询今日换电次数成功");
            NSString *timesForToday = result[@"data"][@"hdcs"];
            NSString *exchangeCount = [NSString stringWithFormat:@"今日换电: %@次", timesForToday];
            [self reloadDataOnCell:@"subTitle" andValue:exchangeCount andCellName:@"我的换电"];
            
            
        }else
        {
            NSLog(@"查询今日换电次数失败");
        }
    } failure:^(NSError *error) {
        NSLog(@"获取缴费记录失败");
        NSLog(@"%@",error);
    }];
}

- (void)reloadDataOnCell: (NSString *)dataKey andValue: (NSString *)value andCellName: (NSString *)name
{
    int index = 0;
    for (NSMutableDictionary *dict in self.items)
    {
        if ([dict[@"title"] isEqualToString:name])
        {
            dict[dataKey] = value;
            [self.listView.listView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation: UITableViewRowAnimationFade];
        }
        index++;
    }
}

- (void)queryQinglogin
{
    [[WLUserInfoMaintainance sharedMaintain]queryUserInfo:^(NSNumber *result) {
        //如果成功则显示到期时间
        if ([result boolValue])
        {
            NSArray *expireTimeArr = [[[[WLUserInfoMaintainance sharedMaintain]model]data]list];
            for (WLUserExpireTimeModel *model in expireTimeArr)
            {
                //租金
                if ([model.fylxdm isEqualToString:@"2"])
                {
                    NSString *expireTime = [NSString stringWithFormat:@"%@ 到期",model.jssj];
                    [self reloadDataOnCell:@"subTitle" andValue:expireTime andCellName:@"我的账户"];
                    break;
                }
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)items
{
    if (_items == nil)
    {
        NSMutableArray *itemArrm = [NSMutableArray array];
        [itemArrm addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"icon":@"我的", @"title":@"我的信息", @"subTitle":@"", @"subImage":@"", @"rowHeight":@"45", @"click": @"我的信息"}]];
        [itemArrm addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"icon":@"me_ic_01", @"title":@"我的换电", @"subTitle":@"", @"subImage":@"", @"rowHeight":@"45", @"click": @"我的换电"}]];
        
        if ([WLUtilities isSupportMotor])
        {
            [itemArrm addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"icon":@"WDZC", @"title":@"我的租车", @"subTitle":@"", @"subImage":@"", @"rowHeight":@"45", @"click": @"我的租车"}]];
        }
        
        [itemArrm addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"icon":@"me_ic_02", @"title":@"我的账户", @"subTitle":@"", @"subImage":@"", @"rowHeight":@"45", @"click": @"我的账户"}]];
        [itemArrm addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"icon":@"me_ic_04", @"title":@"设置", @"subTitle":@"", @"subImage":@"ic_more", @"rowHeight":@"45", @"click": @"设置"}]];
        
        _items = [itemArrm copy];
    }
    return _items;
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
