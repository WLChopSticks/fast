//
//  WLRealNameAuthenticationViewController.m
//  ckd
//
//  Created by 王磊 on 2018/5/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLRealNameAuthenticationViewController.h"
#import "WLChargerStationModel.h"
#import "WLPlatform.h"
#import "WLPaidDepositViewController.h"

#define Cell_Height 50

@interface WLRealNameAuthenticationViewController ()<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *realNameTableView;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic, strong) NSArray *cityList;
@property (nonatomic, strong) UITextField *currentCityField;
@property (nonatomic, strong) WLCityData *currentCity;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ID_number;




@end

@implementation WLRealNameAuthenticationViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.realNameTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextBtnDidClicking:(id)sender
{
    NSLog(@"提交按钮点击了");
    
    [ProgressHUD show];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *user_phone_string = [NSString stringWithFormat:@"{user_id:%@,area_id:%@,idcard:%@,user_realname:%@}",[WLUtilities getUserID],self.currentCity.csdm,self.ID_number,self.name];
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
            [WLUtilities saveCurrentCityCode:self.currentCity.csdm andCityName:self.currentCity.csmc];
            [self jumpToPaidDepositVC];
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

- (void)aquireCityList:(void (^)(NSNumber *))completeQuery
{
    [ProgressHUD show];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //    NSString *user_phone_string = [NSString stringWithFormat:@"{user_phone:%@}",telephone];
    //    [parameters setObject:user_phone_string forKey:@"inputParameter"];
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

#pragma --mark 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"realNameCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"realNameCell"];
    }
    
    
    
    
    if (indexPath.row == 0)
    {
        UILabel *nameLabel = [[UILabel alloc]init];
        [cell.contentView addSubview:nameLabel];
        UITextField *value = [[UITextField alloc]init];
        value.tag = 1;
        value.delegate = self;
        [cell.contentView addSubview:value];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(cell.contentView.mas_left).offset(Margin);
            make.width.mas_equalTo(80);
        }];
        
        [value mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(nameLabel.mas_right).offset(Margin);
            make.right.equalTo(cell.contentView.mas_right).offset(-Margin * 4);
        }];
        nameLabel.text = @"姓名";
        value.placeholder = @"请输入姓名";
    }
    if (indexPath.row == 1)
    {
        UILabel *nameLabel = [[UILabel alloc]init];
        [cell.contentView addSubview:nameLabel];
        UITextField *value = [[UITextField alloc]init];
        value.tag = 2;
        value.delegate = self;
        [cell.contentView addSubview:value];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(cell.contentView.mas_left).offset(Margin);
            make.width.mas_equalTo(80);
        }];
        
        [value mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(nameLabel.mas_right).offset(Margin);
            make.right.equalTo(cell.contentView.mas_right).offset(-Margin * 4);
        }];
        nameLabel.text = @"身份证号";
        value.placeholder = @"请输入身份证号";
    }
    if (indexPath.row == 2)
    {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        UILabel *nameLabel = [[UILabel alloc]init];
        [cell.contentView addSubview:nameLabel];
        UILabel *value = [[UILabel alloc]init];
        [cell.contentView addSubview:value];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(cell.contentView.mas_left).offset(Margin);
            make.width.mas_equalTo(80);
        }];
        
        [value mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(nameLabel.mas_right).offset(Margin);
            make.right.equalTo(cell.contentView.mas_right).offset(-Margin * 4);
        }];
        nameLabel.text = @"所在地";
        value.text = self.currentCity.csmc.length > 0 ? self.currentCity.csmc : @"请选择所在城市";
        value.userInteractionEnabled = NO;
        UIImageView *arrowImageView = [[UIImageView alloc]init];
        arrowImageView.image = [UIImage imageNamed:@"ic_more"];
        [cell.contentView addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.equalTo(cell.contentView.mas_right).offset(-Margin);
            make.height.with.mas_equalTo(20);
        }];
    }
    //    WLRealNameIdentifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"realNameCell"];
    //    if (cell == nil)
    //    {
    //        cell = [[[NSBundle mainBundle]loadNibNamed:@"WLRealNameIdentifyCell" owner:nil options:nil]lastObject];
    //    }
    //    cell.textLabel.text = @"123";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        [self aquireCityList:^(NSNumber *completeQuery) {
            if ([completeQuery boolValue] == YES)
            {
                NSLog(@"调起pickview选择城市");
                [self createPickerView];
            }else{
                NSLog(@"请求城市列表失败");
            }
        }];
        
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Cell_Height;
}

#pragma --mark pickerview

- (void)createPickerView
{
    UIPickerView *cityListPickerView = [[UIPickerView alloc]init];
    cityListPickerView.backgroundColor = [UIColor grayColor];
    cityListPickerView.showsSelectionIndicator=YES;
    cityListPickerView.dataSource = self;
    cityListPickerView.delegate = self;
    [self.view addSubview:cityListPickerView];
    
    [cityListPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
}

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.cityList.count;
}

// 每列宽度
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//
//    if (component == 1) {
//        return 40;
//    }
//    return 180;
//}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.currentCity = self.cityList[row];
    [self.realNameTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    
    [pickerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    [pickerView removeFromSuperview];
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    WLCityData *city = self.cityList[row];
    return city.csmc;
}

#pragma --mark textfield delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1)
    {
        self.name = textField.text;
    }
    if (textField.tag == 2)
    {
        self.ID_number = textField.text;
    }
}

- (void)jumpToPaidDepositVC
{
    WLPaidDepositViewController *paidDepositVC = [[WLPaidDepositViewController alloc]init];
    [self.navigationController pushViewController:paidDepositVC animated:YES];
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
