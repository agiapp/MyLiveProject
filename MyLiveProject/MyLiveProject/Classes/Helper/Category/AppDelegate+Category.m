//
//  AppDelegate+Category.m
//  MyLiveProject
//
//  Created by 任波 on 17/4/2.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "AppDelegate+Category.h"
#import "BRNavigationController.h"
#import "BRTabBarController.h"
//#import "UMSocial.h"
//#import "UMSocialSinaSSOHandler.h"

@implementation AppDelegate (Category)
#pragma mark - 获取当前屏幕显示的控制器
- (UIViewController *)getCurrentVisibleViewController {
    UIViewController *rootVC = self.window.rootViewController;
    return [self getVisibleViewControllerFrom:rootVC];
}
- (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)rootVC {
    if ([rootVC isKindOfClass:[BRNavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((BRNavigationController *)rootVC) visibleViewController]]; //当前显示的控制器
    } else if ([rootVC isKindOfClass:[BRTabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((BRTabBarController *)rootVC) selectedViewController]];
    } else {
        if (rootVC.presentedViewController) {
            return [self getVisibleViewControllerFrom:rootVC.presentedViewController];
        } else {
            return rootVC;
        }
    }
}

//- (void)setupUMeung {
//    //设置umengkey
//    [UMSocialData setAppKey:@"57a5581267e58e2557001639"];
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2892166685"
//                                              secret:@"7849eb7a9922c4318b1a0cff9a215ff3"
//                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
