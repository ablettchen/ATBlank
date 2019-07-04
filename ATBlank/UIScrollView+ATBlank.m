//
//  UIScrollView+ATBlank.m
//  ATBlank
//  https://github.com/ablettchen/ATBlank.git
//
//  Created by ablett on 2018/11/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

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

@interface UIScrollView ()<UIGestureRecognizerDelegate>
@property (nonatomic, readonly, strong) ATBlankView *blankView;
@property (strong, nonatomic) ATBlank *blank;
@end

@implementation UIScrollView (ATBlank)

#pragma mark - Setter, Getter

- (BOOL)isBlankVisible {
    return self.blankView != nil;
}

- (ATBlank *)blank {
    return objc_getAssociatedObject(self, &kBlank);
}

- (ATBlankView *)blankView {
    ATBlankView *view = objc_getAssociatedObject(self, &kBlankView);
    if (!view) {
        view = [ATBlankView new];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tapGesture.delegate = self;
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
            conf.isTapEnable              = conf_.isTapEnable;
        });
    };
}

#pragma mark - Privite

- (BOOL)canDisplay {
    return self.blank != nil;
}

- (void)invalidate {
    if (self.blankView) {
        [self.blankView reset];
        self.blankView.hidden = YES;
        [self.blankView removeFromSuperview];
    }
    self.scrollEnabled = YES;
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (!self.blank.isTapEnable) {return;}
    if (self.blank.tapBlock) {
        self.blank.tapBlock();
    }
}

#pragma mark - Public

- (void)setBlank:(ATBlank * _Nullable)blank {
    if (![self canDisplay]) {[self invalidate];}
    objc_setAssociatedObject(self, &kBlank, blank, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)reloadBlank {
    if ([self canDisplay] && [self itemsCount] == 0) {
        ATBlankView *view = self.blankView;
        [view reset];
        
        if (view.superview == nil) {
            if ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]] || self.subviews.count > 1) {
                [self insertSubview:view atIndex:0];
            }else {
                [self addSubview:view];
            }
        }
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.centerX.centerY.equalTo(self);
        }];
        
        view.blank = self.blank;
        view.hidden = NO;
        
        [view prepare];
        self.scrollEnabled = NO;
        
    }else if ([self isBlankVisible]) {
        [self invalidate];
    }
}

- (void)blankConfReset {
    self.blankView.update(^(ATBlankConf * _Nonnull conf) {
        [conf reset];
    });
}

- (NSInteger)itemsCount {
    
    NSInteger items = 0;
    if (![self respondsToSelector:@selector(dataSource)]) {return items;}
    
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        id <UITableViewDataSource> dataSource = tableView.dataSource;
        NSInteger sections = 1;
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource tableView:tableView numberOfRowsInSection:section];
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
                items += [dataSource collectionView:collectionView numberOfItemsInSection:section];
            }
        }
    }
    return items;
}

@end

