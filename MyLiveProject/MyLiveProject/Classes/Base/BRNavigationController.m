//
//  BRNavigationController.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/7.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRNavigationController.h"

@interface BRNavigationController ()

@end

@implementation BRNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置navigationBar背景颜色
    self.navigationBar.barTintColor = RGB(0, 216, 201, 1.0);
    // 设置navigationBar所有子控件的颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
}

@end
