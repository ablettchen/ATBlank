//
//  ATBlank.h
//  ZHIsland
//
//  Created by ablett on 2022/9/2.
//  Copyright © 2022 zhisland. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ATBlankType) {
    ATBlankTypeNoNetwork,
    ATBlankTypeFailure,
    ATBlankTypeNoData,
};

@interface ATBlank : NSObject

@property (nonatomic, assign) enum ATBlankType type;                 // 类型

@property (nonatomic, strong, nullable) UIImage *icon;               // 图标
@property (nonatomic, copy, nullable) NSString *title;               // 标题
@property (nonatomic, copy, nullable) NSString *actionTitle;         // 按钮标题

@property (nonatomic, assign) BOOL isTapEnable;                      // 无数据时是否可点击
@property (nonatomic, copy, nullable) void(^action)(void);           // 点击事件

@property (nonatomic, strong, nullable) __kindof UIView *customView; // 自定义空白视图

// 默认实现
+ (ATBlank *)noNetworkBlank;
+ (ATBlank *)failureBlank;
+ (ATBlank *)noDataBlank;

@end

@class ATBlankConf;
@interface ATBlankView : UIView

@property (nonatomic, strong) ATBlank *blank;                                         // 空白对象
@property (nonatomic, copy, readonly) void(^update)(void(^block)(ATBlankConf *conf)); // 更新

- (void)reset;      // 重置
- (void)prepare;    // 准备

@end


@interface ATBlankConf : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;             // 背景色
@property (nonatomic, strong) UIColor *titleColor;                  // 标题颜色
@property (nonatomic, strong) UIFont *titleFont;                    // 标题字体
@property (nonatomic, strong) UIColor *actionTitleNormalColor;      // 按钮标题常规颜色
@property (nonatomic, strong) UIColor *actionTitleHighlightedColor; // 按钮标题高亮颜色
@property (nonatomic, strong) UIFont *actionFont;                   // 按钮字体
@property (nonatomic, assign) CGFloat actionBorderWidth;            // 按钮边宽
@property (nonatomic, strong) UIColor *actionBorderColor;           // 按钮边色
@property (nonatomic, assign) CGFloat actionCornerRadius;           // 按钮圆角半径

@property (nonatomic, assign) CGFloat verticalOffset;               // 垂直偏移
@property (nonatomic, assign) CGFloat titleToImageSpacing;          // 标题距图片间距
@property (nonatomic, assign) CGFloat actionToTitleSpacing;         // 按钮距标题间距
@property (nonatomic, assign) CGFloat actionHeight;                 // 按钮高度
@property (nonatomic, assign) CGFloat isTapEnable;                  // 是否可点击

- (void)reset;                                                      // 重置配置

@end

@interface UIView (ATBlank)

@property (nonatomic, copy, readonly) void(^atUpdateBlankConf)(void(^block)(ATBlankConf *conf)); // 更新
@property (nonatomic, assign, readonly) BOOL atIsBlankVisible;                                   // 空白是否可见
@property (nonatomic, strong, nullable) ATBlank *atBlank;                                        // 空白对象

// 刷新
- (void)atReloadBlank;

// 重置
- (void)atResetBlank;

// 重置配置
- (void)atResetBlankConf;

@end



@interface UIScrollView (ATBlank)

// TableView / CollectionView item 数量
- (NSUInteger)atItemsCount;

@end

NS_ASSUME_NONNULL_END
