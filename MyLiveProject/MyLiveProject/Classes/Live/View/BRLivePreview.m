//
//  BRLivePreview.m
//  MyLiveProject
//
//  Created by 任波 on 17/4/2.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRLivePreview.h"
#import "UIControl+YYAdd.h"
#import "UIView+YYAdd.h"
#import "LFLiveKit.h"
#import "AppDelegate+Category.h"

inline static NSString *formatedSpeed(float bytes, float elapsed_milli) {
    if (elapsed_milli <= 0) {
        return @"N/A";
    }
    
    if (bytes <= 0) {
        return @"0 KB/s";
    }
    
    float bytes_per_sec = ((float)bytes) * 1000.f /  elapsed_milli;
    if (bytes_per_sec >= 1000 * 1000) {
        return [NSString stringWithFormat:@"%.2f MB/s", ((float)bytes_per_sec) / 1000 / 1000];
    } else if (bytes_per_sec >= 1000) {
        return [NSString stringWithFormat:@"%.1f KB/s", ((float)bytes_per_sec) / 1000];
    } else {
        return [NSString stringWithFormat:@"%ld B/s", (long)bytes_per_sec];
    }
}

@interface BRLivePreview ()<LFLiveSessionDelegate>
/** 容器视图 */
@property (nonatomic, strong) UIView *containerView;
/** 连接状态 */
@property (nonatomic, strong) UILabel *stateLabel;
/** 美颜按钮 */
@property (nonatomic, strong) UIButton *beautyButton;
/** 切换摄像头按钮 */
@property (nonatomic, strong) UIButton *cameraButton;
/** 关闭按钮 */
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) LFLiveDebug *debugInfo;
@property (nonatomic, strong) LFLiveSession *session;

@end

@implementation BRLivePreview
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self requestAccessForVideo]; // 申请视频权限
        [self requestAccessForAudio]; // 申请音频权限
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.stateLabel];
        [self.containerView addSubview:self.closeButton];
        [self.containerView addSubview:self.cameraButton];
        [self.containerView addSubview:self.beautyButton];
    }
    return self;
}

#pragma mark -- Public Method
- (void)requestAccessForVideo {
    __weak typeof(self) _self = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_self.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            // 已经开启授权，可继续
            dispatch_async(dispatch_get_main_queue(), ^{
                [_self.session setRunning:YES];
            });
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
}

- (void)requestAccessForAudio {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}

#pragma mark -- LFStreamingSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state {
    NSLog(@"liveStateDidChange: %ld", state);
    switch (state) {
        case LFLiveReady:
            _stateLabel.text = @"未连接";
            break;
        case LFLivePending:
            _stateLabel.text = @"连接中";
            break;
        case LFLiveStart:
            _stateLabel.text = @"已连接";
            break;
        case LFLiveError:
            _stateLabel.text = @"连接错误";
            break;
        case LFLiveStop:
            _stateLabel.text = @"未连接";
            break;
        default:
            break;
    }
}

/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug *)debugInfo {
    NSLog(@"debugInfo uploadSpeed: %@", formatedSpeed(debugInfo.currentBandwidth, debugInfo.elapsedMilli));
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode {
    NSLog(@"errorCode: %ld", errorCode);
}

#pragma mark -- Getter Setter
// 配置直播会话，会话是保持连接彼此传输的状态
- (LFLiveSession *)session {
    if (!_session) {
        ///////// 使用默认配置
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
        _session.delegate = self;
        _session.showDebugInfo = NO;
        _session.preView = self;
    }
    return _session;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.frame = self.bounds;
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _containerView;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 40)];
        _stateLabel.text = @"未连接";
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.font = [UIFont boldSystemFontOfSize:14.f];
    }
    return _stateLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton new];
        _closeButton.size = CGSizeMake(44, 44);
        _closeButton.left = self.width - 10 - _closeButton.width;
        _closeButton.top = 20;
        [_closeButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
        _closeButton.exclusiveTouch = YES;
        __weak typeof(self)weakSelf = self;
        [_closeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            // 关闭直播
            [weakSelf stopLive];
            UIViewController *currentVC = [appDelegate getCurrentVisibleViewController];
            [currentVC dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _closeButton;
}

- (UIButton *)cameraButton {
    if (!_cameraButton) {
        _cameraButton = [UIButton new];
        _cameraButton.size = CGSizeMake(44, 44);
        _cameraButton.origin = CGPointMake(_closeButton.left - 10 - _cameraButton.width, 20);
        [_cameraButton setImage:[UIImage imageNamed:@"camra_preview"] forState:UIControlStateNormal];
        _cameraButton.exclusiveTouch = YES;
        __weak typeof(self) _self = self;
        [_cameraButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            // 切换前后摄像头方法
            AVCaptureDevicePosition devicePositon = _self.session.captureDevicePosition;
            _self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
        }];
    }
    return _cameraButton;
}

- (UIButton *)beautyButton {
    if (!_beautyButton) {
        _beautyButton = [UIButton new];
        _beautyButton.size = CGSizeMake(44, 44);
        _beautyButton.origin = CGPointMake(_cameraButton.left - 10 - _beautyButton.width, 20);
        [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty"] forState:UIControlStateNormal];
        [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty_close"] forState:UIControlStateSelected];
        _beautyButton.exclusiveTouch = YES;
        __weak typeof(self) _self = self;
        [_beautyButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            // 切换美颜效果（集成GPUImage，做美颜）
            _self.session.beautyFace = !_self.session.beautyFace;
            _self.beautyButton.selected = !_self.session.beautyFace;
        }];
    }
    return _beautyButton;
}

#pragma mark - 开启直播
- (void)startLive {
    LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
    // 推送到哪里，推送到服务器的地址（房间），避免与别人冲突，把stream153改成自己的。
    // 直播端的推流地址和用户端的拉流播放地址
    // 请注意这是LFLiveKit的公用服务器地址，别人也可以拉流获取看到你的直播。将在最后介绍在自己电脑中搭建自己的服务器，再也不怕被别人偷看了。
    stream.url = @"rtmp://live.hkstv.hk.lxdns.com:1935/live/boge";
    [self.session startLive:stream];
}

#pragma mark - 结束直播
- (void)stopLive {
    [self.session stopLive];
}


@end
