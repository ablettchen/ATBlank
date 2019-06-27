//
//  ATBlank.h
//  ATBlank
//  https://github.com/ablettchen/ATBlank.git
//
//  Created by ablett on 2018/11/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ATBlankType) {
    ATBlankTypeFailure = 1,                         ///< 加载失败
    ATBlankTypeNoData = 2,                          ///< 暂无数据
    ATBlankTypeNoNetwork = 3,                       ///< 暂无网络
};

@interface ATBlank : NSObject

@property (strong, nonatomic, nullable) UIImage *image;                     ///< 展示图片
@property (strong, readonly, nonatomic, nullable) UIImage *loadingImage;    ///< 展示图片
@property (copy, nonatomic, nullable) NSAttributedString *title;            ///< 标题
@property (copy, nonatomic, nullable) NSAttributedString *desc;             ///< 描述

@property (assign, nonatomic) enum ATBlankType type;                        ///< 类型
@property (assign, nonatomic) BOOL isTapEnable;                             ///< 是否允许点击 默认YES
@property (assign, nonatomic) BOOL isAnimating;                             ///< 是否正在做动画，默认NO
@property (strong, nonatomic) CAAnimation *animation;                       ///< 动画
@property (copy, nonatomic) void (^tapBlock)(void);                         ///< 点击事件

/**
 空白页
 
 @param image 图片
 @param title 标题
 @param desc 描述
 @return 空白页实例
 */
+ (ATBlank *)blankWithImage:(nullable UIImage *)image
                      title:(nullable NSString *)title
                       desc:(nullable NSString *)desc;

/**
 获取默认空白页
 
 @param type 空白页类型
 @return 空白页实例
 */
+ (ATBlank *)defaultBlank:(enum ATBlankType)type;

/**
 默认空白页图片
 
 @param type 空白页类型
 @return 图片实例
 */
+ (UIImage *)defaultImage:(enum ATBlankType)type;

@end

NS_INLINE ATBlank *defaultBlank(enum ATBlankType type) {
    return [ATBlank defaultBlank:type];
}

NS_INLINE UIImage *blankImage(enum ATBlankType type) {
    return [ATBlank defaultImage:type];
}

NS_INLINE ATBlank *blankMake(UIImage * _Nullable image, NSString * _Nullable title, NSString * _Nullable desc) {
    return [ATBlank blankWithImage:image title:title desc:desc];
}

NS_ASSUME_NONNULL_END
