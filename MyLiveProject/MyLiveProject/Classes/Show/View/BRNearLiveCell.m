//
//  BRNearLiveCell.m
//  MyLiveProject
//
//  Created by 任波 on 17/3/25.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRNearLiveCell.h"
#import "BRNearLiveModel.h"

@interface BRNearLiveCell ()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *distanceLabel;

@end

@implementation BRNearLiveCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.headImageView.hidden = NO;
        self.distanceLabel.hidden = NO;
    }
    return self;
}

- (void)setModel:(BRFlowModel *)model {
    _model = model;
    [self.headImageView br_setImageWithPath:model.info.creator.portrait placeholder:@"default_room"];
    self.distanceLabel.text = model.info.distance;
}

- (void)showAnimation {
    if (self.model.isShow) {
        return;
    }
    //平面缩放扩大动画
    self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1.0);
    [UIView animateWithDuration:0.5 animations:^{
        // 还原动画
        self.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
        self.model.show = YES; //动画已显示
    }];
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.backgroundColor = [UIColor blackColor];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(self.contentView.mas_width);
        }];
    }
    return _headImageView;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc]init];
        _distanceLabel.backgroundColor = [UIColor whiteColor];
        _distanceLabel.font = [UIFont systemFontOfSize:15.0f];
        _distanceLabel.textAlignment = NSTextAlignmentLeft;
        _distanceLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_distanceLabel];
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImageView.mas_bottom);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
    }
    return _distanceLabel;
}

@end
