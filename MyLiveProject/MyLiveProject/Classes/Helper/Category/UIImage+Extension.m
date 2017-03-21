//
//  UIImage+Extension.m
//  MyLiveProject
//
//  Created by 任波 on 17/3/1.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

- (UIImage *)imageWithCornerRadius:(CGFloat)radius {
    CGRect rect = (CGRect){0.f, 0.f, self.size};
    // 重新生成一张和目标尺寸相同的图片，参数(大小，不透明，屏幕的分辨率)
    UIGraphicsBeginImageContextWithOptions(self.size, NO, UIScreen.mainScreen.scale);
    
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    // 绘制图像
    [self drawInRect:rect];
    // 获取绘制的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
