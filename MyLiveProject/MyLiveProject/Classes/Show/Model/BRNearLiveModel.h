//
//  BRNearLiveModel.h
//  MyLiveProject
//
//  Created by 任波 on 17/3/26.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRHotLiveModel.h"

/// BRLabelModel
@interface BRLabelModel : NSObject
@property (nonatomic, strong) NSArray * cl;
@property (nonatomic, strong) NSString * tabKey;
@property (nonatomic, strong) NSString * tabName;

@end

/// BRExtraModel
@interface BRExtraModel : NSObject
@property (nonatomic, strong) NSString * cover;
@property (nonatomic, strong) BRLabelModel * label;

@end

/// BRInfoModel
@interface BRInfoModel : NSObject
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) BRCreatorModel * creator;
@property (nonatomic, strong) NSString * distance;
@property (nonatomic, strong) BRExtraModel * extra;
@property (nonatomic, assign) NSInteger group;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger landscape;
@property (nonatomic, strong) NSArray * like;
@property (nonatomic, assign) NSInteger link;
@property (nonatomic, strong) NSString * liveType;
@property (nonatomic, assign) NSInteger multi;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger optimal;
@property (nonatomic, assign) NSInteger rotate;
@property (nonatomic, strong) NSString * shareAddr;
@property (nonatomic, assign) NSInteger slot;
@property (nonatomic, strong) NSString * streamAddr;
@property (nonatomic, assign) NSInteger tagId;
@property (nonatomic, assign) NSInteger version;

@end

/// BRFlowModel
@interface BRFlowModel : NSObject
@property (nonatomic, strong) NSString * flowType;
@property (nonatomic, strong) BRInfoModel * info;

/** 添加show属性，判断加载动画是否已显示 */
@property (nonatomic, getter=isShow) BOOL show;

@end


