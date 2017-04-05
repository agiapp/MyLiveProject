//
//  BRCacheHelper.m
//  MyLiveProject
//
//  Created by 任波 on 17/4/3.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRCacheHelper.h"

#define AD_IMAGE_Path @"adImage"

@implementation BRCacheHelper

+ (void)setAdImagePath:(NSString *)adImagePath {
    [[NSUserDefaults standardUserDefaults] setObject:adImagePath forKey:AD_IMAGE_Path];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)adImagePath {
    return [[NSUserDefaults standardUserDefaults] objectForKey:AD_IMAGE_Path];
}

@end
