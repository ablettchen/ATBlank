//
//  UIScrollView+ATBlank.h
//  ATBlank
//  https://github.com/ablettchen/ATBlank.git
//
//  Created by ablett on 2018/11/5.
//

#import <UIKit/UIKit.h>
#import "ATBlank.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (ATBlank)

@property (assign, readonly, getter=isBlankVisible, nonatomic) BOOL blankVisible; ///< 空白页是否可见

- (void)setBlank:(ATBlank * _Nullable)blank;

/** 刷新l空白页 */
- (void)reloadBlankData;

/** 获取列表条数 */
- (NSInteger)at_itemsCount;

@end

NS_ASSUME_NONNULL_END
