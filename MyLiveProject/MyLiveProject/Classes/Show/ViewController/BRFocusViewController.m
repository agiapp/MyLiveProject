//
//  BRFocusViewController.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/8.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRFocusViewController.h"
#import "BRLiveHandler.h"
#import "BRLiveCell.h"
#import "BRHotLiveModel.h"
#import "BRPlayerViewController.h"
#import "BRPlayerModel.h"

@interface BRFocusViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *focusModelArr;

@end

@implementation BRFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
//    [BRLiveHandler executeGetFocusTaskWithSuccess:^(id obj) {
//        NSLog(@"请求关注的信息：%@", obj);
//        [self.focusModelArr addObjectsFromArray:obj];
//        [self.tableView reloadData];
//    } failed:^(id error) {
//        NSLog(@"请求错误：%@", error);
//    }];
    
    // 造假数据，自己关注自己
    BRLiveModel *liveModel = [[BRLiveModel alloc]init];
    liveModel.city = @"杭州";
    liveModel.onlineUsers = 18343;
    liveModel.streamAddr = Live_boge;
    BRCreatorModel *creatorModel = [[BRCreatorModel alloc]init];
    creatorModel.nick = @"💕女神";
    creatorModel.portrait = @"http://img.67.com/upload/images/2016/05/26/aGV5YW96aG91MTQ2NDI0Njk3NQ==.jpg";
    liveModel.creator = creatorModel;
    
    [self.focusModelArr addObjectsFromArray:@[liveModel]];
    [self.tableView reloadData];
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
    return self.focusModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"focusCell";
    BRLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BRLiveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.focusModelArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BRLiveModel *model = self.focusModelArr[indexPath.row];
    BRPlayerViewController *playVC = [[BRPlayerViewController alloc]init];
    BRPlayerModel *playerModel = [[BRPlayerModel alloc]init];
    playerModel.portrait = model.creator.portrait;
    playerModel.streamAddr = model.streamAddr;
    playVC.model = playerModel;
    [self.navigationController pushViewController:playVC animated:YES];
    
}

- (NSMutableArray *)focusModelArr {
    if (!_focusModelArr) {
        _focusModelArr = [NSMutableArray array];
    }
    return _focusModelArr;
}

@end
