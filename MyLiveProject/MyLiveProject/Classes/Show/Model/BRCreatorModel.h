//
//  BRCreatorModel.h
//  MyLiveProject
//
//  Created by 任波 on 17/2/25.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRCreatorModel : NSObject

@property (nonatomic, strong) NSString * birth;
@property (nonatomic, strong) NSString * descriptionField;
@property (nonatomic, strong) NSString * emotion;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger gmutex;
@property (nonatomic, strong) NSString * hometown;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger inkeVerify;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * nick;
@property (nonatomic, strong) NSString * portrait;
@property (nonatomic, strong) NSString * profession;
@property (nonatomic, assign) NSInteger rankVeri;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, strong) NSString * thirdPlatform;
@property (nonatomic, strong) NSString * veriInfo;
@property (nonatomic, assign) NSInteger verified;
@property (nonatomic, strong) NSString * verifiedReason;

@end
