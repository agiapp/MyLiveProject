//
//  BRChatViewController.m
//  MyLiveProject
//
//  Created by 任波 on 17/3/12.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRChatViewController.h"
#import "BRLiveModel.h"

@interface BRChatViewController ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *topBgImageView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *onlineUsersLabel;
@property (nonatomic, strong) UIButton *moneyBtn;

@property (nonatomic, strong) UIImageView *chatImageView;
@property (nonatomic, strong) UIImageView *messageImageView;
@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) UIImageView *shareImageView;

@end

@implementation BRChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self initUI];
}

- (void)initUI {
    //self.bgView.hidden = NO;
    // 添加底部视图
    self.chatImageView.hidden = NO;
    self.messageImageView.hidden = NO;
    self.giftImageView.hidden = NO;
    self.shareImageView.hidden = NO;
    
    // 添加顶部视图
    self.topBgImageView.hidden = NO;
    self.headImageView.hidden = NO;
    self.onlineUsersLabel.hidden = NO;
    self.moneyBtn.hidden = NO;
    
}

- (void)setModel:(BRLiveModel *)model {
    _model = model;
    [self.headImageView downloadImage:model.creator.portrait placeholder:@"default_room"];
    [NSTimer scheduledTimerWithTimeInterval:3 block:^(NSTimer * _Nonnull timer) {
        self.onlineUsersLabel.text = [NSString stringWithFormat:@"%d", arc4random_uniform(20000)];
    } repeats:YES];
}

//- (UIView *)bgView {
//    if (!_bgView) {
//        _bgView = [[UIView alloc]init];
//        _bgView.backgroundColor = RGB_HEX(0x349DDA, 1.0);
//        [self.view addSubview:_bgView];
//        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(0);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 60));
//        }];
//    }
//    return _bgView;
//}

- (UIImageView *)topBgImageView {
    if (!_topBgImageView) {
        _topBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mg_room_touxiang"]];
        [self.view addSubview:_topBgImageView];
        [_topBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.left.mas_equalTo(10);
        }];
    }
    return _topBgImageView;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        //_headImageView downloadImage:self.m placeholder:<#(NSString *)#>
        _headImageView.layer.cornerRadius = 15.0f;
        _headImageView.layer.masksToBounds = YES;
        [self.view addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(31);
            make.left.mas_equalTo(11);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    return _headImageView;
}

- (UILabel *)onlineUsersLabel {
    if (!_onlineUsersLabel) {
        _onlineUsersLabel = [[UILabel alloc]init];
        _onlineUsersLabel.textColor = [UIColor whiteColor];
        _onlineUsersLabel.textAlignment = NSTextAlignmentCenter;
        _onlineUsersLabel.font = [UIFont systemFontOfSize:10.0f];
        [self.view addSubview:_onlineUsersLabel];
        __weak typeof(self) weaSelf = self;
        [_onlineUsersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(48);
            make.left.mas_equalTo(weaSelf.headImageView.mas_right).with.offset(2);
            make.size.mas_equalTo(CGSizeMake(40, 12));
        }];
    }
    return _onlineUsersLabel;
}

- (UIButton *)moneyBtn {
    if (!_moneyBtn) {
        _moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moneyBtn setBackgroundImage:[UIImage imageNamed:@"mg_room_映票_底"] forState:UIControlStateNormal];
        [_moneyBtn setTitle:@"映票：0" forState:UIControlStateNormal];
        _moneyBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_moneyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:_moneyBtn];
        __weak typeof(self) weaSelf = self;
        [_moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weaSelf.topBgImageView.mas_bottom).with.offset(10);
            make.left.mas_equalTo(0);
        }];
        
    }
    return _moneyBtn;
}

- (UIImageView *)chatImageView {
    if (!_chatImageView) {
        _chatImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mg_room_btn_liao_h"]];
        [self.view addSubview:_chatImageView];
        [_chatImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return _chatImageView;
}

- (UIImageView *)messageImageView {
    if (!_messageImageView) {
        _messageImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mg_room_btn_xinxi_h"]];
        [self.view addSubview:_messageImageView];
        __weak typeof(self) weaSelf = self;
        [_messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weaSelf.giftImageView.mas_left).offset(-10);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return _messageImageView;
}

- (UIImageView *)giftImageView {
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mg_room_btn_liwu_h"]];
        [self.view addSubview:_giftImageView];
        __weak typeof(self) weaSelf = self;
        [_giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weaSelf.shareImageView.mas_left).offset(-10);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return _giftImageView;
}

- (UIImageView *)shareImageView {
    if (!_shareImageView) {
        _shareImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mg_room_btn_fenxiang_h"]];
        [self.view addSubview:_shareImageView];
        [_shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-60);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return _shareImageView;
}

@end
