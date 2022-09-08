//
//  ATBlank.m
//  ATBlank
//  https://github.com/ablettchen/ATBlank.git
//
//  Created by ablett on 2018/11/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATBlank.h"
#import <objc/runtime.h>

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif


@interface NSBundle (ATBlank)
+ (NSBundle * _Nullable)atBlank;
@end

@implementation NSBundle (ATBlank)
+ (NSBundle *)atBlank {
    NSString *path = [[[NSBundle bundleForClass:ATBlank.class] resourcePath] stringByAppendingString:@"/ATBlank.bundle"];
    if (path) {
        return [NSBundle bundleWithPath:path];
    }
    return nil;
}
@end

@interface UIImage (ATBlank)
+ (UIImage *)atBlankImageNamed:(NSString *)name;
@end

@implementation UIImage (ATBlank)
+ (UIImage *)atBlankImageNamed:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[NSBundle atBlank] compatibleWithTraitCollection:nil];
}
@end

@interface UIColor (ATBlank)
+ (UIColor *)_BG1Color;
+ (UIColor *)_F2Color;
+ (UIColor *)_SCPColor;
+ (UIColor *)_SCColor;
@end

@implementation  UIColor (ATBlank)
+ (UIColor *)_BG1Color {
    return UIColor.whiteColor;
}
+ (UIColor *)_F2Color {
    return [UIColor.blackColor colorWithAlphaComponent:0.54];
}
+ (UIColor *)_SCPColor {
    return [UIColor colorWithRed:192.0 / 255.0 green:146.0 / 255.0 blue:81.0 / 255.0 alpha:1.0];
}
+ (UIColor *)_SCColor {
    return [UIColor colorWithRed:206.0 / 255.0 green:172.0 / 255.0 blue:126.0 / 255.0 alpha:1.0];
}
@end

@implementation ATBlank

+ (ATBlank *)noNetworkBlank {
    ATBlank *obj = ATBlank.new;
    obj.type = ATBlankTypeNoNetwork;
    obj.isTapEnable = YES;
    obj.icon = [UIImage atBlankImageNamed:@"blank_nonetwork"];
    obj.title = @"哎呦，网络连接不畅";
    obj.actionTitle = @"点击重新加载";
    return obj;
}

+ (ATBlank *)failureBlank {
    ATBlank *obj = ATBlank.new;
    obj.type = ATBlankTypeFailure;
    obj.isTapEnable = YES;
    obj.icon = [UIImage atBlankImageNamed:@"blank_failure"];
    obj.title = @"哎呦，数据加载失败";
    obj.actionTitle = @"点击重新加载";
    return obj;
}

+ (ATBlank *)noDataBlank {
    ATBlank *obj = ATBlank.new;
    obj.type = ATBlankTypeNoData;
    obj.isTapEnable = YES;
    obj.icon = [UIImage atBlankImageNamed:@"blank_nodata"];
    obj.title = @"当前内容为空";
    return obj;
}

@end


@interface ATBlankView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *actionButtton;

@property (strong, nonatomic) ATBlankConf *conf;

@end

@implementation ATBlankView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.update(^(ATBlankConf * _Nonnull conf) {});
    }
    return self;
}

#pragma mark - public

- (void (^)(void (^ _Nonnull)(ATBlankConf * _Nonnull)))update {
    
    __weak typeof(self) wSelf = self;
    return ^void(void(^block)(ATBlankConf *conf)) {
        if (!wSelf) return;
        if (block) { block(wSelf.conf); }
        
        self.backgroundColor = self.conf.backgroundColor;
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.titleLabel.font = self.conf.titleFont;
        self.titleLabel.textColor = self.conf.titleColor;
        
        [self.actionButtton setTitleColor:self.conf.actionTitleNormalColor forState:UIControlStateNormal];
        [self.actionButtton setTitleColor:self.conf.actionTitleHighlightedColor forState:UIControlStateHighlighted];
        self.actionButtton.titleLabel.font = self.conf.actionFont;
        self.actionButtton.layer.borderWidth = self.conf.actionBorderWidth;
        self.actionButtton.layer.borderColor = self.conf.actionBorderColor.CGColor;
        self.actionButtton.layer.cornerRadius = self.conf.actionCornerRadius;
        self.userInteractionEnabled = self.conf.isTapEnable;
        
        if (self.contentView.superview) {
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView.superview).offset(self.conf.verticalOffset);
            }];
        }
    };
}

