//
//  BRPlayerViewController.m
//  MyLiveProject
//
//  Created by 任波 on 17/3/12.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRPlayerViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "BRChatViewController.h"
#import "AppDelegate.h"
#import "BRPlayerModel.h"

@interface BRPlayerViewController ()
@property (atomic, strong) id<IJKMediaPlayback> player;
/** 毛玻璃过渡视图 */
@property (nonatomic, strong) UIImageView *blurImageView;
/** 关闭按钮 */
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) BRChatViewController *chatVC;

@end

@implementation BRPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化播放器
    [self initPlayer];
    [self initUI];
    [self addChildVC];
    
}

- (void)initUI {
    self.view.backgroundColor = [UIColor blackColor];
    if (!_blurImageView) {
        _blurImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:_blurImageView];
    }
    [self.blurImageView br_setImageWithPath:self.model.portrait placeholder:@"default_room"];
    // 创建毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // 创建毛玻璃视图
    UIVisualEffectView *ve = [[UIVisualEffectView alloc]initWithEffect:blur];
    ve.frame = self.blurImageView.bounds;
    // 毛玻璃视图加入图片视图之上，相当于在图片之上加了一层蒙版
    [self.blurImageView addSubview:ve];
    
}

/** 初始化播放器 */
- (void)initPlayer {
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    IJKFFMoviePlayerController *player = [[IJKFFMoviePlayerController alloc]initWithContentURLString:self.model.streamAddr withOptions:options];
    self.player = player;
    self.player.view.frame = self.view.bounds;
    self.player.shouldAutoplay = YES; // 设置自动播放
    [self.view addSubview:self.player.view];
}

- (void)addChildVC {
    [self addChildViewController:self.chatVC];
    [self.view addSubview:self.chatVC.view];
    [self.chatVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.chatVC.model = self.model;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    // 注册直播需要用的通知
    [self installMovieNotificationObservers];
    // 准备播放
    [self.player prepareToPlay];
    
    self.closeBtn.hidden = NO;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    // 关闭直播
    [self.player shutdown];
    // 移除通知
    [self removeMovieNotificationObservers];
    [self.closeBtn removeFromSuperview];
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"mg_room_btn_guan_h"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        // 添加到window上
        [appDelegate.window addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(-10);
        }];
    }
    return _closeBtn;
}

- (void)clickCloseBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 注册直播需要用的通知
- (void)installMovieNotificationObservers {
    // 监听网络环境，监听直播缓冲方法
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    // 监听直播完成回调，直播完成后回调这个方法
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    // 监听是否准备好，不常用
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    // 监听用户操作（用户操作触发的方法）
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

- (void)loadStateDidChange:(NSNotification*)notification {
    // 可以监听以下情况：
    // 未知网络
    // MPMovieLoadStateUnknown        = 0,
    // 缓冲结束，可以播放
    // MPMovieLoadStatePlayable       = 1 << 0,
    // 缓冲结束自动播放
    // MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    // 暂停
    // MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
    // 移除过渡视图
    self.blurImageView.hidden = YES;
    [self.blurImageView removeFromSuperview];
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification {
    // 可以监听以下情况：
    //    MPMovieFinishReasonPlaybackEnded, 直播结束
    //    MPMovieFinishReasonPlaybackError, 直播错误
    //    MPMovieFinishReasonUserExited 用户退出
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    // 用户的几种操作：
    //    MPMoviePlaybackStateStopped, 停止
    //    MPMoviePlaybackStatePlaying, 播放
    //    MPMoviePlaybackStatePaused, 暂停
    //    MPMoviePlaybackStateInterrupted, 中断
    //    MPMoviePlaybackStateSeekingForward, 前移
    //    MPMoviePlaybackStateSeekingBackward 后移
    
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma mark 移除通知
- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}


- (BRChatViewController *)chatVC {
    if (!_chatVC) {
        _chatVC = [[BRChatViewController alloc]init];
    }
    return _chatVC;
}

- (BRPlayerModel *)model {
    if (!_model) {
        _model = [[BRPlayerModel alloc]init];
    }
    return _model;
}

@end
