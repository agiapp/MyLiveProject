//
//  AppDelegate.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/6.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "AppDelegate.h"
#import "BRTabBarController.h"
#import "BRLocationManager.h"
#import "BRADView.h"
#import "AppDelegate+Category.h"
//#import "UMSocial.h"
#import "BRLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    BRTabBarController *tabBarVC = [[BRTabBarController alloc] init];
    //BRLoginViewController *loginVC = [[BRLoginViewController alloc] init];
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    // 广告视图
    BRADView *adView = [[BRADView alloc]initWithFrame:SCREEN_BOUNDS];
    [self.window addSubview:adView];
    
    [[BRLocationManager sharedBRLocationManager] getGPS:^(NSString *lat, NSString *lon) {
        NSLog(@"当前位置的经纬度：(%@, %@)", lat, lon);
    }];
    
    // 初始化友盟控件
//    [self setupUMeung];
    
    return YES;
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    BOOL result = [UMSocialSnsService handleOpenURL:url];
//    if (result == FALSE) {
//        //调用其他SDK，例如支付宝SDK等
//    }
//    return result;
//}


@end
