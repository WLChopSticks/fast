//
//  WLConfigHostViewController.m
//  ckd
//
//  Created by 王磊 on 2018/5/10.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLConfigHostViewController.h"

@interface WLConfigHostViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *hosts;

@end

@implementation WLConfigHostViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    UITableView *tableView = [[UITableView alloc]initWithFrame:Screen_Bounds];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"QueryApiList.plist" ofType:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *hosts = dict[@"hosts"];
    self.hosts = hosts;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hosts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.hosts[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *host = self.hosts[indexPath.row];
    NSString *selectHost = [[host componentsSeparatedByString:@","]lastObject];
    [WLNetworkTool sharedNetworkToolManager].currentHost = selectHost;
    [WLNetworkTool refreshQueryAPIList];
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
