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


#define Cell_ID @"cityName"
#define Cell_Height_Citylist 45

@interface WLCertificationController ()<UITableViewDelegate, UITableViewDataSource>

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
    [self aquireCityList:^(NSNumber *completeQuery) {
        if ([completeQuery boolValue] == YES)
        {
            NSLog(@"调起view选择城市");
            [self createCityListView];
        }else{
            NSLog(@"请求城市列表失败");
        }
    }];
}

- (void)createCityListView
{
    UIView *cityListBackView = [[UIView alloc]init];
    self.cityListBackView = cityListBackView;
    cityListBackView.backgroundColor = [UIColor blackColor];
    cityListBackView.alpha = 0.5;
    [self.view addSubview:cityListBackView];
    
    UITableView *citylistView = [[UITableView alloc]init];
    citylistView.delegate = self;
    citylistView.dataSource = self;
    [self.view addSubview:citylistView];
    [citylistView registerClass:[UITableViewCell class] forCellReuseIdentifier:Cell_ID];
    
    [cityListBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [citylistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(Cell_Height_Citylist * self.cityList.count);
    }];
    
}

#pragma --mark tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cityList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_ID forIndexPath:indexPath];
    WLCityData *model = self.cityList[indexPath.row];
    cell.textLabel.text = model.csmc;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.hidden = YES;
    self.cityListBackView.hidden = YES;
    self.currentCityModel = self.cityList[indexPath.row];
    self.currentCity.text = self.currentCityModel.csmc;
    [tableView removeFromSuperview];
    [self.cityListBackView removeFromSuperview];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Cell_Height_Citylist;
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

//获取城市列表
- (void)aquireCityList:(void (^)(NSNumber *))completeQuery
{
    [ProgressHUD show];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *URL = @"http://47.104.85.148:18070/ckdhd/quickCs.action";
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSDictionary *result = (NSDictionary *)responseObject;
        WLChargerStationModel *chargerStationModel = [[WLChargerStationModel alloc]init];
        chargerStationModel = [chargerStationModel getChargerStationModel:result];
        if ([chargerStationModel.code isEqualToString:@"1"])
        {
            NSLog(@"查询城市信息成功");
            //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //            [defaults setObject:chargerStationModel.data forKey:@"cityList"];
            self.cityList= chargerStationModel.data;
            completeQuery([NSNumber numberWithBool:YES]);
        }else
        {
            NSLog(@"查询城市信息失败");
            completeQuery([NSNumber numberWithBool:NO]);
        }
    } failure:^(NSError *error) {
        NSLog(@"查询城市信息失败");
        completeQuery([NSNumber numberWithBool:NO]);
    }];
}

//完善个人信息请求
- (void)queryCompletePrivateInformation
{
    NSLog(@"提交按钮点击了");
    
    [ProgressHUD show];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *user_phone_string = [NSString stringWithFormat:@"{user_id:%@,area_id:%@,idcard:%@,user_realname:%@}",[WLUtilities getUserID],self.currentCityModel.csdm,self.IDNumberField.text,self.nameField.text];
    [parameters setObject:user_phone_string forKey:@"inputParameter"];
    NSString *URL = @"http://47.104.85.148:18070/ckdhd/updateUser.action";
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
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
