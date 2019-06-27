//
//  UIScrollView+ATBlank.h
//  ATBlank
//  https://github.com/ablettchen/ATBlank.git
//
//  Created by ablett on 2018/11/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATBlank.h"
#import "ATBlankView.h"


NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (ATBlank)

@property (nonatomic, copy, readonly) void(^updateBlankConf)(void(^block)(ATBlankConf *conf));

@property (assign, readonly, nonatomic) BOOL isBlankVisible;

- (void)setBlank:(ATBlank * _Nullable)blank;

- (void)reloadBlank;

- (void)blankConfReset;

- (NSInteger)itemsCount;

@end

NS_ASSUME_NONNULL_END
