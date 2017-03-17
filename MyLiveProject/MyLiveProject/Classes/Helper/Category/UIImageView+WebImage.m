//
//  UIImageView+WebImage.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/21.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "UIImageView+WebImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (WebImage)

#pragma mark - 异步加载图片
- (void)br_setImageWithPath:(NSString *)path placeholder:(NSString *)imageName {
    [self sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageRetryFailed|SDWebImageLowPriority];
}

#pragma mark - 异步加载图片，可以监听下载进度，成功或失败
- (void)br_setImageWithPath:(NSString *)path
          placeholder:(NSString *)imageName
              success:(DownloadImageSuccessBlock)success
               failed:(DownloadImageFailedBlock)failed
             progress:(DownloadImageProgressBlock)progress {
    [self sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        progress(receivedSize * 1.0 / expectedSize);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            failed(error);
        } else {
            self.image = image;
            success(image);
        }
    }];
}


@end
