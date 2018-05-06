
//
//  WLCustomerServiceViewController.m
//  ckd
//
//  Created by wanglei on 2018/5/4.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLCustomerServiceViewController.h"

#define First_ServiceTelePhone_Number @"13527700031"

@interface WLCustomerServiceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *firstTelephoneLabel;

@end

@implementation WLCustomerServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"客服";
    self.firstTelephoneLabel.text = First_ServiceTelePhone_Number;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)firstTelephoneBtnDidCLicking:(id)sender
{
    NSLog(@"客服电话按钮点击了");
    [self dialTelephoneNumber:self.firstTelephoneLabel.text];
}
- (IBAction)submitBtnDidCLicking:(id)sender
{
    NSLog(@"客服电话按钮点击了");
    [self dialTelephoneNumber:self.firstTelephoneLabel.text];
}

//拨打电话
- (void)dialTelephoneNumber: (NSString *)tel_num
{
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",tel_num];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//    NSString *prompStr = [NSString stringWithFormat:@"是否要拨打客服电话:\n %@",tel_num];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:prompStr preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        
//    }];
//    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//    }];
//                          
//    // Add the actions.
//    [alertController addAction:cancelAction];
//    [alertController addAction:otherAction];
//    [self presentViewController:alertController animated:YES completion:nil];
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