- (void)prepare {
    
    self.iconView.hidden = !self._canShowIcon;
    self.titleLabel.hidden = !self._canShowTitle;
    self.actionButtton.hidden = !self._canShowButton;
    
    [self addSubview:self.contentView];
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.center.equalTo(self);
    }];
    
    MASViewAttribute *lastAttribute = self.contentView.mas_top;
    if (self._canShowIcon) {
        
        CGSize size = self.blank.type == ATBlankTypeFailure ? CGSizeMake(78, 60) : self.iconView.image.size;
        [self.contentView addSubview:self.iconView];
        [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute);
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(size);
        }];
        lastAttribute = self.iconView.mas_bottom;
    }
    
    if (self._canShowTitle) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(self.conf.titleToImageSpacing);
            make.left.right.equalTo(self.contentView);
        }];
        lastAttribute = self.titleLabel.mas_bottom;
    }
    
    
    if (self._canShowButton) {
        [self.contentView addSubview:self.actionButtton];
        
        CGFloat actionTitleWidth = \
        [self.blank.title boundingRectWithSize:CGSizeMake(HUGE, HUGE)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:@{NSFontAttributeName: self.conf.actionFont}
                                       context:nil].size.width;
        CGFloat buttonWidth = actionTitleWidth + 42;
        
        [self.actionButtton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(self.conf.actionToTitleSpacing);
            make.width.mas_equalTo(buttonWidth);
            make.height.mas_equalTo(self.conf.actionHeight);
            make.centerX.equalTo(self.contentView);
        }];
        lastAttribute = self.actionButtton.mas_bottom;
    }
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastAttribute);
    }];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(self.conf.verticalOffset);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.alpha = 1.f;
    }];
}

- (void)reset {
    
    for (UIView *obj in self.contentView.subviews) { [obj removeFromSuperview]; }
    self.contentView.alpha = 0.f;
    self.iconView.image = nil;
    self.titleLabel.text = nil;
    [self.actionButtton setTitle:nil forState:UIControlStateNormal];
}

#pragma mark - private

- (BOOL)_canShowIcon {
    return self.iconView.image != nil;
}

- (BOOL)_canShowTitle {
    return self.titleLabel.text.length > 0;
}

- (BOOL)_canShowButton {
    return [self.actionButtton titleForState:UIControlStateNormal].length > 0;
}

- (void)_butttonAction {
    if (self.blank.action) { self.blank.action(); }
}

