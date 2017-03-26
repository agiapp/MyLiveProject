//
//  BRNearViewController.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/8.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRNearViewController.h"
#import "BRLiveHandler.h"
#import "BRNearLiveCell.h"
#import "BRNearLiveModel.h"
#import "BRPlayerViewController.h"
#import "BRPlayerModel.h"

#define kMargin 5
#define kItemWidth 100
static NSString *cellID = @"BRNearLiveCell";

@interface BRNearViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *nearLiveArr;

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
    self.collectionView.hidden = NO;
}

#pragma mark - 第2步：加载数据
- (void)loadData {
    [BRLiveHandler executeGetNearLiveTaskWithSuccess:^(id obj) {
        NSLog(@"请求附近直播的信息：%@", obj);
        self.nearLiveArr = obj;
        [self.collectionView reloadData];
    } failed:^(id error) {
        NSLog(@"请求错误：%@", error);
    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5.0f; //最小行间隔
        // 组内边距，设置UIcollectionView整体的组内边距
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_collectionView];
        //注册Cell
        [self.collectionView registerClass:[BRNearLiveCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.nearLiveArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BRNearLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.nearLiveArr[indexPath.row];
    return cell;
}

// cell将要显示时调用
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    BRNearLiveCell *nearLiveCell = (BRNearLiveCell *)cell;
    [nearLiveCell showAnimation];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    BRFlowModel *model = self.nearLiveArr[indexPath.row];
    BRPlayerViewController *playVC = [[BRPlayerViewController alloc]init];
    BRPlayerModel *playerModel = [[BRPlayerModel alloc]init];
    playerModel.portrait = model.info.creator.portrait;
    playerModel.streamAddr = model.info.streamAddr;
    playVC.model = playerModel;
    [self.navigationController pushViewController:playVC animated:YES];
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
// 控制单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger count = self.collectionView.width / kItemWidth;
//    CGFloat etraWidth = (self.collectionView.width - kMargin * (count + 1)) / count;
    CGFloat width = (self.collectionView.width - 10 - 4 * kMargin) / 3;
    return CGSizeMake(width, width + 20);
}

- (NSMutableArray *)nearLiveArr {
    if (!_nearLiveArr) {
        _nearLiveArr = [NSMutableArray array];
    }
    return _nearLiveArr;
}

@end
