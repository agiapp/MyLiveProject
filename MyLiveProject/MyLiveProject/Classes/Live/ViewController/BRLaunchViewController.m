//
//  BRLaunchViewController.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/8.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRLaunchViewController.h"
#import "BRLivePreview.h"

@interface BRLaunchViewController ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeLiveBtn;
@property (nonatomic, strong) UIButton *locationBtn;
@property (nonatomic, strong) UIButton *startLiveBtn;
@property (nonatomic, strong) UITextField *titleTF;

@end

@implementation BRLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    self.bgImageView.hidden = NO;
    self.closeLiveBtn.hidden = NO;
    self.locationBtn.hidden = NO;
    self.startLiveBtn.hidden = NO;
    self.titleTF.hidden = NO;
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

- (UIButton *)locationBtn {
    if (!_locationBtn) {
        _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_locationBtn setTitle:@"杭州市" forState:UIControlStateNormal];
        [_locationBtn setImage:[UIImage imageNamed:@"launch_map_on"] forState:UIControlStateNormal];
        [_locationBtn addTarget:self action:@selector(clickLocationBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_locationBtn];
        [_locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(10);
        }];
    }
    return _locationBtn;
}

- (void)clickLocationBtn {
    NSLog(@"位置");
}

- (UIButton *)startLiveBtn {
    if (!_startLiveBtn) {
        _startLiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startLiveBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_startLiveBtn setTitleColor:RGB_HEX(0x7EDDC9, 1.0) forState:UIControlStateNormal];
        [_startLiveBtn setBackgroundImage:[UIImage imageNamed:@"room_button"] forState:UIControlStateNormal];
        [_startLiveBtn setTitle:@"开始直播" forState:UIControlStateNormal];
        [_startLiveBtn addTarget:self action:@selector(clickStartLiveBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_startLiveBtn];
        [_startLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
        }];
    }
    return _startLiveBtn;
}

- (void)clickStartLiveBtn {
    NSLog(@"开始直播");
    BRLivePreview *livePreview = [[BRLivePreview alloc]initWithFrame:SCREEN_BOUNDS];
    [self.view addSubview:livePreview];
    // 开启直播
    [livePreview startLive];
}

- (UITextField *)titleTF {
    if (!_titleTF) {
        _titleTF = [[UITextField alloc]init];
        _titleTF.textAlignment = NSTextAlignmentCenter;
        _titleTF.textColor = [UIColor whiteColor];
        _titleTF.font = [UIFont systemFontOfSize:18.0f];
        _titleTF.placeholder = @"给直播起个标题吧";
        [self.view addSubview:_titleTF];
        [_titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.startLiveBtn.mas_top).with.offset(-30);
            make.centerX.mas_equalTo(self.startLiveBtn.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(250, 30));
        }];
    }
    return _titleTF;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
