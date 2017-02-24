//
//  NSObject+BRParse.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/24.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "NSObject+BRParse.h"
#import <MJExtension.h>

@implementation NSObject (BRParse)
/** MJExtension是从模型(属性名) <-> JSON数据(key) */
+ (id)parse:(id)responseObj{
    if ([responseObj isKindOfClass:[NSArray class]]) {
        return [self mj_objectArrayWithKeyValuesArray:responseObj];
    }
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
        return [self mj_objectWithKeyValues:responseObj];
    }
    return responseObj;
}

@end
