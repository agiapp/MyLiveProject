//
//  BRLocationManager.h
//  MyLiveProject
//
//  Created by 任波 on 17/3/25.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

typedef void(^LocationBlock)(NSString *lat, NSString *lon);

@interface BRLocationManager : NSObject
// 经度
@property (nonatomic, copy) NSString *lat;
// 纬度
@property (nonatomic, copy) NSString *lon;

/** 声明单例 */
singleton_interface(BRLocationManager)

/**
 *  作用：开始定位，并得到当前位置的经纬度
 */
- (void)getGPS:(LocationBlock)block;


@end
