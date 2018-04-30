//
//  WLMapViewController.m
//  ckd
//
//  Created by 王磊 on 2018/4/30.
//  Copyright © 2018年 wanglei. All rights reserved.
//

#import "WLMapViewController.h"
#import "WLMapAnnotationView.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface WLMapViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;
@property (nonatomic, strong) BMKPointAnnotation *pointAnnotation;

@end

@implementation WLMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_mapView];
    self.locService = [[BMKLocationService alloc]init];
    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
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
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [self.mapView updateLocationData:userLocation];
    [self.locService stopUserLocationService];
    
//    self.pointAnnotation = [[BMKPointAnnotation alloc] init];
//    self.pointAnnotation.coordinate = userLocation.location.coordinate;
//    self.pointAnnotation.title = @"我在这个地方";
//    self.pointAnnotation.subtitle = @"你在哪呢";
//    [self.mapView addAnnotation:_pointAnnotation];
//    [self.mapView selectAnnotation:_pointAnnotation animated:YES];
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    //if ([annotation isKindOfClass:[BMKPointAnnotation class]]) //判断是哪个BMKPointAnnotation
    WLMapAnnotationView *newAnnotationView = (WLMapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"available"];
    if (newAnnotationView == nil) {
        newAnnotationView = [[WLMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"available"];
    }
    return newAnnotationView;
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
