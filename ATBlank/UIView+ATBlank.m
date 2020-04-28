//
//  UIView+ATBlank.m
//  ATBlank
//
//  Created by ablett on 2019/12/24.
//

#import "UIView+ATBlank.h"
#import "UIScrollView+ATBlank.h"
#import <objc/runtime.h>

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


static char const * const kBlankView = "kBlankView";
static char const * const kBlank = "kBlank";

@interface UIView ()
@property (nonatomic, readonly, strong) ATBlankView *blankView;
@property (strong, nonatomic) ATBlank *blank;
@end

@implementation UIView (ATBlank)

#pragma mark - Setter, Getter

- (BOOL)isBlankVisible {
    return self.blankView ? !self.blankView.hidden : NO;
}

- (ATBlank *)blank {
    return objc_getAssociatedObject(self, &kBlank);
}

- (ATBlankView *)blankView {
    ATBlankView *view = objc_getAssociatedObject(self, &kBlankView);
    if (!view) {
        view = [ATBlankView new];
        @weakify(self);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            if (!self.blank.isTapEnable) {return;}
            if (self.blank.tapBlock) {self.blank.tapBlock();}
        }];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:tapGesture];
        objc_setAssociatedObject(self, &kBlankView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return view;
}

- (void)setBlankView:(ATBlankView *)blankView {
    objc_setAssociatedObject(self, &kBlankView, blankView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void (^ _Nonnull)(ATBlankConf * _Nonnull)))updateBlankConf {
    @weakify(self);
    return ^void(void(^block)(ATBlankConf *config)) {
        @strongify(self);
        if (!self) return;
        ATBlankConf *conf_ = [ATBlankConf new];
        if (block) {block(conf_);}
        self.blankView.update(^(ATBlankConf * _Nonnull conf) {
            conf.backgroundColor        = conf_.backgroundColor;
            conf.titleColor             = conf_.titleColor;
            conf.titleFont              = conf_.titleFont;
            conf.descColor              = conf_.descColor;
            conf.descFont               = conf_.descFont;
            conf.verticalOffset         = conf_.verticalOffset;
            conf.titleToImagePadding    = conf_.titleToImagePadding;
            conf.descToTitlePadding     = conf_.descToTitlePadding;
            conf.isTapEnable            = conf_.isTapEnable;
        });
    };
}

#pragma mark - Privite

- (BOOL)at_canDisplay {
    return self.blank != nil;
}

- (void)at_invalidate {
    if (self.blankView) {
        [self.blankView reset];
        self.blankView.hidden = YES;
        [self.blankView removeFromSuperview];
    }
    if ([self isKindOfClass:UIScrollView.class]) {
        UIScrollView *sv = (UIScrollView *)self;
        sv.scrollEnabled = YES;
    }
}

#pragma mark - Public

- (void)setBlank:(ATBlank * _Nullable)blank {
    if (![self at_canDisplay]) {[self at_invalidate];}
    objc_setAssociatedObject(self, &kBlank, blank, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)resetBlank {
    if ([self isBlankVisible]) {[self at_invalidate];}
}

- (void)reloadBlank {
    
    if (![self at_canDisplay]) {return;}
    
    NSInteger count = 0;
    if ([self isKindOfClass:UIScrollView.class]) {
        UIScrollView *sv = (UIScrollView *)self;
        count = [sv itemsCount];
    }
    
    if (count == 0) {
        ATBlankView *view = self.blankView;
        [view reset];
        
        if (view.superview == nil) {
            if ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]] || self.subviews.count > 1) {
                [self insertSubview:view atIndex:0];
            }else {
                [self addSubview:view];
            }
        }
        
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.centerX.centerY.equalTo(self);
        }];
        
        view.blank = self.blank;
        view.hidden = NO;
        
        [view prepare];
        
        if ([self isKindOfClass:UIScrollView.class]) {
            UIScrollView *sv = (UIScrollView *)self;
            sv.scrollEnabled = NO;
        }
    }else if ([self isBlankVisible]) {
        [self at_invalidate];
    }
}

- (void)blankConfReset {
    self.blankView.update(^(ATBlankConf * _Nonnull conf) {
        [conf reset];
    });
}

@end
