//
//  BRHotViewController.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/8.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRHotViewController.h"
#import "BRLiveHandler.h"

@interface BRHotViewController ()

@end

@implementation BRHotViewController

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
    [BRLiveHandler executeGetHotLiveTaskWithSuccess:^(id obj) {
        MYLog(@"请求热门直播的信息：%@", obj);
    } failed:^(id error) {
        MYLog(@"请求错误：%@", error);
    }];
}

@end
