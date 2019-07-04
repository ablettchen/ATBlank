//
//  ATBlankView.m
//  ATBlank
//
//  Created by ablett on 2019/6/26.
//

#import "ATBlankView.h"
#import "ATBlank.h"

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

#if __has_include(<ATCategories/ATCategories.h>)
#import <ATCategories/ATCategories.h>
#else
#import "ATCategories.h"
#endif

@interface ATBlankView ()

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descLabel;

@property (strong, nonatomic) ATBlankConf *conf;

@end

@implementation ATBlankView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    self.update(^(ATBlankConf * _Nonnull conf) {
    });
    return self;
}

#pragma mark - Setter, Getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.userInteractionEnabled = YES;
        _contentView.alpha = 0;
    }
    return _contentView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        _imageView.accessibilityIdentifier = @"empty set background image";
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.userInteractionEnabled = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.accessibilityIdentifier = @"empty set title";
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [UILabel new];
        _descLabel.userInteractionEnabled = YES;
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _descLabel.numberOfLines = 0;
        _descLabel.accessibilityIdentifier = @"empty set detail label";
    }
    return _descLabel;
}

- (ATBlankConf *)conf {
    if (!_conf) {
        _conf = [ATBlankConf new];
    }
    return _conf;
}

- (void)setBlank:(ATBlank *)blank {
    _blank = blank;
    self.imageView.image = blank.isAnimating ? blank.loadingImage : blank.image;
    self.titleLabel.attributedText = blank.title;
    self.descLabel.attributedText = blank.desc;
}

- (void (^)(void (^ _Nonnull)(ATBlankConf * _Nonnull)))update {
    @weakify(self);
    return ^void(void(^block)(ATBlankConf *config)) {
        @strongify(self);
        if (!self) return;
        if (block) block(self.conf);
        ///backgroundView
        self.backgroundColor = self.conf.backgroundColor;
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.titleLabel.font = self.conf.titleFont;
        self.titleLabel.textColor = self.conf.titleColor;
        
        self.descLabel.font = self.conf.descFont;
        self.descLabel.textColor = self.conf.descColor;
        
        self.userInteractionEnabled = self.conf.isTapEnable;
    };
}

#pragma mark - Privite


- (BOOL)canShowImage {
    return (self.imageView.image != nil);
}

- (BOOL)canShowTitle {
    return (self.titleLabel.attributedText.length > 0);
}

- (BOOL)canShowDesc {
    return (self.descLabel.attributedText.length > 0);
}

- (void)prepare {
    
    self.imageView.hidden = ![self canShowImage];
    self.titleLabel.hidden = ![self canShowTitle];
    self.descLabel.hidden = ![self canShowDesc];
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.center.equalTo(self);
    }];
    
    MASViewAttribute *lastAttribute = self.contentView.mas_top;
    
    if ([self canShowImage]) {
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute);
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(self.imageView.image.size);
        }];
        lastAttribute = self.imageView.mas_bottom;
    }
    
    if ([self canShowTitle]) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(self.conf.titleToImagePadding);
            make.left.right.equalTo(self.contentView);
        }];
        lastAttribute = self.titleLabel.mas_bottom;
    }
    
    if ([self canShowDesc]) {
        [self.contentView addSubview:self.descLabel];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(self.conf.descToTitlePadding);
            make.left.right.equalTo(self.contentView);
        }];
        lastAttribute = self.descLabel.mas_bottom;
    }
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastAttribute);
    }];
    
    if (self.blank.isAnimating) {
        [self.imageView.layer addAnimation:self.blank.animation forKey:@"BlankImageViewAnimationKey"];
    }else if ([self.imageView.layer animationForKey:@"BlankImageViewAnimationKey"]) {
        [self.imageView.layer removeAnimationForKey:@"BlankImageViewAnimationKey"];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.alpha = 1.f;
    } completion:^(BOOL finished) {}];

}

- (void)reset {
    for (UIView *obj in self.contentView.subviews) {[obj removeFromSuperview];}
    self.contentView.alpha = 0.f;
    self.imageView.image = nil;
    self.titleLabel.text = nil;
    self.descLabel.text = nil;
}

@end


@implementation ATBlankConf

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    [self reset];
    return self;
}

- (void)reset {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleFont = [UIFont systemFontOfSize:14];
    self.titleColor = [UIColor darkGrayColor];
    
    self.descFont = [UIFont systemFontOfSize:12];
    self.descColor = [UIColor grayColor];
    
    self.verticalOffset = 0.0;
    self.titleToImagePadding = 15.0;
    self.descToTitlePadding = 10.0;
    self.isTapEnable = true;
}

@end
