//
//  WLScanBitCodeViewController.m
//  ckd
//
//  Created by 王磊 on 2018/4/30.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLScanBitCodeViewController.h"
#import "SGQRCode.h"
#import "WLHomeViewController.h"
#import "WLAquireChargerModel.h"
#import "UIButton+WLVerticalImageTitle.h"

@interface WLScanBitCodeViewController ()<SGQRCodeScanManagerDelegate>
@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *previousScanResult;
@property (nonatomic, strong) NSDate *previousScanTime;

@end

@implementation WLScanBitCodeViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
}

- (void)dealloc {
    NSLog(@"scanBitCodeVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.scanningView];
    [self decorateNavigationBar];
    [self decorateQRCodeScanning];
    [self.view addSubview:self.promptLabel];
    
    UIButton *torchBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    [torchBtn setImage:[UIImage imageNamed:@"ic_flashlight"] forState:UIControlStateNormal];
    [torchBtn setImage:[UIImage imageNamed:@"ic_flashlight_open"] forState:UIControlStateSelected];
    [torchBtn addTarget:self action:@selector(torchBtnDidClicking:) forControlEvents:UIControlEventTouchUpInside];
    
    [torchBtn setTitle:@"轻触打开" forState:UIControlStateNormal];
    [torchBtn setTitle:@"轻触关闭" forState:UIControlStateSelected];
    [torchBtn layoutButtonWithEdgeInsetsStyle:WLButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [self.view addSubview:torchBtn];

    [torchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.mas_bottom).offset(Margin);
        make.centerX.equalTo(self.view.mas_centerX);
//        make.width.height.mas_equalTo(70);
    }];

}

- (void)decorateNavigationBar
{
    self.navigationItem.title = @"扫一扫";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:Screen_Bounds];
        CGFloat offset = self.navigationController.navigationBar.frame.size.height + 20;
        _scanningView.center = CGPointMake(self.view.center.x, self.view.center.y- offset);
        _scanningView.scanningImageName = @"qrcode_line";
        _scanningView.scanningAnimationStyle = ScanningAnimationStyleDefault;
        _scanningView.cornerColor = [UIColor orangeColor];
    }
    return _scanningView;
}
- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)rightBarButtonItenAction {
    SGQRCodeAlbumManager *manager = [SGQRCodeAlbumManager sharedManager];
    [manager readQRCodeFromAlbumWithCurrentController:self];
//    manager.delegate = self;
    
    if (manager.isPHAuthorization == YES) {
        [self.scanningView removeTimer];
    }
}

- (void)decorateQRCodeScanning
{
    self.manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    [_manager cancelSampleBufferDelegate];
    _manager.delegate = self;
}

#pragma mark - - - SGQRCodeScanManagerDelegate
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    NSLog(@"metadataObjects - - %@", metadataObjects);
    if (metadataObjects != nil && metadataObjects.count > 0) {
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        //如果扫描的二维码与上一次相同, 则五秒内不予响应
        if ([obj.stringValue isEqualToString:self.previousScanResult] &&
            [[NSDate date] timeIntervalSinceDate:self.previousScanTime] < 5 )
            return;
        
        self.previousScanResult = obj.stringValue;
        self.previousScanTime = [NSDate date];

        [scanManager playSoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager stopRunning];
        
        //如果扫到的是json则说明扫的是电池的码
        //dg18040001
        //{"code":"KTS000003","chk":"780e81f1650d63b7b646a66871d05e2d"}
        if ([obj.stringValue hasPrefix:@"{"])
        {
            //扫电池
            self.action = Get_Charger;
            NSData *jsonData =  [obj.stringValue dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            self.code = [dict objectForKey:@"code"];
        }else
        {
            if (self.action == Return_Charger)
            {
                
            }else
            {
                //扫柜子
                self.action = Scan_Canbin;
            }
            self.code = obj.stringValue;
        }
        if (self.code.length > 0)
        {
            [self queryAquireCharger];
        }
    } else
    {
        NSLog(@"暂未识别出扫描的二维码");
    }
}

