//
//  BRLiveModel.h
//  MyLiveProject
//
//  Created by 任波 on 17/2/25.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRCreatorModel.h"

@interface BRLiveModel : NSObject

@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) BRCreatorModel * creator;
@property (nonatomic, assign) NSInteger group;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, assign) NSInteger landscape;
@property (nonatomic, assign) NSInteger link;
@property (nonatomic, strong) NSString * liveType;
@property (nonatomic, assign) NSInteger multi;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger onlineUsers;
@property (nonatomic, assign) NSInteger optimal;
@property (nonatomic, assign) NSInteger pubStat;
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, assign) NSInteger rotate;
@property (nonatomic, strong) NSString * shareAddr;
@property (nonatomic, assign) NSInteger slot;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * streamAddr;
@property (nonatomic, assign) NSInteger tagId;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, assign) NSInteger version;

@end
