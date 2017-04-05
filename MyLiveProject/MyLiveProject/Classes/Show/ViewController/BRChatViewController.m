//
//  BRChatViewController.m
//  MyLiveProject
//
//  Created by 任波 on 17/3/12.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRChatViewController.h"
#import "BRPlayerModel.h"

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
    // 添加顶部视图
    self.topBgImageView.hidden = NO;
    self.headImageView.hidden = NO;
    self.onlineUsersLabel.hidden = NO;
    self.moneyBtn.hidden = NO;

    // 添加底部视图
    self.chatImageView.hidden = NO;
    self.shareImageView.hidden = NO;
    self.giftImageView.hidden = NO;
    self.messageImageView.hidden = NO;
    
    [self initTimer];
}

- (void)initTimer {
    [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self showMoreLoveAnimation];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 点赞动画
    [self showMoreLoveAnimation];
}

#pragma mark - 点赞动画
- (void)showMoreLoveAnimation {
    UIImageView *imageView = [[UIImageView alloc] init];
    CGRect frame = self.view.frame;
    //  初始frame，即设置了动画的起点
    imageView.frame = CGRectMake(self.shareImageView.centerX - 12, self.shareImageView.centerY - self.shareImageView.height / 2 - 22, 25, 22);
    //  初始化imageView透明度为0
    imageView.alpha = 0;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    //  用0.1秒的时间将imageView的透明度变成0.8，同时将其放大1.2倍，再缩放至1.0倍，这里参数根据需求设置
    [UIView animateWithDuration:0.2 animations:^{
        imageView.alpha = 0.8;
        imageView.frame = CGRectMake(self.shareImageView.centerX - 12, self.shareImageView.centerY - self.shareImageView.height / 2 - 50, 25, 22);
        CGAffineTransform transfrom = CGAffineTransformMakeScale(1.2, 1.2);
        imageView.transform = CGAffineTransformScale(transfrom, 1, 1);
    }];
    [self.view addSubview:imageView];
    //  随机产生一个动画结束点的X值
    CGFloat finishX = frame.size.width - round(random() % 200);
    //  动画结束点的Y值
    CGFloat finishY = SCREEN_HEIGHT / 2;
    //  imageView在运动过程中的缩放比例
    CGFloat scale = round(random() % 2) + 0.7;
    // 生成一个作为速度参数的随机数
    CGFloat speed = 1 / round(random() % 900) + 0.6;
    //  动画执行时间
    NSTimeInterval duration = 4 * speed;
    //  如果得到的时间是无穷大，就重新附一个值（这里要特别注意，请看下面的特别提醒）
    if (duration == INFINITY) duration = 2.0;
    // 随机生成一个0~7的数，以便下面拼接图片名
    int imageName = round(random() % 6);
    
    //  开始动画
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    //  设置动画时间
    [UIView setAnimationDuration:duration];
    
    //  拼接图片名字
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"heart_%d.png",imageName]];
    
    //  设置imageView的结束frame
    imageView.frame = CGRectMake( finishX, finishY, 30 * scale, 30 * scale);
    
    //  设置渐渐消失的效果，这里的时间最好和动画时间一致
    [UIView animateWithDuration:duration animations:^{
        imageView.alpha = 0;
    }];
    
    //  结束动画，调用onAnimationComplete:finished:context:函数
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    //  设置动画代理
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

/// 动画完后销毁iamgeView
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    UIImageView *imageView = (__bridge UIImageView *)(context);
    [imageView removeFromSuperview];
    imageView = nil;
}

- (void)setModel:(BRPlayerModel *)model {
    _model = model;
    [self.headImageView br_setImageWithPath:model.portrait placeholder:@"default_room"];
    // YYKit中封装的定时器方法（每隔3秒执行一下block中的内容）
    [NSTimer scheduledTimerWithTimeInterval:2 block:^(NSTimer * _Nonnull timer) {
        self.onlineUsersLabel.text = [NSString stringWithFormat:@"%d", arc4random_uniform(20000)];
    } repeats:YES];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = RGB_HEX(0x349DDA, 1.0);
        [self.view addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 60));
        }];
    }
    return _bgView;
}

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
