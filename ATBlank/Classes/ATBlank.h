//
//  ATBlank.h
//  ATBlank
//  https://github.com/ablettchen/ATBlank.git
//
//  Created by ablett on 2018/11/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

// 空白类型
typedef NS_ENUM(NSUInteger, ATBlankType) {
    ATBlankTypeNoNetwork,                   // 无网络
    ATBlankTypeFailure,                     // 失败
    ATBlankTypeNoData,                      // 无数据
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
+ (ATBlank * _Nonnull)noNetworkBlank;
+ (ATBlank * _Nonnull)failureBlank;
+ (ATBlank * _Nonnull)noDataBlank;

@end




@class ATBlankConf;
@interface ATBlankView : UIView

@property (nonatomic, strong, nullable) ATBlank *blank;                                         // 空白对象
@property (nonatomic, copy, nonnull, readonly) void(^update)(void(^block)(ATBlankConf *conf));  // 更新

// 重置
- (void)reset;

// 准备
- (void)prepare;

@end



@interface ATBlankConf : NSObject

@property (nonatomic, strong, nonnull) UIColor *backgroundColor;             // 背景色
@property (nonatomic, strong, nonnull) UIColor *titleColor;                  // 标题颜色
@property (nonatomic, strong, nonnull) UIFont *titleFont;                    // 标题字体
@property (nonatomic, strong, nonnull) UIColor *actionTitleNormalColor;      // 按钮标题常规颜色
@property (nonatomic, strong, nonnull) UIColor *actionTitleHighlightedColor; // 按钮标题高亮颜色
@property (nonatomic, strong, nonnull) UIFont *actionFont;                   // 按钮字体
@property (nonatomic, strong, nonnull) UIColor *actionBorderColor;           // 按钮边色
@property (nonatomic, assign) CGFloat actionBorderWidth;                     // 按钮边宽
@property (nonatomic, assign) CGFloat actionCornerRadius;                    // 按钮圆角半径
@property (nonatomic, assign) CGFloat verticalOffset;                        // 垂直偏移
@property (nonatomic, assign) CGFloat titleToImageSpacing;                   // 标题距图片间距
@property (nonatomic, assign) CGFloat actionToTitleSpacing;                  // 按钮距标题间距
@property (nonatomic, assign) CGFloat actionHeight;                          // 按钮高度
@property (nonatomic, assign) CGFloat isTapEnable;                           // 是否可点击

// 重置配置
- (void)reset;

@end



@interface UIView (ATBlank)

// 更新
@property (nonatomic, copy, nullable, readonly) void(^atUpdateBlankConf)(void(^ _Nonnull block)(ATBlankConf * _Nonnull conf));

// 空白是否可见
@property (nonatomic, assign, readonly) BOOL atIsBlankVisible;

// 空白对象
@property (nonatomic, strong, nullable) ATBlank *atBlank;

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


@interface UIColor (ATBlank)
+ (UIColor * _Nonnull (^)(uint32_t))atFromHex;
+ (UIColor * _Nonnull (^)(uint32_t, CGFloat))atFromHexA;
@end

NS_ASSUME_NONNULL_END
