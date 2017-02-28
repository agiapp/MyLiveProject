//
//  NSString+Check.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/26.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "NSString+Check.h"

@implementation NSString (Check)
#pragma 判断字符串是否为空字符
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

@end
