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
@property (strong, nonatomic) ATBlank *at_blank;
@end

@implementation UIView (ATBlank)

#pragma mark - Setter, Getter

- (BOOL)at_isBlankVisible {
    if (self.at_blank.customBlankView) {return !self.at_blank.customBlankView.hidden;}
    return self.blankView ? !self.blankView.hidden : NO;
}

- (ATBlank *)at_blank {
    return objc_getAssociatedObject(self, &kBlank);
}

- (ATBlankView *)blankView {
    ATBlankView *view = objc_getAssociatedObject(self, &kBlankView);
    if (!view) {
        view = [ATBlankView new];
        @weakify(self);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            if (!self.at_blank.isTapEnable) {return;}
            if (self.at_blank.tapBlock) {self.at_blank.tapBlock();}
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

- (void (^)(void (^ _Nonnull)(ATBlankConf * _Nonnull)))at_updateBlankConf {
    @weakify(self);
    return ^void(void(^block)(ATBlankConf *config)) {
        @strongify(self);
        if (!self) return;
        ATBlankConf *conf_ = [ATBlankConf new];
        if (block) {block(conf_);}
        __weak typeof(conf_)weakConf = conf_;
        self.blankView.update(^(ATBlankConf * _Nonnull conf) {
            conf.backgroundColor        = weakConf.backgroundColor;
            conf.titleColor             = weakConf.titleColor;
            conf.titleFont              = weakConf.titleFont;
            conf.descColor              = weakConf.descColor;
            conf.descFont               = weakConf.descFont;
            conf.verticalOffset         = weakConf.verticalOffset;
            conf.titleToImagePadding    = weakConf.titleToImagePadding;
            conf.descToTitlePadding     = weakConf.descToTitlePadding;
            conf.isTapEnable            = weakConf.isTapEnable;
        });
    };
}

#pragma mark - Privite

- (BOOL)at_canDisplay {
    return self.at_blank != nil;
}

- (void)at_invalidate {
    if (self.at_blank.customBlankView) {
        self.at_blank.customBlankView.hidden = YES;
        [self.at_blank.customBlankView removeFromSuperview];
    }else if (self.blankView) {
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

- (void)setAt_Blank:(ATBlank * _Nullable)blank {
    if (![self at_canDisplay]) {[self at_invalidate];}
    objc_setAssociatedObject(self, &kBlank, blank, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)at_resetBlank {
    if ([self at_isBlankVisible]) {[self at_invalidate];}
}

- (void)at_reloadBlank {
    
    if (![self at_canDisplay]) {return;}
    
    NSInteger count = 0;
    if ([self isKindOfClass:UIScrollView.class]) {
        UIScrollView *sv = (UIScrollView *)self;
        count = [sv at_itemsCount];
    }
    
    if (count == 0) {
        
        @weakify(self)
        void(^addBlankView)(UIView *view) = ^(UIView *view) {
            @strongify(self)
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
        };

        if (self.at_blank.customBlankView) {
            addBlankView(self.at_blank.customBlankView);
            self.at_blank.customBlankView.hidden = NO;
        }else {
            ATBlankView *view = self.blankView;
            [view reset];
            addBlankView(view);
            view.blank = self.at_blank;
            view.hidden = NO;
            [view prepare];
        }
        if ([self isKindOfClass:UIScrollView.class]) {
            UIScrollView *sv = (UIScrollView *)self;
            sv.scrollEnabled = NO;
        }
        
    }else if ([self at_isBlankVisible]) {
        [self at_invalidate];
    }
}

- (void)at_blankConfReset {
    self.blankView.update(^(ATBlankConf * _Nonnull conf) {
        [conf reset];
    });
}

@end
