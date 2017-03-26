//
//  UIImageView+BRAdd.m
//  MyLiveProject
//
//  Created by 任波 on 17/3/25.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "UIImageView+BRAdd.h"
#import <UIImageView+YYWebImage.h>

@implementation UIImageView (BRAdd)

#pragma mark - 异步加载图片
- (void)br_setImageWithPath:(NSString *)path placeholder:(NSString *)imageName {
    if (![path hasPrefix:@"http"]) {
        path = [IMAGE_HOST stringByAppendingString:path];
    }
    [self setImageWithURL:[NSURL URLWithString:path] placeholder:[UIImage imageNamed:imageName] options:YYWebImageOptionShowNetworkActivity completion:nil];
}

#pragma mark - 异步加载图片，可以监听下载进度，成功或失败
- (void)br_setImageWithPath:(NSString *)path
                placeholder:(NSString *)imageName
                   progress:(DownloadImageProgressBlock)progress
                    success:(DownloadImageSuccessBlock)success
                     failed:(DownloadImageFailedBlock)failed {
    if (![path hasPrefix:@"http"]) {
        path = [IMAGE_HOST stringByAppendingString:path];
    }
    __weak typeof(self) weaSelf = self;
    [self setImageWithURL:[NSURL URLWithString:path] placeholder:[UIImage imageNamed:imageName] options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        progress(receivedSize * 1.0 / expectedSize);
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (error) {
            failed(error);
        } else {
            weaSelf.image = image;
            success(image);
        }
    }];
    
}

#pragma mark - 下载图片，不给imageView赋值
+ (void)br_downloadImageWithUrl:(NSString *)url
                        success:(DownloadImageSuccessBlock)success
                         failed:(DownloadImageFailedBlock)failed {
    if (![url hasPrefix:@"http"]) {
        url = [IMAGE_HOST stringByAppendingString:url];
    }
    // YYWebImageOptionAvoidSetImage 下载完图片后不给ImageView赋值，需要我们手动去赋值。
    [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:url] options:YYWebImageOptionAvoidSetImage progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (error) {
            failed(error);
        } else {
            success(image);
        }
    }];
}

@end