- (void)torchBtnDidClicking: (UIButton *)sender
{
    sender.selected = !sender.selected;
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil)
    {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) { // 判断是否有闪光灯
            // 请求独占访问硬件设备
            [device lockForConfiguration:nil];
            if (sender.selected == YES)
            {
                [device setTorchMode:AVCaptureTorchModeOn]; // 手电筒开
            }else
            {
                [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
            }
            // 请求解除独占访问硬件设备
            [device unlockForConfiguration];
        }
    }
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat offset = self.navigationController.navigationBar.frame.size.height;
        CGFloat promptLabelY = self.view.center.y - offset + 0.5 * 0.7 * self.view.frame.size.width;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}




//换电池流程
- (void)queryAquireCharger
{
    //是否是第一次换电池, 如果用户信息下没有电池记录, 则是第一次, 扫开柜子后即返回首页
    BOOL isFirstExchange = [WLUserInfoMaintainance sharedMaintain].model.data.dcdm.length > 0 ? NO : YES;
    NSString *actionType = [self getScanActionType];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *para_String = [NSString stringWithFormat:@"{user_id:%@,zlbj:%@,hdcbj:%@}",[WLUtilities getUserID], self.code, actionType];
    [parameters setObject:para_String forKey:@"inputParameter"];
    WLNetworkTool *networkTool = [WLNetworkTool sharedNetworkToolManager];
    NSString *URL = networkTool.queryAPIList[@"ExchangeChargerProgress"];
    [networkTool POST_queryWithURL:URL andParameters:parameters success:^(id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSDictionary *result = (NSDictionary *)responseObject;
        WLAquireChargerModel *aquireChargerModel = [[WLAquireChargerModel alloc]init];
        aquireChargerModel = [aquireChargerModel getAquireChargerModel:result];
        if ([aquireChargerModel.code isEqualToString:@"1"])
        {
            NSLog(@"查询换电流程成功");
            if (self.action == Return_Charger)
            {
                [ProgressHUD showSuccess:@"退电成功"];
            }else
            {
                [ProgressHUD showSuccess:aquireChargerModel.message];
            }
            __weak WLScanBitCodeViewController *weakSelf = self;
            //换电流程完成后要更新用户信息
            [[WLUserInfoMaintainance sharedMaintain]queryUserInfo:^(NSNumber *result) {

                //退电池和换电池成功后 回首页
                if (weakSelf.action == Return_Charger || weakSelf.action == Get_Charger ||
                    (isFirstExchange && weakSelf.action == Scan_Canbin))
                {
                    for (UIViewController *vc in weakSelf.navigationController.viewControllers)
                    {
                        if ([vc isKindOfClass:[WLHomeViewController class]])
                        {
                            [weakSelf.navigationController popToViewController:vc animated:NO];
                        }
                    }
                }
            }];
        }else
        {
            if (self.action == Return_Charger)
            {
                [ProgressHUD showError:@"退电失败"];
            }else
            {
                [ProgressHUD showError:aquireChargerModel.message];
            }
            NSLog(@"查询换电流程失败");
        }
        __weak WLScanBitCodeViewController *weakSelf = self;
        //如果是扫柜子, 或者退电换电失败 都要重新开始扫描
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.manager startRunning];
        });
    } failure:^(NSError *error) {
        [ProgressHUD showError:@"查询换电流程失败"];
        NSLog(@"查询换电流程失败");
        NSLog(@"%@",error);
        [self.manager startRunning];
    }];
}

- (NSString *)getScanActionType
{
    NSString *actionStr;
    switch (self.action)
    {
        case Scan_Canbin:
            actionStr = @"0";
            break;
        case Get_Charger:
            actionStr = @"2";
            break;
        case Return_Charger:
            actionStr = @"1";
            break;
            
        default:
            break;
    }
    return actionStr;
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
