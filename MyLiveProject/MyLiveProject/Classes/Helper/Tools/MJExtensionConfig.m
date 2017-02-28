//
//  MJExtensionConfig.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/25.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "MJExtensionConfig.h"
#import "MJExtension.h"

@implementation MJExtensionConfig
/**
 *  这个方法会在MJExtensionConfig加载进内存时自动调用一次
 */
+ (void)load {
    /**
     *  解决网络的JSON字段和本地模型属性名不一致的情况
     *  注意点：
     *      1.如果使用NSObject来调用这些方法，代表所有继承自NSObject的类都会生效
     *      2.网络JSON字段名是OC关键字的时候，本地属性名需重命名，避免和系统关键字冲突
     *
     *  @return 左边是本地属性名，右侧是网络JSON名
     */
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"desc" : @"description"
                 };
    }];
    // 相当于在MJStudent.m中实现了+(NSDictionary *)mj_replacedKeyFromPropertyName方法
    
#pragma mark MJDog的所有驼峰属性转成下划线key去字典中取值
    [NSObject mj_setupReplacedKeyFromPropertyName121:^NSString *(NSString *propertyName) {
        return [propertyName mj_underlineFromCamel];
    }];
    // 相当于在MJDog.m中实现了+(NSDictionary *)mj_replacedKeyFromPropertyName121:方法
}

@end
