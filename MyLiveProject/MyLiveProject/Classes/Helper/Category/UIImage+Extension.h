//
//  UIImage+Extension.h
//  MyLiveProject
//
//  Created by 任波 on 17/3/1.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/** 给图片添加圆角(系统的添加圆角方法比较耗性能，推荐用这个) */
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

@end
