//
//  BRLoginViewController.m
//  MyLiveProject
//
//  Created by 任波 on 17/4/3.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRLoginViewController.h"
#import "UMSocial.h"

@interface BRLoginViewController ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *rightLineView;
@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) NSArray *imageNameArr;

@end

@implementation BRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    self.bgImageView.hidden = NO;
    self.logoImageView.hidden = NO;
    self.bottomBgView.hidden = NO;
    self.topLabel.hidden = NO;
    self.leftLineView.hidden = NO;
    self.rightLineView.hidden = NO;
    self.bottomLabel.hidden = NO;
    [self getBtn];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:SCREEN_BOUNDS];
        _bgImageView.backgroundColor = [UIColor whiteColor];
        _bgImageView.image = [UIImage imageNamed:@"login_bg_wallpaper"];
        [self.view addSubview:_bgImageView];
    }
    return _bgImageView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]init];
        _logoImageView.backgroundColor = [UIColor clearColor];
        _logoImageView.image = [UIImage imageNamed:@"login_tree"];
        [self.view addSubview:_logoImageView];
        __weak typeof(self)weakSelf = self;
        [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(weakSelf.view);
            make.width.mas_equalTo(weakSelf.view);
        }];
    }
    return _logoImageView;
}

- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc]init];
        _bottomBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_bottomBgView];
        [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.bottom.mas_equalTo(-20);
            make.height.mas_equalTo(150);
        }];
    }
    return _bottomBgView;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc]init];
        _topLabel.backgroundColor = [UIColor clearColor];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.font = [UIFont systemFontOfSize:12.0f];
        _topLabel.textColor = [UIColor lightGrayColor];
        _topLabel.text = @"选择登录方式";
        [self.bottomBgView addSubview:_topLabel];
        [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.centerX.mas_equalTo(self.bottomBgView);
        }];
    }
    return _topLabel;
}

- (UIView *)leftLineView {
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc]init];
        _leftLineView.backgroundColor = [UIColor lightGrayColor];
        [self.bottomBgView addSubview:_leftLineView];
        [_leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(self.topLabel.mas_left).with.offset(-5);
            make.centerY.mas_equalTo(self.topLabel.mas_centerY);
            make.height.mas_equalTo(1);
        }];
    }
    return _leftLineView;
}

- (UIView *)rightLineView {
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc]init];
        _rightLineView.backgroundColor = [UIColor lightGrayColor];
        [self.bottomBgView addSubview:_rightLineView];
        [_rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.topLabel.mas_right).with.offset(5);
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(self.topLabel.mas_centerY);
            make.height.mas_equalTo(1);
        }];
    }
    return _rightLineView;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.backgroundColor = [UIColor clearColor];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.font = [UIFont systemFontOfSize:10.0f];
        _bottomLabel.textColor = [UIColor lightGrayColor];
        _bottomLabel.text = @"登录即代表你同意映客服务和隐私条款";
        [self.bottomBgView addSubview:_bottomLabel];
        [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.centerX.mas_equalTo(self.bottomBgView);
        }];
    }
    return _bottomLabel;
}

- (void)getBtn {
    for (NSInteger i = 0; i < self.imageNameArr.count; i++) {
        CGFloat margin = (SCREEN_WIDTH - 60 - 4 * 60) / 3;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i * (60 + margin), 150 / 2 - 30, 60, 60)];
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage imageNamed:self.imageNameArr[i]] forState:UIControlStateNormal];
        [self.bottomBgView addSubview:btn];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)clickBtn:(UIButton *)button {
    NSInteger index = button.tag - 1000;
    NSLog(@"点击了%ld", index);
    if (index == 0) {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            // 获取微博用户名、uid、token等
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
                            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
                
//                [BRCacheHelper sharedUser].nickName = snsAccount.userName;
//                [BRCacheHelper sharedUser].iconUrl = snsAccount.iconURL;
//                [BRCacheHelper saveUser];
//                
//                self.view.window.rootViewController = [[SXTTabBarViewController alloc] init];
                
            } else {
                
                NSLog(@"登录失败");
            }
            
        });
    }
}

- (NSArray *)imageNameArr {
    if (!_imageNameArr) {
        _imageNameArr = @[@"login_ico_weibo", @"login_ico_wechat", @"login_ico_mobile", @"login_ico_qq"];
    }
    return _imageNameArr;
}

@end
