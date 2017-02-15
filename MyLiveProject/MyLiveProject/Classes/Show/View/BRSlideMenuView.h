//
//  BRSlideMenuView.h
//  MyLiveProject
//
//  Created by 任波 on 17/2/9.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BRSlideMenuBlock)(NSInteger tag);

@interface BRSlideMenuView : UIView
@property (nonatomic, copy) BRSlideMenuBlock slideMenuBlock;
/** 重写构造方法 */
- (instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)titleArr;
/** 滑动菜单下划线方法(滑动scrollView时调用，保证scrollView和lineView联动) */
- (void)scrollLineView:(NSInteger)index;

@end
