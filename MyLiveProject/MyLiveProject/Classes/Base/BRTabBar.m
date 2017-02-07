//
//  BRTabBar.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/7.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRTabBar.h"

@interface BRTabBar ()
// 设置TabBar背景图片
@property (nonatomic, strong) UIImageView *bgImageView;
// 图标数组
@property (nonatomic, strong) NSArray *iconArr;

@end

@implementation BRTabBar

- (NSArray *)iconArr {
    if (!_iconArr) {
        _iconArr = @[@"tab_live", @"tab_me"];
    }
    return _iconArr;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"global_tab_bg"]];
    }
    return _bgImageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 创建背景视图，并添加
        [self addSubview:self.bgImageView];
        // 创建按钮视图，并添加
        for (NSInteger i = 0; i < self.iconArr.count; i++) {
            UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *iconName = self.iconArr[i];
            [itemBtn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
            [itemBtn setImage:[UIImage imageNamed:[iconName stringByAppendingString:@"_p"]] forState:UIControlStateSelected];
            [itemBtn addTarget:self action:@selector(clickItemBtn:) forControlEvents:UIControlEventTouchUpInside];
            itemBtn.tag = BRItemTypeLive + i;
            [self addSubview:itemBtn];
        }
    }
    return self;
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
}

@end
