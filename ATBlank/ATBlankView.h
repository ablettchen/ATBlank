//
//  ATBlankView.h
//  ATBlank
//
//  Created by ablett on 2019/6/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ATBlank;
@class ATBlankConf;
@interface ATBlankView : UIView

@property (strong, nonatomic) ATBlank *blank;

@property (nonatomic, copy, readonly) void(^update)(void(^block)(ATBlankConf *conf));

- (void)prepare;
- (void)reset;

@end

@interface ATBlankConf : NSObject

@property (strong, nonatomic) UIColor *backgroundColor;

@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIFont *titleFont;

@property (strong, nonatomic) UIColor *descColor;
@property (strong, nonatomic) UIFont *descFont;

@property (assign, nonatomic) CGFloat verticalOffset;
@property (assign, nonatomic) CGFloat titleToImagePadding;
@property (assign, nonatomic) CGFloat descToTitlePadding;

@property (assign, nonatomic) CGFloat isTapEnable;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
