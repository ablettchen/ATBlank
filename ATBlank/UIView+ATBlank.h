//
//  UIView+ATBlank.h
//  ATBlank
//
//  Created by ablett on 2019/12/24.
//


#import <UIKit/UIKit.h>
#import "ATBlank.h"
#import "ATBlankView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ATBlank)

@property (nonatomic, copy, readonly) void(^updateBlankConf)(void(^block)(ATBlankConf *conf));

@property (assign, readonly, nonatomic) BOOL isBlankVisible;

- (void)setBlank:(ATBlank * _Nullable)blank;

- (void)reloadBlank;

- (void)resetBlank;

- (void)blankConfReset;

@end

NS_ASSUME_NONNULL_END
