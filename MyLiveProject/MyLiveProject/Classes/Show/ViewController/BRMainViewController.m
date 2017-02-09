//
//  BRMainViewController.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/7.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRMainViewController.h"

@interface BRMainViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *slideMenuNameArr;


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
}

// 添加子视图控制器，让主控制器(MainVC)去管理这些子视图控制器
- (void)setupChildViewControllers {
    // 1.添加子视图控制器
    NSArray *classNameArr = @[@"BRFocusViewController", @"BRHotViewController", @"BRNearViewController"];
    for (NSInteger i = 0; i < classNameArr.count; i++) {
        NSString *className = classNameArr[i];
        UIViewController *vc = [[NSClassFromString(className) alloc]init];
        vc.title = self.slideMenuNameArr[i];
        // 当执行addChildViewController时，不会执行该vc的viewDidLoad方法（即不会占用太多内存）
        [self addChildViewController:vc];
    }
    // 2.将子视图控制器的view加到MainVC的scrollView视图上（滑动的时候加）
    // 设置scrollView的contentsize
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.slideMenuNameArr.count, 0);
    ///设置默认加载的页面：
    // 默认先展示第二个页面(即进入主控制器加载第二个页面)
    self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    // 手动调用
    [self scrollViewDidEndDecelerating:self.scrollView];
}

#pragma mark - UIScrollViewDelegate
/** 滑动scrollView 减速结束时（即结束滑动时） 调用的代理方法 */
// 用于处理加载子控制器view
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = SCREEN_HEIGHT;
    // 滑动到哪里，加载到哪里，获取当前加载页的index
    NSInteger index = offsetX / width;
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
    [scrollView addSubview:vc.view];
}

- (NSArray *)slideMenuNameArr {
    if (!_slideMenuNameArr) {
        _slideMenuNameArr = @[@"关注", @"热门", @"附近"];
    }
    return _slideMenuNameArr;
}

@end
