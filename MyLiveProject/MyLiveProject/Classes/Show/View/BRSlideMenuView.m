//
//  BRSlideMenuView.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/9.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRSlideMenuView.h"

@interface BRSlideMenuView ()
/** 标题菜单的下划线视图 */
@property (nonatomic, strong) UIView *lineView;
/** 用一个数组来保存菜单上的按钮 */
@property (nonatomic, strong) NSMutableArray *titleBtnArr;

@end

@implementation BRSlideMenuView

- (instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)titleArr {
    if (self  = [super init]) {
        self.frame = frame;
        CGFloat btnW = self.width / titleArr.count;
        CGFloat btnH = self.height;
        for (NSInteger i = 0; i < titleArr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(btnW * i, 0, btnW, btnH);
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [self addSubview:btn];
            // 把按钮保存起来，方便其它地方访问
            [self.titleBtnArr addObject:btn];
            // 默认下滑线视图
            if (i == 1) {
                self.lineView = [[UIView alloc]init];
                self.lineView.backgroundColor = [UIColor whiteColor];
                [btn.titleLabel sizeToFit];
                self.lineView.width = btn.titleLabel.width;
                self.lineView.height = 1.5;
                self.lineView.centerX = btn.centerX;
                self.lineView.top = btn.bottom - 12;
                [self addSubview:self.lineView];
            }
        }
    }
    return self;
}

- (void)clickBtn:(UIButton *)button {
    // 回传给控制器，通过block去告诉控制器发生变化。回传button.tag
    self.slideMenuBlock(button.tag);

    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.centerX = button.centerX;
    }];
}

- (void)scrollLineView:(NSInteger)index {
    UIButton *button = self.titleBtnArr[index];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.centerX = button.centerX;
    }];
}

- (NSMutableArray *)titleBtnArr {
    if (!_titleBtnArr) {
        _titleBtnArr = [NSMutableArray array];
    }
    return _titleBtnArr;
}

@end
