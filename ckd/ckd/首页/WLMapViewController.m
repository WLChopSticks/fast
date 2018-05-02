//
//  WLMapViewController.m
//  ckd
//
//  Created by 王磊 on 2018/4/30.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLMapViewController.h"
#import "WLPlatform.h"
#import "WLMapAnnotationView.h"
#import "WLPointAnnotation.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "WLEachChargerStationModel.h"
#import "WLStationDetailPromptView.h"

@interface WLMapViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;
@property (nonatomic, strong) BMKPointAnnotation *pointAnnotation;
@property (nonatomic, weak) WLStationDetailPromptView *stationDetailpromptView;

@property (nonatomic, strong) NSMutableArray *displayingAnnomation;

@end

@implementation WLMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_mapView];
    self.locService = [[BMKLocationService alloc]init];
    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
    self.displayingAnnomation = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.locService.delegate = self;
    self.geocodesearch.delegate = self;
    
    self.mapView.zoomLevel = 14.1; //地图等级，数字越大越清晰
    self.mapView.showsUserLocation = YES;//是否显示定位小蓝点，no不显示，我们下面要自定义的(这里显示前提要遵循代理方法，不可缺少)
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    //定位
    [self.locService startUserLocationService];
    
}

-(void)startGetUserPosition
{
    [self.locService startUserLocationService];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.locService.delegate = nil;
    self.geocodesearch.delegate = nil;
}

#pragma -mark 代理方法
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
    [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [self.mapView updateLocationData:userLocation];
    
    //关闭坐标更新
    [self.locService stopUserLocationService];
}




-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    //if ([annotation isKindOfClass:[BMKPointAnnotation class]]) //判断是哪个BMKPointAnnotation
    WLMapAnnotationView *newAnnotationView = (WLMapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"available"];
    if (newAnnotationView == nil) {
        newAnnotationView = [[WLMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"available"];
    }

    newAnnotationView.enabled = YES;
    newAnnotationView.annotation = annotation;
    
    UIButton *touchBtn = [[UIButton alloc]initWithFrame:newAnnotationView.bounds];
    touchBtn.backgroundColor = [UIColor clearColor];
    touchBtn.tag = newAnnotationView.tag;
    [touchBtn addTarget:self action:@selector(annotationDidClicking:) forControlEvents:UIControlEventTouchUpInside];
    [newAnnotationView addSubview:touchBtn];
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(annotationDidClicking:)];
//    [newAnnotationView addGestureRecognizer:gesture];
//    WLPointAnnotation *myAnnotation = annotation;
//    newAnnotationView.tag = myAnnotation.tag;
    return newAnnotationView;
}

- (void)annotationDidClicking: (UIButton *)sender
{
    NSLog(@"123");
    NSLog(@"%ld",(long)sender.tag);
    [self showStationInfoPrompt:sender.tag];
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"123");
}

- (void)showStationInfoPrompt: (NSInteger)index
{
    [self.stationDetailpromptView removeFromSuperview];
    WLStationDetailPromptView *stationInfoPromtView = [WLStationDetailPromptView instanceView];
    self.stationDetailpromptView = stationInfoPromtView;
    stationInfoPromtView.frame = CGRectMake(0, 0, Screen_Width, 160);
    stationInfoPromtView.backgroundColor = [UIColor whiteColor];
    WLEachChargerStationInfoModel *model = self.LocationOfStations[index];
    stationInfoPromtView.stationName.text = model.zdmc;
    stationInfoPromtView.stationAddress.text = model.zddz;
//    stationInfoPromtView.stationTelephone.text = model.zddm;
    stationInfoPromtView.chargerCount.text = model.dcsl;
    [stationInfoPromtView.collectionBtn setImage:[UIImage imageNamed:@"ic_collect"] forState:UIControlStateNormal];
    [self.view.superview addSubview:stationInfoPromtView];
    
}

-(void)getLocationOfStationsInCurrentCity
{
    //先移除地图上所有的大头针
    if (self.displayingAnnomation.count > 0)
    {
        [self.mapView removeAnnotations:self.displayingAnnomation];
    }
    //将每个大头针显示在地图上
    for (int i = 0; i < self.LocationOfStations.count; i++)
    {
        WLEachChargerStationInfoModel *model = self.LocationOfStations[i];
        WLPointAnnotation* annotation = [[WLPointAnnotation alloc]init];
        annotation.tag = i;
        CLLocationCoordinate2D coor;
        coor.latitude = model.zdwd.floatValue;
        coor.longitude = model.zdjd.floatValue;
        annotation.coordinate = coor;
        [self.mapView addAnnotation:annotation];
        [self.displayingAnnomation addObject:annotation];
    }
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
