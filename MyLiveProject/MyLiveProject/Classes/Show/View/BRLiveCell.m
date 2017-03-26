//
//  BRLiveCell.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/25.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRLiveCell.h"
#import "BRHotLiveModel.h"
#import "NSString+Check.h"

@interface BRLiveCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *onLineLabel;
@property (nonatomic, strong) UILabel *lookLabel;
@property (nonatomic, strong) UIImageView *bigImageView;
@property (nonatomic, strong) UIImageView *liveImageView;

@end

@implementation BRLiveCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone; //选中cell时无色(没有变化)
        self.bgView.hidden = NO;
        self.headImageView.hidden = NO;
        self.nameLabel.hidden = NO;
        self.locationLabel.hidden = NO;
        self.onLineLabel.hidden = NO;
        self.lookLabel.hidden = NO;
        self.bigImageView.hidden = NO;
        self.liveImageView.hidden = NO;
    }
    return self;
}

// 重写setter方法给属性赋值
- (void)setModel:(BRLiveModel *)model {
    _model = model;
    [self.headImageView br_setImageWithPath:model.creator.portrait placeholder:@"default_room"];
    self.nameLabel.text = model.creator.nick;
    if ([NSString isBlankString:model.city]) {
        model.city = @"难道在火星?";
    }
    self.locationLabel.text = [NSString stringWithFormat:@"%@ >", model.city];
    self.onLineLabel.text = [@(model.onlineUsers) stringValue];
    [self.bigImageView br_setImageWithPath:model.creator.portrait placeholder:@"default_room"];
}

#pragma mark - 懒加载
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(70);
        }];
    }
    return _bgView;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.layer.cornerRadius = 25.0f;
        _headImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor grayColor];
        _nameLabel.font = [UIFont systemFontOfSize:18.0f];
        [self.contentView addSubview:_nameLabel];
        __weak typeof(self) weakSelf = self;
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(weakSelf.headImageView.mas_right).with.offset(10);
            make.right.mas_equalTo(weakSelf.onLineLabel.mas_left);
            make.height.mas_equalTo(20);
        }];
        
    }
    return _nameLabel;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc]init];
        _locationLabel.textColor = [UIColor lightGrayColor];
        _locationLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_locationLabel];
        __weak typeof(self) weakSelf = self;
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).with.offset(5);
            make.left.mas_equalTo(weakSelf.nameLabel);
            make.size.mas_equalTo(weakSelf.nameLabel);
        }];
    }
    return _locationLabel;
}

- (UILabel *)onLineLabel {
    if (!_onLineLabel) {
        _onLineLabel = [[UILabel alloc]init];
        _onLineLabel.textColor = [UIColor orangeColor];
        _onLineLabel.font = [UIFont systemFontOfSize:18.0f];
        _onLineLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_onLineLabel];
        [_onLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.right.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(80, 20));
        }];
    }
    return _onLineLabel;
}

- (UILabel *)lookLabel {
    if (!_lookLabel) {
        _lookLabel = [[UILabel alloc]init];
        _lookLabel.textColor = [UIColor lightGrayColor];
        _lookLabel.font = [UIFont systemFontOfSize:14.0f];
        _lookLabel.textAlignment = NSTextAlignmentRight;
        _lookLabel.text = @"在看";
        [self.contentView addSubview:_lookLabel];
        __weak typeof(self) weakSelf = self;
        [_lookLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.onLineLabel.mas_bottom).with.offset(5);
            make.right.mas_equalTo(-10);
            make.size.mas_equalTo(weakSelf.onLineLabel);
        }];
    }
    return _lookLabel;
}

- (UIImageView *)bigImageView {
    if (!_bigImageView) {
        _bigImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_bigImageView];
        [_bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(70);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
        }];
    }
    return _bigImageView;
}

- (UIImageView *)liveImageView {
    if (!_liveImageView) {
        _liveImageView = [[UIImageView alloc]init];
        _liveImageView.image = [UIImage imageNamed:@"live_tag_live"];
        __weak typeof(self) weakSelf = self;
        [self.contentView addSubview:_liveImageView];
        [_liveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(weakSelf.bigImageView).with.offset(10);
        }];
    }
    return _liveImageView;
}


@end
