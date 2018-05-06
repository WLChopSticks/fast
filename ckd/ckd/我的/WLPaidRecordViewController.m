//
//  WLPaidRecordViewController.m
//  ckd
//
//  Created by 王磊 on 2018/5/6.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLPaidRecordViewController.h"
#import "WLRecordEmptyView.h"
#import "WLPlatform.h"
#import "WLPaidRecordModel.h"

@interface WLPaidRecordViewController ()

@end

@implementation WLPaidRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"缴费记录";
    
    if ([WLUtilities isUserLogin])
    {
        [self queryPaidRecordDetail];
    }else
    {
        [self showEmptyRecordView];
    }
    
}

- (void)queryPaidRecordDetail
{
    [ProgressHUD show];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *parametersStr = [NSString stringWithFormat:@"{user_id:%@}",[WLUtilities getUserID]];
    [parameters setObject:parametersStr forKey:@"inputParameter"];
    NSString *URL = @"http://47.104.85.148:18070/ckdhd/queryJfjl.action";
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        WLPaidRecordModel *model = [WLPaidRecordModel getPaidRecordModel:result];
        
        if ([model.code integerValue] == 1)
        {
            NSLog(@"获取缴费记录成功");
            [ProgressHUD showSuccess:model.message];
        }else
        {
            NSLog(@"获取缴费记录失败");
            [ProgressHUD showError:model.message];
            [self showEmptyRecordView];
        }
    } failure:^(NSError *error) {
        NSLog(@"获取缴费记录失败");
        NSLog(@"%@",error);
        [ProgressHUD showError:@"获取缴费记录失败"];
        [self showEmptyRecordView];
    }];
}

- (void)showEmptyRecordView
{
    WLRecordEmptyView *emptyView = [[WLRecordEmptyView alloc]initWithFrame:Screen_Bounds];
    [self.view addSubview:emptyView];
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
