//
//  BRNearLiveCell.h
//  MyLiveProject
//
//  Created by 任波 on 17/3/25.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRFlowModel;
@interface BRNearLiveCell : UICollectionViewCell

@property (nonatomic, strong) BRFlowModel *model;

- (void)showAnimation;

@end
