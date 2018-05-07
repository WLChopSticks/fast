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

@interface WLScanBitCodeViewController ()<SGQRCodeScanManagerDelegate>
@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) NSString *code;

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
    NSLog(@"WBQRCodeScanningVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.scanningView];
    [self setupNavigationBar];
    [self setupQRCodeScanning];
    [self.view addSubview:self.promptLabel];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"扫一扫";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
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

- (void)setupQRCodeScanning {
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
        [scanManager playSoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager stopRunning];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
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
            //扫柜子
            self.action = Scan_Canbin;
            self.code = obj.stringValue;
        }
        if (self.code.length > 0)
        {
            [self queryAquireCharger];
        }
       
    } else {
        NSLog(@"暂未识别出扫描的二维码");
    }
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
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
        aquireChargerModel = [WLAquireChargerModel getAquireChargerModel:result];
        if ([aquireChargerModel.code isEqualToString:@"1"])
        {
            NSLog(@"查询换电流程成功");
            [ProgressHUD showSuccess:aquireChargerModel.message];
        }else
        {
            [ProgressHUD showError:aquireChargerModel.message];
            NSLog(@"查询换电流程失败");
            [self.manager startRunning];
        }
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
