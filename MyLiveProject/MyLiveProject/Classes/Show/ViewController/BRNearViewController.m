//
//  BRNearViewController.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/8.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRNearViewController.h"
#import "BRLiveHandler.h"

@interface BRNearViewController ()

@end

@implementation BRNearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1. 初始化UI
    [self initUI];
    // 2. 加载数据
    [self loadData];
}

#pragma mark - 第1步：初始化UI
- (void)initUI {
    
}

#pragma mark - 第2步：加载数据
- (void)loadData {
    [BRLiveHandler executeGetNearLiveTaskWithSuccess:^(id obj) {
        NSLog(@"请求附近直播的信息：%@", obj);
    } failed:^(id error) {
        NSLog(@"请求错误：%@", error);
    }];
}

@end
