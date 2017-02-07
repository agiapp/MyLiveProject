//
//  BRTabBarController.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/7.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRTabBarController.h"
#import "BRTabBar.h"
#import "BRNavigationController.h"
#import "BRLaunchViewController.h"

@interface BRTabBarController ()<BRTabBarDelegate>
@property (nonatomic, strong) BRTabBar *myTabBar;

@end

@implementation BRTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.加载控制器
    [self configViewControllers];
    // 2.加载tabBar
    [self.tabBar addSubview:self.myTabBar];
    // 清除TabBar的阴影线
    [UITabBar appearance].shadowImage = [[UIImage alloc]init];
    
}

- (void)configViewControllers {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@"BRMainViewController", @"BRMeViewController"]];
    for (NSInteger i = 0; i < arr.count; i++) {
        NSString *className = arr[i];
        UIViewController *vc = [[NSClassFromString(className) alloc]init];
        BRNavigationController *nav = [[BRNavigationController alloc]initWithRootViewController:vc];
        // 替换数组的元素
        [arr replaceObjectAtIndex:i withObject:nav];
    }
    self.viewControllers = arr;
}

- (BRTabBar *)myTabBar {
    if (!_myTabBar) {
        _myTabBar = [[BRTabBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
        _myTabBar.delegate = self;
    }
    return _myTabBar;
}

// 点击按钮的时候，执行这个回调
- (void)tabBar:(BRTabBar *)tabBar clickButton:(BRItemType)index {
    if (index != BRItemTypeLaunch) {
        self.selectedIndex = index - BRItemTypeLive;
        return;
    }
    
    BRLaunchViewController *launchVC = [[BRLaunchViewController alloc]init];
    [self presentViewController:launchVC animated:YES completion:nil];
    
}

@end
