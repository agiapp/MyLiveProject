//
//  BRLocationManager.m
//  MyLiveProject
//
//  Created by 任波 on 17/3/25.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface BRLocationManager ()<CLLocationManagerDelegate>
// 定位对象
@property (nonatomic, strong) CLLocationManager *manger;
@property (nonatomic, copy) LocationBlock block;

@end

@implementation BRLocationManager
/** 实现单例 */
singleton_implementation(BRLocationManager)

- (instancetype)init {
    if (self = [super init]) {
        _manger = [[CLLocationManager alloc]init];
        /// 在init方法里初始化单例对象的属性(配置) --- 定位授权，弹出对话框
        // 设置定位精确度
        _manger.desiredAccuracy = kCLLocationAccuracyBest;
        // 设置定位过滤(定位几百米)
        _manger.distanceFilter = 100;
        _manger.delegate = self;
        // 判断定位服务是否开启
        if (![CLLocationManager locationServicesEnabled]) {
            NSLog(@"请先去开启定位服务！");
        } else {
            // 当前状态
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            if (status == kCLAuthorizationStatusNotDetermined) {
                [_manger requestWhenInUseAuthorization];
            }
        }
    }
    return self;
}

// 定位方法
- (void)getGPS:(LocationBlock)block {
    // 保存block
    self.block = block;
    // 开始定位
    [self.manger startUpdatingLocation];
}

// 开始定位后，会自动调用这个代理方法，得到经纬度。然后再回传值，最后关闭定位。
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    NSString *lat = @(location.coordinate.latitude).stringValue;
    NSString *lon = @(location.coordinate.longitude).stringValue;
    self.lat = lat;
    self.lon =lon;
    // 回传经纬度值
    self.block(lat, lon);
    // 关闭定位
    [self.manger stopUpdatingLocation];
}

@end
