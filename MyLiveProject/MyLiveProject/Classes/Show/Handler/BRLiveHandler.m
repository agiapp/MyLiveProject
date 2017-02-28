//
//  BRLiveHandler.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/21.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BRLiveHandler.h"
#import "HttpTool.h"
#import "BRLiveModel.h"

@implementation BRLiveHandler
#pragma mark - 获取热门直播信息
+ (void)executeGetHotLiveTaskWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed {
    NSDictionary *params = @{@"uid":@"391980701"};
    [HttpTool getWithPath:API_HotLive params:params success:^(id jsonObj) {
        // 回传一个JSON意义不大，这里回传一个已经解析好的对象数组。
        // success(jsonObj);
        NSInteger status = [jsonObj[@"dm_error"] integerValue];
        MYLog(@"error_msg = %@", jsonObj[@"error_msg"]);
        if (status == 0) {
            // 如果操作成功，先做数据解析，再返回解析结果
            MYLog(@"请求热门直播的信息：%@", jsonObj);
            NSArray *liveModelArr = [BRLiveModel parse:jsonObj[@"lives"]];
            success(liveModelArr);
        } else {
            failed(jsonObj); // 回传服务器返回的错误信息
        }
    } failure:^(NSError *error) {
        failed(error); // 回传请求失败的错误信息
    }];
}

#pragma mark - 获取附近的直播信息
+ (void)executeGetNearLiveTaskWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed {
    NSDictionary *params = @{@"uid":@"391980701", @"latitude":@"30.281094", @"longitude":@"120.140750"};
    [HttpTool getWithPath:API_NearLive params:params success:^(id jsonObj) {
        NSInteger status = [jsonObj[@"dm_error"] integerValue];
        MYLog(@"error_msg = %@", jsonObj[@"error_msg"]);
        if (status == 0) {
            success(jsonObj);
        } else {
            failed(jsonObj);
        }
    } failure:^(NSError *error) {
        failed(error);
    }];
}

#pragma mark - 获取广告页、关注
+ (void)executeGetAdvertiseTaskWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed {
    NSDictionary *params = @{@"uid":@"391980701", @"hfv":@"1.1", @"type":@"1"};
    [HttpTool getWithPath:API_Focus params:params success:^(id jsonObj) {
        NSInteger status = [jsonObj[@"dm_error"] integerValue];
        MYLog(@"error_msg = %@", jsonObj[@"error_msg"]);
        if (status == 0) {
            success(jsonObj);
        } else {
            failed(jsonObj);
        }
    } failure:^(NSError *error) {
        failed(error);
    }];
}

@end
