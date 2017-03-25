//
//  UIImageView+BRAdd.h
//  MyLiveProject
//
//  Created by 任波 on 17/3/25.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DownloadImageSuccessBlock)(UIImage *image);
typedef void(^DownloadImageFailedBlock)(NSError *error);
typedef void(^DownloadImageProgressBlock)(CGFloat progress);

@interface UIImageView (BRAdd)
/**
 *  异步加载图片
 *
 *  @param path       图片地址
 *  @param imageName 占位图片名
 */

- (void)br_setImageWithPath:(NSString *)path placeholder:(NSString *)imageName;

/**
 *  异步加载图片，可以监听下载进度，成功或失败
 *
 *  @param path      图片地址
 *  @param imageName 占位图片名
 *  @param progress  下载进度
 *  @param success   下载成功
 *  @param failed    下载失败
 */

- (void)br_setImageWithPath:(NSString *)path
                placeholder:(NSString *)imageName
                   progress:(DownloadImageProgressBlock)progress
                    success:(DownloadImageSuccessBlock)success
                     failed:(DownloadImageFailedBlock)failed;

@end
