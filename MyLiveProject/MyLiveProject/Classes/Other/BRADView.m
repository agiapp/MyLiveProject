//
//  BRADView.m
//  MyLiveProject
//
//  Created by 任波 on 17/3/26.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRADView.h"
#import "BRCacheHelper.h"

@interface BRADView ()
@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation BRADView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        // 1.下载广告图片
        [self loadData];
        // 2.显示广告页
        [self initUI];
        // 3.开始计时
        [self startTimer];
    }
    return self;
}

- (void)loadData {
    NSString *path = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490517014356&di=49672965782b97d6538f32271b4cecb5&imgtype=0&src=http%3A%2F%2Fa.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fb7003af33a87e950ade0026c12385343fbf2b43f.jpg";
    [UIImageView br_downloadImageWithUrl:path success:^(UIImage *image) {
        NSLog(@"下载图片成功！");
        [BRCacheHelper setAdImagePath:path];
    } failed:^(NSError *error) {
        NSLog(@"下载图片失败：%@", error);
    }];

}

- (void)initUI {
    self.adImageView.hidden = NO;
    self.timeLabel.hidden = NO;
    self.timeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapTimeLabel)];
    [self.timeLabel addGestureRecognizer:myTap];
    
    NSString *imagePath = [BRCacheHelper adImagePath];
    UIImage *lastCacheImage = [[YYWebImageManager sharedManager].cache getImageForKey:imagePath withType:YYImageCacheTypeDisk];
    if (lastCacheImage) {
        self.adImageView.image = lastCacheImage;
    } else {
        self.hidden = YES;
    }
}

- (void)didTapTimeLabel {
    NSLog(@"点击跳过广告");
    [self dismiss];
}

- (void)startTimer {
    __block NSUInteger timeout = 4;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    self.timer = timer; // 保存timer，防止释放
    // 1:每秒钟一次，0:没有延迟
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        // 处理倒计时
        if (timeout <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismiss];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeLabel.text = [NSString stringWithFormat:@"跳过%zds", timeout];
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}

- (void)dismiss {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIImageView *)adImageView {
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _adImageView.backgroundColor = [UIColor redColor];
        [self addSubview:_adImageView];
    }
    return _adImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.backgroundColor = RGB_HEX(0x333333, 0.3);
        _timeLabel.layer.cornerRadius = 12;
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(70, 24));
        }];
    }
    return _timeLabel;
}


@end
