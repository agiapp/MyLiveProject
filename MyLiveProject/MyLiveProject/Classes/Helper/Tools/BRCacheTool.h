//
//  BRCacheTool.h
//  MyLiveProject
//
//  Created by 任波 on 17/3/26.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRCacheTool : NSObject

#pragma mark - 保存信息到偏好设置
/// 广告图片
+ (void)setAdImagePath:(NSString *)adImagePath;
+ (NSString *)adImagePath;

@end