#pragma mark - getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.alpha = 0;
    }
    return _contentView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        _iconView.userInteractionEnabled = YES;
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.userInteractionEnabled = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIButton *)actionButtton {
    if (!_actionButtton) {
        _actionButtton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButtton addTarget:self action:@selector(_butttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButtton;
}

- (ATBlankConf *)conf {
    if (!_conf) {
        _conf = [ATBlankConf new];
    }
    return _conf;
}

#pragma mark - setter

- (void)setBlank:(ATBlank *)blank {
    _blank = blank;
    self.iconView.image = blank.icon;
    self.titleLabel.text = blank.title;
    [self.actionButtton setTitle:blank.actionTitle forState:UIControlStateNormal];
}

@end


@implementation ATBlankConf

- (instancetype)init {
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

- (void)reset {
    
    self.backgroundColor = UIColor._BG1Color;
    self.titleFont = [UIFont systemFontOfSize:16];
    self.titleColor = UIColor._F2Color;
    self.actionTitleNormalColor = UIColor._SCPColor;
    self.actionTitleHighlightedColor = UIColor._SCColor;
    self.actionFont = [UIFont systemFontOfSize:16];
    self.actionBorderWidth = 1.0;
    self.actionBorderColor = UIColor._SCPColor;
    self.actionCornerRadius = 3.0;
    
    self.verticalOffset = -11.0;
    self.titleToImageSpacing = 18.0;
    self.actionToTitleSpacing = 18.0;
    self.actionHeight = 40;
    self.isTapEnable = true;
}

@end



@interface UIView ()

@property (nonatomic, strong, nonnull) ATBlankView *atBlankView;

@end

@implementation UIView (ATBlank)


- (void)setAtBlank:(ATBlank *)atBlank {
    if (!atBlank) { [self _atInvalidate]; }
    objc_setAssociatedObject(self, @selector(atBlank), atBlank, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ATBlank *)atBlank {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAtBlankView:(ATBlankView *)atBlankView  {
    objc_setAssociatedObject(self, @selector(atBlankView), atBlankView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ATBlankView *)atBlankView {
    ATBlankView *obj = objc_getAssociatedObject(self, _cmd);
    if (obj == nil) {
        obj = ATBlankView.new;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_atBlankTapped:)];
        obj.userInteractionEnabled = YES;
        [obj addGestureRecognizer:tap];

        [self setAtBlankView:obj];
    }
    return obj;
}

#pragma mark - public

- (void (^)(void (^ _Nonnull)(ATBlankConf * _Nonnull)))atUpdateBlankConf {
    
    __weak typeof(self) wSelf = self;
    return ^void(void(^block)(ATBlankConf *config)) {
        if (!wSelf) return;
        ATBlankConf *conf_ = [ATBlankConf new];
        if (block) {block(conf_);}
        __weak typeof(conf_)weakConf = conf_;
        self.atBlankView.update(^(ATBlankConf * _Nonnull conf) {
            conf.backgroundColor             = weakConf.backgroundColor;
            conf.titleColor                  = weakConf.titleColor;
            conf.titleFont                   = weakConf.titleFont;
            conf.actionTitleNormalColor      = weakConf.actionTitleNormalColor;
            conf.actionTitleHighlightedColor = weakConf.actionTitleHighlightedColor;
            conf.actionFont                  = weakConf.actionFont;
            conf.actionBorderWidth           = weakConf.actionBorderWidth;
            conf.actionBorderColor           = weakConf.actionBorderColor;
            conf.actionCornerRadius          = weakConf.actionCornerRadius;
            conf.actionToTitleSpacing        = weakConf.actionToTitleSpacing;
            conf.actionHeight                = weakConf.actionHeight;
            conf.verticalOffset              = weakConf.verticalOffset;
            conf.titleToImageSpacing         = weakConf.titleToImageSpacing;
            conf.isTapEnable                 = weakConf.isTapEnable;
        });
    };
}

- (BOOL)atIsBlankVisible {
    
    if (self.atBlank.customView) { return self.atBlank.customView.isHidden == NO; }
    return self.atBlankView.isHidden == NO;
}

- (void)atReloadBlank {
    
    if (self.atBlank == nil) { return; }
    
    NSInteger count = 0;
    if ([self isKindOfClass:UIScrollView.class]) {
        UIScrollView *obj = (UIScrollView *)self;
        count = obj.atItemsCount;
    }
    
    if (count == 0) {
     
        __weak typeof(self) wSelf = self;
        void(^addBlankView)(UIView * _Nonnull) = ^(UIView *view) {
            if (view.superview == nil) {
                if ([wSelf isKindOfClass:UITableView.class] ||
                    [wSelf isKindOfClass:UICollectionView.class] ||
                    wSelf.subviews.count > 1) {
                    [wSelf insertSubview:view atIndex:0];
                }else {
                    [wSelf addSubview:view];
                }
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.centerX.centerY.equalTo(wSelf);
                }];
            }
        };
        
        if (self.atBlank.customView) {
            addBlankView(self.atBlank.customView);
            self.atBlank.customView.hidden = NO;
        }else {
            [self.atBlankView reset];
            addBlankView(self.atBlankView);
            self.atBlankView.blank = self.atBlank;
            self.atBlankView.hidden = NO;
            [self.atBlankView prepare];
        }
        
        if ([self isKindOfClass:UIScrollView.class]) {
            UIScrollView *obj = (UIScrollView *)self;
            obj.scrollEnabled = NO;
        }
        
        return;
    }
    
    [self atResetBlank];
}

- (void)atResetBlank {
    
    if (self.atIsBlankVisible) {
        
        [self _atInvalidate];
    }
}

- (void)atResetBlankConf {
    
    self.atBlankView.update(^(ATBlankConf * _Nonnull conf) {
        [conf reset];
    });
}

#pragma mark - private

- (void)_atInvalidate {
    
    if (self.atBlank.customView) {
        self.atBlank.customView.hidden = YES;
        [self.atBlank.customView removeFromSuperview];
    }else if (self.atBlankView) {
        [self.atBlankView reset];
        self.atBlankView.hidden = YES;
        [self.atBlankView removeFromSuperview];
    }
    
    if ([self isKindOfClass:UIScrollView.class]) {
        UIScrollView *obj = (UIScrollView *)self;
        obj.scrollEnabled = NO;
    }
}

- (void)_atBlankTapped:(UITapGestureRecognizer *)sender {
    
    if (!self.atBlank.isTapEnable) { return; }
    if (self.atBlank.actionTitle.length) { return; }
    if (self.atBlank.action) { self.atBlank.action(); }
}

#pragma mark - getter


#pragma mark - setter

@end


@implementation UIScrollView (ATBlank)


- (NSUInteger)atItemsCount {

    NSInteger count = 0;
    if (![self respondsToSelector:@selector(dataSource)]) {return count;}
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        id <UITableViewDataSource> dataSource = tableView.dataSource;
        NSInteger sections = 1;
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                count += [dataSource tableView:tableView numberOfRowsInSection:section];
            }
        }
    }else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        id <UICollectionViewDataSource> dataSource = collectionView.dataSource;
        NSInteger sections = 1;
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
            sections = [dataSource numberOfSectionsInCollectionView:collectionView];
        }
        if (dataSource && [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                count += [dataSource collectionView:collectionView numberOfItemsInSection:section];
            }
        }
    }
    return count;
}

@end
