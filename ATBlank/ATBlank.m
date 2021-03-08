//
//  ATBlank.m
//  ATBlank
//
//  Created by ablett on 2018/11/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATBlank.h"


@interface ATBlank ()
@property (strong, readwrite, nonatomic, nullable) UIImage *loadingImage;
@end

@implementation ATBlank

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    self.type = ATBlankTypeFailure;
    self.isTapEnable = YES;
    self.isAnimating = NO;
    self.loadingImage = [ATBlank blankImageWithNamed:@"blank_loading_circle"];
    self.title = [[NSAttributedString alloc] initWithString:@"未设置"];
    self.desc = [[NSAttributedString alloc] initWithString:@"请检查代码"];
    return self;
}

- (CAAnimation *)animation {
    if (_animation) {return _animation;}
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    return animation;
}

+ (UIImage *)blankImageWithNamed:(NSString *)imageName {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[ATBlank class]] pathForResource:@"ATBlank" ofType:@"bundle"]];
    NSString *name = [NSString stringWithFormat:@"%@@2x", imageName];
    return [[UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (ATBlank *)defaultBlankWithType:(enum ATBlankType)type {
    ATBlank *blank = [ATBlank new];
    blank.image = [ATBlank defaultImageWithType:type];
    switch (type) {
        case ATBlankTypeFailure:{
            blank.title = [[NSAttributedString alloc] initWithString:@"请求失败"];
        }break;
        case ATBlankTypeNoData:{
            blank.title = [[NSAttributedString alloc] initWithString:@"暂时没有数据～"];
        }break;
        case ATBlankTypeNoNetwork:{
            blank.title = [[NSAttributedString alloc] initWithString:@"哎呀,断网了～"];
        }break;
    }
    blank.desc = nil;
    return blank;
}

+ (UIImage *)defaultImageWithType:(enum ATBlankType)type {
    switch (type) {
        case ATBlankTypeFailure:{
            return [ATBlank blankImageWithNamed:@"blank_fail"];
        }break;
        case ATBlankTypeNoData:{
            return [ATBlank blankImageWithNamed:@"blank_nodata"];
        }break;
        case ATBlankTypeNoNetwork:{
            return [ATBlank blankImageWithNamed:@"blank_nonetwork"];
        }break;
    }
    return nil;
}

+ (ATBlank *)blankWithImage:(UIImage *)image title:(NSString *)title desc:(NSString *)desc {
    ATBlank *blank = [ATBlank new];
    blank.image = image;
    blank.title = [[NSAttributedString alloc] initWithString:title?:@""];
    blank.desc = [[NSAttributedString alloc] initWithString:desc?:@""];
    return blank;
}

@end
