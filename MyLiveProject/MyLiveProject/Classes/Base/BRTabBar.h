//
//  BRTabBar.h
//  MyLiveProject
//
//  Created by 任波 on 17/2/7.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BRItemType) {
    BRItemTypeLive = 1000, //展示直播
    BRItemTypeLaunch = 10, //启动直播
    BRItemTypeMe = 1001 //我的
};

@class BRTabBar;

// 回调，告诉控制器点击了哪个按钮
// 回调方式1：协议
@protocol BRTabBarDelegate <NSObject>
- (void)tabBar:(BRTabBar *)tabBar clickButton:(BRItemType)index;

@end

// 回调方式2：block
typedef void(^TabBarBlock)(BRTabBar *tabbar, BRItemType index);

@interface BRTabBar : UIView
@property (nonatomic, weak) id<BRTabBarDelegate> delegate;
@property (nonatomic, copy) TabBarBlock callBlock;

@end
