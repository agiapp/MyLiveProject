//
//  BRLiveHandler.h
//  MyLiveProject
//
//  Created by 任波 on 17/2/21.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BaseHandler.h"

@interface BRLiveHandler : BaseHandler
#pragma mark - 在这层里写网络请求和数据解析

/**
 *  获取热门直播信息
 *
 *  @param success  成功后的回调
 *  @param failed   失败后的回调
 */
+ (void)executeGetHotLiveTaskWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed;

/**
 *  获取附近的直播信息
 *
 *  @param success  成功后的回调
 *  @param failed   失败后的回调
 */
+ (void)executeGetNearLiveTaskWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed;

/**
 *  获取广告页
 *
 *  @param success  成功后的回调
 *  @param failed   失败后的回调
 */
+ (void)executeGetAdvertiseTaskWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed;


@end

