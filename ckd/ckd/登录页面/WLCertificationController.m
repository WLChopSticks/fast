//
//  WLCertificationController.m
//  ckd
//
//  Created by 王磊 on 2018/5/5.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLCertificationController.h"
#import "WLChargerStationModel.h"
#import "WLHomeViewController.h"
#import "WLBootViewController.h"
#import "WLChosenItemsView.h"

@interface WLCertificationController ()<chosenViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *IDNumberField;
@property (weak, nonatomic) IBOutlet UILabel *currentCity;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (nonatomic, strong) NSArray *cityList;
@property (nonatomic, strong) WLCityData *currentCityModel;
@property (nonatomic, weak) UIView *cityListBackView;



@end

@implementation WLCertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"实名认证";
    
    //所在城市选项添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseCityGestureDidClicking)];
    [self.locationView addGestureRecognizer:tapGesture];
}

- (void)chooseCityGestureDidClicking
{
    NSLog(@"选择城市列表");
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

#pragma --mark citylistView delegate
-(void)chosenView:(WLChosenItemsView *)view didSelectItemInListView:(id)item
{
    WLCityData *model = (WLCityData *)item;
    self.currentCity.text = model.csmc;
    self.currentCityModel = model;
}

//提交按钮点击
- (IBAction)submitBtnDidClicking:(id)sender
{
    //不满足条件, 不发请求
    if (self.nameField.text.length <= 0)
    {
        [ProgressHUD showError:@"请输入姓名"];
        return;
    }else if (self.IDNumberField.text.length != 18)
    {
        [ProgressHUD showError:@"请输入身份证号"];
        return;
    }else if ([self.currentCity.text isEqualToString:@"请选择所在城市"])
    {
        [ProgressHUD showError:@"请选择城市"];
        return;
    }
    
    [self queryCompletePrivateInformation];
    
}

//完善个人信息请求
- (void)queryCompletePrivateInformation
{
    NSLog(@"提交按钮点击了");
    
    [ProgressHUD show];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *user_phone_string = [NSString stringWithFormat:@"{user_id:%@,area_id:%@,idcard:%@,user_realname:%@}",[WLUtilities getUserID],self.currentCityModel.csdm,self.IDNumberField.text,self.nameField.text];
    [parameters setObject:user_phone_string forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"CompletePrivateInformation"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqualToString:@"1"])
        {
            NSLog(@"完善个人资料成功");
            [ProgressHUD showSuccess:[NSString stringWithFormat:@"%@",result[@"message"]]];
            [WLUtilities setUserNameRegist];
            [WLUtilities savuserName:self.nameField.text];
            [WLUtilities saveCurrentCityCode:self.currentCityModel.csdm andCityName:self.currentCityModel.csmc];
            
            WLHomeViewController *homeVC = [[WLHomeViewController alloc]init];
            for (UIViewController *vc in self.navigationController.viewControllers)
            {
                if ([vc isKindOfClass:[WLBootViewController class]])
                {
                    [self.navigationController popToViewController:vc animated:NO];
                    [vc.navigationController pushViewController:homeVC animated:YES];
                }
            }
            
        }
        else
        {
            NSLog(@"完善个人资料失败");
            [ProgressHUD showError:[NSString stringWithFormat:@"%@",result[@"message"]]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"完善个人资料失败");
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error.description]];
        
    }];
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
