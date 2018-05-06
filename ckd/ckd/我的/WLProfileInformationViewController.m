//
//  WLProfileInformationViewController.m
//  ckd
//
//  Created by 王磊 on 2018/5/5.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLProfileInformationViewController.h"
#import "WLQingLoginModel.h"
#import "WLChangeTelephoneNumberViewController.h"
#import "WLPlatform.h"
#import "WLChargerStationModel.h"
#import "WLChosenItemsView.h"

@interface WLProfileInformationViewController ()<chosenViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ID_numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UIView *telephoneView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIView *cityView;

@property (nonatomic, strong) NSArray *cityList;
@property (nonatomic, strong) WLCityData *currentCity;


@end

@implementation WLProfileInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的信息";
    //选项添加点击事件
    [self addViewGestures];
    //请求个人详细信息
    [self queryProfileInfo];
}

- (void)addViewGestures
{
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(telephoneItemDidClicking)];
    [self.telephoneView addGestureRecognizer:tapGesture1];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cityItemDidClicking)];
    [self.cityView addGestureRecognizer:tapGesture2];
}

- (void)queryProfileInfo
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *parametersStr = [NSString stringWithFormat:@"{user_id:%@}",[WLUtilities getUserID]];
    [parameters setObject:parametersStr forKey:@"inputParameter"];
    NSString *URL = @"http://47.104.85.148:18070/ckdhd/qLogin.action";
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        WLQingLoginModel *model = [WLQingLoginModel getQingLoginModel:result];
        if ([model.code integerValue] == 1)
        {
            NSLog(@"获取验证码成功");
            [ProgressHUD showSuccess:@"发送验证码成功"];
            [self showProfileInfoDetails:model];
        }else
        {
            NSLog(@"获取验证码失败");
            [ProgressHUD showError:@"发送验证码失败"];
        }
    } failure:^(NSError *error) {
        NSLog(@"获取验证码失败");
        NSLog(@"%@",error);
        [ProgressHUD showError:@"发送验证码失败"];
    }];
}

- (void)showProfileInfoDetails: (WLQingLoginModel *)model
{
    self.nameLabel.text = model.data.user_realname;
    self.ID_numberLabel.text = model.data.idcard;
    self.telephoneLabel.text = model.data.user_phone;
    self.cityLabel.text = model.data.csmc;
}

- (void)telephoneItemDidClicking
{
    NSLog(@"电话号码点击了");
    WLChangeTelephoneNumberViewController *changeTelNumberVC = [[WLChangeTelephoneNumberViewController alloc]init];
    [self.navigationController pushViewController:changeTelNumberVC animated:YES];
}

- (void)cityItemDidClicking
{
    NSLog(@"城市选项点击了");
    [ProgressHUD show];
    [[WLCommonAPI sharedCommonAPIManager]aquireCityList:^(id result) {
        if ([result isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *resultDict = (NSDictionary *)result;
            WLChargerStationModel *chargerStationModel = [[WLChargerStationModel alloc]init];
            chargerStationModel = [chargerStationModel getChargerStationModel:resultDict];
            if ([chargerStationModel.code isEqualToString:@"1"])
            {
                NSLog(@"查询城市信息成功");
                self.cityList= chargerStationModel.data;
                [ProgressHUD dismiss];
                [self createCityListView];
            }else
            {
                NSLog(@"查询城市信息失败");
                [ProgressHUD showError:@"请求城市列表失败"];
            }
        }else
        {
            NSLog(@"请求城市列表失败");
            [ProgressHUD showError:@"请求城市列表失败"];
        }
    }];
}

- (void)createCityListView
{
    WLChosenItemsView *cityListView = [[WLChosenItemsView alloc]initWithFrame:Screen_Bounds andChosenItems:self.cityList];
    cityListView.delegate = self;
    [self.view addSubview:cityListView];
}

#pragma --mark cityListView delegate
-(void)chosenView:(WLChosenItemsView *)view didSelectItemInListView:(id)item
{
    WLCityData *model = (WLCityData *)item;
    self.cityLabel.text = model.csmc;
    self.currentCity = model;
    NSLog(@"选择了城市%@",model.csmc);
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
