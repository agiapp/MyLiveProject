//
//  BRHotViewController.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/8.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRHotViewController.h"
#import "BRLiveHandler.h"
#import "BRLiveCell.h"
#import "BRHotLiveModel.h"
//#import <MediaPlayer/MediaPlayer.h> 系统提供的播放器
#import "BRPlayerViewController.h"
#import "BRPlayerModel.h"

@interface BRHotViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hotLiveModelArr;

@end

@implementation BRHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    // 1. 初始化UI
    [self initUI];
    // 2. 加载数据
    [self loadData];
}

#pragma mark - 第1步：初始化UI
- (void)initUI {
    self.tableView.hidden = NO;
}

#pragma mark - 第2步：加载数据
- (void)loadData {
    [BRLiveHandler executeGetHotLiveTaskWithSuccess:^(id obj) {
        NSLog(@"请求热门直播的信息：%@", obj);
        [self.hotLiveModelArr addObjectsFromArray:obj];
        [self.tableView reloadData];
    } failed:^(id error) {
        NSLog(@"请求错误：%@", error);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 78 + SCREEN_WIDTH;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hotLiveModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    BRLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BRLiveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.hotLiveModelArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BRLiveModel *model = self.hotLiveModelArr[indexPath.row];
/**
    // 使用系统自带的播放器去播放直播视频，播放不了，因为解码不了，不支持播放rtmp。
    MPMoviePlayerViewController *movieVC = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:model.streamAddr]];
    [self presentViewController:movieVC animated:YES completion:nil];
*/
    BRPlayerViewController *playVC = [[BRPlayerViewController alloc]init];
    BRPlayerModel *playerModel = [[BRPlayerModel alloc]init];
    playerModel.portrait = model.creator.portrait;
    playerModel.streamAddr = model.streamAddr;
    playVC.model = playerModel;
//    [self presentViewController:playVC animated:YES completion:nil];
    [self.navigationController pushViewController:playVC animated:YES];
    
}

- (NSMutableArray *)hotLiveModelArr {
    if (!_hotLiveModelArr) {
        _hotLiveModelArr = [NSMutableArray array];
    }
    return _hotLiveModelArr;
}

@end
