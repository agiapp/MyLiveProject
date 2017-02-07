//
//  BaseViewController.m
//  MyLiveProject
//
//  Created by 任波 on 17/2/7.
//  Copyright © 2017年 RENB. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_RGB_DEC(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), 1.0);
}

@end
