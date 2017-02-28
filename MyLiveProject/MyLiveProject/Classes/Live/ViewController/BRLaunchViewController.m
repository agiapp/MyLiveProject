//
//  BRLaunchViewController.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/8.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRLaunchViewController.h"

@interface BRLaunchViewController ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeLiveBtn;

@end

@implementation BRLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
}

- (void)initUI {
    self.bgImageView.hidden = NO;
    self.closeLiveBtn.hidden = NO;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"bg_zbfx"];
        [self.view addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return _bgImageView;
}

- (UIButton *)closeLiveBtn {
    if (!_closeLiveBtn) {
        _closeLiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeLiveBtn setImage:[UIImage imageNamed:@"launch_close"] forState:UIControlStateNormal];
        [_closeLiveBtn addTarget:self action:@selector(clickCloseLiveBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeLiveBtn];
        [_closeLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    return _closeLiveBtn;
}

- (void)clickCloseLiveBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
