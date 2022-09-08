//
//  ATViewController.m
//  ATBlank
//  https://github.com/ablettchen/ATBlank.git
//
//  Created by ablett on 2018/11/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATViewController.h"
#import <ATBlank/ATBlank.h>


@interface ATViewController ()
@end

@implementation ATViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) wSelf = self;
    
    // 更新空白样式配置：可选，如不配置，则取默认配置
    self.view.atUpdateBlankConf(^(ATBlankConf * _Nonnull conf) {
        conf.backgroundColor = UIColor.blackColor;
        conf.titleFont = [UIFont boldSystemFontOfSize:16];
        conf.titleColor = UIColor.whiteColor;
        conf.verticalOffset = -100;
    });
    
    
    // 创建空白对象
    ATBlank *blank = ATBlank.failureBlank;
    blank.title = @"哎呀，加载失败了";
    blank.action = ^{
        // 重置样式设置
        [wSelf.view atResetBlankConf];
    };
    
    // 关联空白对象
    self.view.atBlank = blank;
    
    // 刷新显示
    [self.view atReloadBlank];
}

@end
