//
//  NSObject+BRParse.h
//  MyLiveProject
//
//  Created by 任波 on 17/2/24.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BRParse)
/**
 *  MJExtension 解析数组和字典需要使用不同的方法。我们自己合并,用代码判断
 */
+ (id)parse:(id)responseObj;

@end
