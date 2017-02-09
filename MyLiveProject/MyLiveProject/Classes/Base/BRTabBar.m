//
//  BRTabBar.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/7.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRTabBar.h"

@interface BRTabBar ()
{
    UIButton *lastBtn;
}
// 设置TabBar背景图片
@property (nonatomic, strong) UIImageView *bgImageView;
// tabbar中间按钮
@property (nonatomic, strong) UIButton *middleBtn;
// 图标数组
@property (nonatomic, strong) NSArray *iconArr;

@end

@implementation BRTabBar

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"global_tab_bg"]];
    }
    return _bgImageView;
}

- (UIButton *)middleBtn {
    if (!_middleBtn) {
        _middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_middleBtn setImage:[UIImage imageNamed:@"tab_launch"] forState:UIControlStateNormal];
        _middleBtn.tag = BRItemTypeLaunch;
        [_middleBtn addTarget:self action:@selector(clickItemBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _middleBtn;
}

- (NSArray *)iconArr {
    if (!_iconArr) {
        _iconArr = @[@"tab_live", @"tab_me"];
    }
    return _iconArr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 创建背景视图，并添加
        [self addSubview:self.bgImageView];
        // 创建按钮视图，并添加
        for (NSInteger i = 0; i < self.iconArr.count; i++) {
            UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            // 去掉按钮默认的高亮状态（不让图片在高亮下改变）
            itemBtn.adjustsImageWhenHighlighted = NO;
            NSString *iconName = self.iconArr[i];
            [itemBtn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
            [itemBtn setImage:[UIImage imageNamed:[iconName stringByAppendingString:@"_p"]] forState:UIControlStateSelected];
            if (i == 0) {
                itemBtn.selected = YES;
                lastBtn = itemBtn;
            }
            [itemBtn addTarget:self action:@selector(clickItemBtn:) forControlEvents:UIControlEventTouchUpInside];
            itemBtn.tag = BRItemTypeLive + i;
            [self addSubview:itemBtn];
        }
        // 添加tabbar的中间按钮
        [self addSubview:self.middleBtn];
    }
    return self;
}

// 设置子视图（背景图片和按钮）的frame
- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgImageView.frame = self.bounds;
    CGFloat width = self.bounds.size.width / self.iconArr.count;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.frame = CGRectMake((view.tag - BRItemTypeLive) * width, 0, width, self.frame.size.height);
        }
    }
    // 宽高自适应（宽高固定）
    [_middleBtn sizeToFit];
    self.middleBtn.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - 40);
}

// 按钮的tag值一般不设为0，因为默认就为0
- (void)clickItemBtn:(UIButton *)button {
    // 回调：当点击某个按钮的时候，告诉Controller我点的是谁
    // 1.使用协议时执行
    if ([self.delegate respondsToSelector:@selector(tabBar:clickButton:)]) {
        [self.delegate tabBar:self clickButton:button.tag];
    }
    // 2.使用block时执行
    if (self.callBlock) {
        self.callBlock(self, button.tag);
    }
    // 如果点击中间的按钮，则不往下面执行
    if (button.tag == BRItemTypeLaunch) {
        return;
    }
    // 上一个按钮不选中
    lastBtn.selected = NO;
    // 当前按钮选中
    button.selected = YES;
    lastBtn = button;

    // 设置缩放动画
    [self startScaleAnimation:button];
    
}

/** 设置缩放动画 */
- (void)startScaleAnimation:(UIView *)view {
    // 放大动画
    [UIView animateWithDuration:0.2 animations:^{
        view.transform = CGAffineTransformMakeScale(1.2, 1.2); //等比放大1.2倍
    } completion:^(BOOL finished) {
        // 缩回去动画
        [UIView animateWithDuration:0.1 animations:^{
            view.transform = CGAffineTransformIdentity; //回复原始状态
        } completion:^(BOOL finished) {
            // 放大动画
            [UIView animateWithDuration:0.08 animations:^{
                view.transform = CGAffineTransformMakeScale(1.1, 1.1); //等比放大1.1倍
            } completion:^(BOOL finished) {
                // 缩回去动画
                [UIView animateWithDuration:0.04 animations:^{
                    view.transform = CGAffineTransformIdentity; //回复原始状态
                }];
            }];
        }];
    }];
}

@end
