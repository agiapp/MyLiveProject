//
//  BRMainViewController.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/7.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRMainViewController.h"
#import "BRSlideMenuView.h"

@interface BRMainViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) BRSlideMenuView *slideMenuView;
@property (nonatomic, strong) NSArray *menuTitleArr;

@end

@implementation BRMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"主页";
    [self initUI];
}

- (void)initUI {
    // 添加导航栏的左右按钮
    [self setupNav];
    // 添加子视图控制器
    [self setupChildViewControllers];
    
}

// 设置导航栏
- (void)setupNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"global_search"] style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"title_button_more"] style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.titleView = self.slideMenuView;
}

// 添加子视图控制器，让主控制器(MainVC)去管理这些子视图控制器
- (void)setupChildViewControllers {
    // 1.添加子视图控制器
    NSArray *classNameArr = @[@"BRFocusViewController", @"BRHotViewController", @"BRNearViewController"];
    for (NSInteger i = 0; i < classNameArr.count; i++) {
        NSString *className = classNameArr[i];
        UIViewController *vc = [[NSClassFromString(className) alloc]init];
        vc.title = self.menuTitleArr[i];
        // 当执行addChildViewController时，不会执行该vc的viewDidLoad方法（即不会占用太多内存）
        [self addChildViewController:vc];
    }
    // 2.将子视图控制器的view加到MainVC的scrollView视图上（滑动的时候加）
    // 设置scrollView的contentsize
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.menuTitleArr.count, 0);
    // 设置默认先展示第二个页面(即进入主控制器加载第二个页面)
    self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    // 加载子控制器view
    [self loadChildControllerView:self.scrollView];
}

#pragma mark - UIScrollViewDelegate 实现两个协议方法
/** “scrollView动画结束时”调用的代理方法 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self loadChildControllerView:scrollView];
}

/** 用手滑动(拖动)scrollView后，“减速结束时”调用的代理方法 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadChildControllerView:scrollView];
}

// 加载子控制器view
- (void)loadChildControllerView:(UIScrollView *)superView {
    CGFloat offsetX = superView.contentOffset.x;
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = SCREEN_HEIGHT;
    // 滑动到哪里，加载到哪里，获取当前加载页的index
    NSInteger index = offsetX / width;
    // 让菜单栏的下划线视图滚动，保持与scrollView联动
    [self.slideMenuView scrollLineView:index];
    // 根据索引值返回vc引用(这里只是拿到了vc的引用，并不知道vc是否执行过viewDidLoad)
    UIViewController *vc = self.childViewControllers[index];
    // 判断当前vc是否执行过viewDidLoad
    if (vc.isViewLoaded) {
        /// 1.如果加载过就不添加
        return; // 如果vc已经加载过，就直接return，不需要再做其它的操作
    }
    /// 2.如果没有加载过就添加
    // 设置子控制器view的frame大小
    vc.view.frame = CGRectMake(offsetX, 0, width, height);
    // 将子控制器的view添加到scrollView上
    [superView addSubview:vc.view];
}

- (BRSlideMenuView *)slideMenuView {
    if (!_slideMenuView) {
        _slideMenuView = [[BRSlideMenuView alloc]initWithFrame:CGRectMake(0, 0, 200, 50) andTitleArr:self.menuTitleArr];
        __weak typeof(self) weakSelf = self;
        // 回调：当点击menuView上的菜单按钮时，通过回调block在MainVC中执行要做的操作。
        _slideMenuView.slideMenuBlock = ^ (NSInteger index){
            CGPoint offset = CGPointMake(SCREEN_WIDTH * index, weakSelf.scrollView.contentOffset.y);
            // 不带动画的滚动：weakSelf.scrollView.contentOffset = CGPointMake(x, y);
            // 带动画的滚动
            [weakSelf.scrollView setContentOffset:offset animated:YES];
            
            // 手动调用（初始化加载自控制器view）
            [weakSelf scrollViewDidEndDecelerating:weakSelf.scrollView];
        };
    }
    return _slideMenuView;
}

- (NSArray *)menuTitleArr {
    if (!_menuTitleArr) {
        _menuTitleArr = @[@"关注", @"热门", @"附近"];
    }
    return _menuTitleArr;
}

@end
