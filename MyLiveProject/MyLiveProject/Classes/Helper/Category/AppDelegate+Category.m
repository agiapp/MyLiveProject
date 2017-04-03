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

@end
