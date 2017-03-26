//
//  BRPlayerViewController.h
//  MyLiveProject
//
//  Created by 任波 on 17/3/12.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BaseViewController.h"

@class BRPlayerModel;
@interface BRPlayerViewController : BaseViewController
/** 直播信息模型 */
@property (nonatomic, strong) BRPlayerModel *model;

@end
