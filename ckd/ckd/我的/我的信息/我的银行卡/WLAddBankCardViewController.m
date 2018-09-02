//
//  WLAddBankCardViewController.m
//  ckd
//
//  Created by 王磊 on 2018/9/2.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLAddBankCardViewController.h"

@interface WLAddBankCardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *bankCardHolder;
@property (weak, nonatomic) IBOutlet UITextField *bankCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *bankName;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;



@end

@implementation WLAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self isFirstAddBankCard])
    {
        self.title = @"添加银行卡";
        
    }else
    {
        self.title = @"更改银行卡";
        self.bankCardHolder.text = self.bankCardInfo.ckrxm;
        self.bankCardNumber.text = self.bankCardInfo.yhkh;
        self.bankName.text = self.bankCardInfo.yhmc;
    }
    [WLCommonTool makeViewShowingWithRoundCorner:self.saveBtn andRadius:8];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveBtnDidClicking:(id)sender
{
    [ProgressHUD show];
    if ([self isFirstAddBankCard])
    {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSString *para_String = [NSString stringWithFormat:@"{user_id:\'%@\',yhkh:%@,yhmc:%@,sfmr:%@,ckrxm:%@}",[WLUtilities getUserID],self.bankCardNumber.text, self.bankName.text, self.defaultCardPara, self.bankCardHolder.text];
        [parameters setObject:para_String forKey:@"inputParameter"];
        WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
        NSString *URL = networkTool.queryAPIList[@"AddBankCardInfo"];
        [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
            [ProgressHUD dismiss];
            NSDictionary *result = (NSDictionary *)responseObject;
            NSString *message = result[@"message"];
            if ([result[@"code"]integerValue] && [message containsString:@"成功"])
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:^(NSError *error) {
            [ProgressHUD showError:@"添加银行卡失败"];
        }];
    }else
    {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSString *para_String = [NSString stringWithFormat:@"{lsh:\'%@\',user_id:\'%@\',yhkh:%@,yhmc:%@,sfmr:%@,ckrxm:%@}",self.bankCardInfo.lsh, [WLUtilities getUserID],self.bankCardNumber.text, self.bankName.text, self.defaultCardPara, self.bankCardHolder.text];
        [parameters setObject:para_String forKey:@"inputParameter"];
        WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
        NSString *URL = networkTool.queryAPIList[@"UpdateBankCardInfo"];
        [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
            NSDictionary *result = (NSDictionary *)responseObject;
            NSString *message = result[@"message"];
            [ProgressHUD showSuccess:message];
            if ([result[@"code"]integerValue] && [message containsString:@"成功"])
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:^(NSError *error) {
            [ProgressHUD showError:@"更新银行卡失败"];
        }];
    }
}

- (BOOL)isFirstAddBankCard
{
    return self.bankCardInfo == nil;
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
