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

@property (nonatomic, copy, readonly) void(^at_updateBlankConf)(void(^block)(ATBlankConf *conf));

@property (assign, readonly, nonatomic) BOOL at_isBlankVisible;

- (void)setAt_Blank:(ATBlank * _Nullable)blank;

- (void)at_reloadBlank;

- (void)at_resetBlank;

- (void)at_blankConfReset;

@end

NS_ASSUME_NONNULL_END
