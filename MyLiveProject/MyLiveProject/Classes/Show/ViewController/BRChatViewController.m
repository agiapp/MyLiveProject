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

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation BRChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self initUI];
    //[self initTimer];
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

//- (void)initTimer {
//    //初始化心形动画
//    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
//    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
//    dispatch_source_set_event_handler(self.timer, ^{
//        [self showMoreLoveAnimateFromView:self.shareImageView addToView:self.view];
//    });
//    dispatch_resume(self.timer);
//    
//}
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self showMoreLoveAnimateFromView:self.shareImageView addToView:self.view];
//}
//
//- (void)showMoreLoveAnimateFromView:(UIView *)fromView addToView:(UIView *)addToView {
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
//    CGRect loveFrame = [fromView convertRect:fromView.frame toView:addToView];
//    CGPoint position = CGPointMake(fromView.layer.position.x, loveFrame.origin.y - 30);
//    imageView.layer.position = position;
//    NSArray *imgArr = @[@"heart_1",@"heart_2",@"heart_3",@"heart_4",@"heart_5",@"heart_1"];
//    NSInteger img = arc4random()%6;
//    imageView.image = [UIImage imageNamed:imgArr[img]];
//    [addToView addSubview:imageView];
//    
//    imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        imageView.transform = CGAffineTransformIdentity;
//    } completion:nil];
//    
//    CGFloat duration = 3 + arc4random()%5;
//    CAKeyframeAnimation *positionAnimate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    positionAnimate.repeatCount = 1;
//    positionAnimate.duration = duration;
//    positionAnimate.fillMode = kCAFillModeForwards;
//    positionAnimate.removedOnCompletion = NO;
//    
//    UIBezierPath *sPath = [UIBezierPath bezierPath];
//    [sPath moveToPoint:position];
//    CGFloat sign = arc4random()%2 == 1 ? 1 : -1;
//    CGFloat controlPointValue = (arc4random()%50 + arc4random()%100) * sign;
//    [sPath addCurveToPoint:CGPointMake(position.x, position.y - 300) controlPoint1:CGPointMake(position.x - controlPointValue, position.y - 150) controlPoint2:CGPointMake(position.x + controlPointValue, position.y - 150)];
//    positionAnimate.path = sPath.CGPath;
//    [imageView.layer addAnimation:positionAnimate forKey:@"heartAnimated"];
//    
//    
//    [UIView animateWithDuration:duration animations:^{
//        imageView.layer.opacity = 0;
//    } completion:^(BOOL finished) {
//        [imageView removeFromSuperview];
//    }];
//}

- (void)setModel:(BRPlayerModel *)model {
    _model = model;
    [self.headImageView br_setImageWithPath:model.portrait placeholder:@"default_room"];
    // YYKit中封装的定时器方法（每隔3秒执行一下block中的内容）
    [NSTimer scheduledTimerWithTimeInterval:2 block:^(NSTimer * _Nonnull timer) {
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
