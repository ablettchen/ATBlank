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

@interface UIView (ATConstraintBasedLayoutExtensions)
- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute;
@end

#pragma mark - UIView+ATConstraintBasedLayoutExtensions

@implementation UIView (ATConstraintBasedLayoutExtensions)

- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute {
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}

@end

@interface ATBlankView : UIView

@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) CGFloat verticalOffset;
@property (nonatomic, assign) CGFloat verticalSpace;

@property (nonatomic, assign) BOOL fadeInOnDisplay;

- (void)setupConstraints;
- (void)prepareForReuse;

@end

@interface ATBlankView ()
@end
@implementation ATBlankView
@synthesize contentView = _contentView;
@synthesize titleLabel = _titleLabel, detailLabel = _detailLabel, imageView = _imageView, button = _button;

#pragma mark - Initialization Methods

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    [self addSubview:self.contentView];
    return self;
}

- (void)didMoveToSuperview {
    self.frame = self.superview.bounds;
    void(^fadeInBlock)(void) = ^{self.contentView.alpha = 1.0;};
    if (self.fadeInOnDisplay) {
        [UIView animateWithDuration:0.25
                         animations:fadeInBlock
                         completion:NULL];
    }else {
        fadeInBlock();
    }
}

#pragma mark - Getters

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.userInteractionEnabled = YES;
        _contentView.alpha = 0;
    }
    return _contentView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = NO;
        _imageView.accessibilityIdentifier = @"empty set background image";
        
        [_contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textColor = [UIColor colorWithRed:102.f/255.f
                                                green:102.f/255.f
                                                 blue:102.f/255.f
                                                alpha:1];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.accessibilityIdentifier = @"empty set title";
        
        [_contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _detailLabel.backgroundColor = [UIColor clearColor];
        
        _detailLabel.font = [UIFont systemFontOfSize:14.0];
        _detailLabel.textColor = [UIColor colorWithRed:102.f/255.f
                                                 green:102.f/255.f
                                                  blue:102.f/255.f
                                                 alpha:1];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _detailLabel.numberOfLines = 0;
        _detailLabel.accessibilityIdentifier = @"empty set detail label";
        
        [_contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        _button.backgroundColor = [UIColor clearColor];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _button.accessibilityIdentifier = @"empty set button";
        _button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentView addSubview:_button];
    }
    return _button;
}

- (BOOL)canShowImage {
    return (_imageView.image && _imageView.superview);
}

- (BOOL)canShowTitle {
    return (_titleLabel.attributedText.string.length > 0 && _titleLabel.superview);
}

- (BOOL)canShowDetail {
    return (_detailLabel.attributedText.string.length > 0 && _detailLabel.superview);
}

- (BOOL)canShowButton {
    if ([_button attributedTitleForState:UIControlStateNormal].string.length > 0 || [_button imageForState:UIControlStateNormal]) {
        return (_button.superview != nil);
    }
    return NO;
}

#pragma mark - Setters

- (void)setCustomView:(UIView *)view {
    if (!view) return;
    
    if (_customView) {
        [_customView removeFromSuperview];
        _customView = nil;
    }
    
    _customView = view;
    _customView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_customView];
}

#pragma mark - Action Methods

- (void)didTapButton:(id)sender {
    SEL selector = NSSelectorFromString(@"ac_didTapDataButton:");
    if ([self.superview respondsToSelector:selector]) {
        [self.superview performSelector:selector withObject:sender afterDelay:0.0f];
    }
}

- (void)removeAllConstraints {
    [self removeConstraints:self.constraints];
    [_contentView removeConstraints:_contentView.constraints];
}

- (void)prepareForReuse {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _titleLabel = nil;
    _detailLabel = nil;
    _imageView = nil;
    _button = nil;
    _customView = nil;
    
    [self removeAllConstraints];
}

#pragma mark - Auto-Layout Configuration

- (void)setupConstraints {
    // First, configure the content view constaints
    // The content view must alway be centered to its superview
    NSLayoutConstraint *centerXConstraint = [self equallyRelatedConstraintWithView:_contentView attribute:NSLayoutAttributeCenterX];
    NSLayoutConstraint *centerYConstraint = [self equallyRelatedConstraintWithView:_contentView attribute:NSLayoutAttributeCenterY];
    
    [self addConstraint:centerXConstraint];
    [self addConstraint:centerYConstraint];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:@{@"contentView": _contentView}]];
    
    // When a custom offset is available, we adjust the vertical constraints' constants
    if (self.verticalOffset != 0 && self.constraints.count > 0) {
        centerYConstraint.constant = self.verticalOffset;
    }
    
    // If applicable, set the custom view's constraints
    if (_customView) {
        NSLayoutConstraint *centerXConstraint = [self equallyRelatedConstraintWithView:_customView attribute:NSLayoutAttributeCenterX];
        NSLayoutConstraint *centerYConstraint = [self equallyRelatedConstraintWithView:_customView attribute:NSLayoutAttributeCenterY];
        CGFloat customViewHeight = CGRectGetHeight(_customView.frame);
        CGFloat customViewWidth = CGRectGetWidth(_customView.frame);
        NSLayoutConstraint *heightConstarint;
        NSLayoutConstraint *widthConstarint;
        if (customViewHeight == 0) {
            heightConstarint = [NSLayoutConstraint constraintWithItem:_customView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.f constant:0.f];
        }else {
            heightConstarint = [NSLayoutConstraint constraintWithItem:_customView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.f constant:0.f];
        }
        if(customViewWidth == 0) {
            widthConstarint = [NSLayoutConstraint constraintWithItem:_customView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.f constant:0.f];
        }else {
            widthConstarint = [NSLayoutConstraint constraintWithItem:_customView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.f constant:0.f];
        }
        // When a custom offset is available, we adjust the vertical constraints' constants
        if (_verticalOffset != 0) {
            centerYConstraint.constant = _verticalOffset;
        }
        [self addConstraints:@[centerXConstraint, centerYConstraint]];
        [self addConstraints:@[heightConstarint, widthConstarint]];
        //[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|" options:0 metrics:nil views:@{@"customView":_customView}]];
        //[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|" options:0 metrics:nil views:@{@"customView":_customView}]];
    }else {
        CGFloat width = CGRectGetWidth(self.frame) ? : CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat padding = roundf(width/16.0);
        CGFloat verticalSpace = self.verticalSpace ? : 11.0; // Default is 11 pts
        
        NSMutableArray *subviewStrings = [NSMutableArray array];
        NSMutableDictionary *views = [NSMutableDictionary dictionary];
        NSDictionary *metrics = @{@"padding": @(padding)};
        
        // Assign the image view's horizontal constraints
        if ([self canShowImage]) {
            _imageView.hidden = NO;
            [subviewStrings addObject:@"imageView"];
            views[[subviewStrings lastObject]] = _imageView;
            
            [self.contentView addConstraint:[_contentView equallyRelatedConstraintWithView:_imageView attribute:NSLayoutAttributeCenterX]];
        }else {
            _imageView.hidden = YES;
        }
        
        // Assign the title label's horizontal constraints
        if ([self canShowTitle]) {
            _titleLabel.hidden = NO;
            [subviewStrings addObject:@"titleLabel"];
            views[[subviewStrings lastObject]] = _titleLabel;
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[titleLabel(>=0)]-(padding)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }else {
            // or removes from its superview
            _titleLabel.hidden = YES;
            [_titleLabel removeFromSuperview];
            _titleLabel = nil;
        }
        
        // Assign the detail label's horizontal constraints
        if ([self canShowDetail]) {
            _detailLabel.hidden = NO;
            [subviewStrings addObject:@"detailLabel"];
            views[[subviewStrings lastObject]] = _detailLabel;
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[detailLabel(>=0)]-(padding)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }else {
            // or removes from its superview
            _detailLabel.hidden = YES;
            [_detailLabel removeFromSuperview];
            _detailLabel = nil;
        }
        
        // Assign the button's horizontal constraints
        if ([self canShowButton]) {
            _button.hidden = NO;
            [subviewStrings addObject:@"button"];
            views[[subviewStrings lastObject]] = _button;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[button(>=0)]-(padding)-|"
                                                                                     options:0 metrics:metrics views:views]];
        }else {
            // or removes from its superview
            _button.hidden = YES;
            [_button removeFromSuperview];
            _button = nil;
        }
        
        NSMutableString *verticalFormat = [NSMutableString new];
        
        // Build a dynamic string format for the vertical constraints, adding a margin between each element. Default is 11 pts.
        for (int i = 0; i < subviewStrings.count; i++) {
            
            NSString *string = subviewStrings[i];
            [verticalFormat appendFormat:@"[%@]", string];
            
            if (i < subviewStrings.count-1) {
                [verticalFormat appendFormat:@"-(%.f)-", verticalSpace];
            }
        }
        
        // Assign the vertical constraints to the content view
        if (verticalFormat.length > 0) {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|%@|", verticalFormat]
                                                                                     options:0 metrics:metrics views:views]];
        }
    }
}

@end




static char const * const kBlankView = "kBlankView";
#define kBlankImageViewAnimationKey @"com.ablett.blank.imageViewAnimation"

@interface UIScrollView ()<UIGestureRecognizerDelegate>
@property (nonatomic, readonly, strong) ATBlankView *blankView;
@property (strong, nonatomic) ATBlank *blank;
@end
@implementation UIScrollView (ATBlank)

#pragma mark - Getters (Public)

- (BOOL)isBlankVisible {
    UIView *view = objc_getAssociatedObject(self, kBlankView);
    return view ? !view.hidden : NO;
}

#pragma mark - Getters (Private)

- (ATBlankView *)blankView {
    ATBlankView *view = objc_getAssociatedObject(self, kBlankView);
    if (!view) {
        view = [ATBlankView new];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.hidden = YES;
        
        view.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(at_didTapContentView:)];
        view.tapGesture.delegate = self;
        [view addGestureRecognizer:view.tapGesture];
        
        [self setBlankView:view];
    }
    return view;
}

- (ATBlank *)blank {
    ATBlank *blank = objc_getAssociatedObject(self, _cmd);
    return blank;
}

- (BOOL)at_canDisplay {
    if (self.blank && ([self isKindOfClass:[UITableView class]] || \
                       [self isKindOfClass:[UICollectionView class]] || \
                       [self isKindOfClass:[UIScrollView class]])) {
        return YES;
    }
    return NO;
}

- (NSInteger)at_itemsCount {
    NSInteger items = 0;
    
    // UIScollView doesn't respond to 'dataSource' so let's exit
    if (![self respondsToSelector:@selector(dataSource)]) {
        return items;
    }
    
    // UITableView support
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
    }
    
    else if ([self isKindOfClass:[UICollectionView class]]) {
        
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

#pragma mark - Setters (Public)

- (void)setBlankView:(ATBlankView *)blankView {
    objc_setAssociatedObject(self, kBlankView, blankView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setBlank:(ATBlank * _Nullable)blank {
    if (!blank || ![self at_canDisplay]) {
        [self at_invalidate];
    }
    objc_setAssociatedObject(self, @selector(blank), blank, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    ///...
}

#pragma mark - Setters (Private)

#pragma mark - Private

- (void)at_didTapContentView:(id)sender {
    if (!self.blank.tapEnable) return;
    if (self.blank.tapBlock) {
        self.blank.tapBlock();
    }
}

- (void)at_didTapDataButton:(id)sender {
    NSLog(@"%s", __func__);
}

#pragma mark - Public

- (void)reloadBlankData {
    [self at_reloadBlankData];
}

#pragma mark - Reload APIs (Private)

- (void)at_reloadBlankData {
    if (![self at_canDisplay]) return;
    if ([self at_itemsCount] == 0) {
        
        ATBlankView *view = self.blankView;
        
        if (!view.superview) {
            // Send the view all the way to the back, in case a header and/or footer is present, as well as for sectionHeaders or any other content
            if (([self isKindOfClass:[UITableView class]] || \
                 [self isKindOfClass:[UICollectionView class]]) && \
                self.subviews.count > 1) {
                [self insertSubview:view atIndex:0];
            }else {
                [self addSubview:view];
            }
        }
        
        [view prepareForReuse];
        
        view.verticalSpace = self.blank.spaceHeight;
        view.imageView.image = (self.blank.isImageAnimating)?self.blank.loadingImage:self.blank.image;
        
        if (self.blank.title) view.titleLabel.attributedText = self.blank.title;
        if (self.blank.desc) view.detailLabel.attributedText = self.blank.desc;
        if (self.blank.btnImage) {
            [view.button setImage:self.blank.image forState:UIControlStateNormal];
        }else if (self.blank.btnTitle) {
            [view.button setAttributedTitle:self.blank.btnTitle forState:UIControlStateNormal];
            [view.button setBackgroundImage:self.blank.btnBackgroundImage forState:UIControlStateNormal];
        }
        
        view.verticalOffset = self.blank.verticalOffset;
        view.backgroundColor = self.blank.backgroundColor;
        view.hidden = NO;
        view.clipsToBounds = YES;
        view.userInteractionEnabled = self.blank.isTapEnable;
        
        [view setupConstraints];
        
        [UIView performWithoutAnimation:^{
            [view layoutIfNeeded];
        }];
        
        self.scrollEnabled = NO;
        
        if (self.blank.isImageAnimating) {
            CAAnimation *animation = self.blank.animation;
            if (animation) {
                [self.blankView.imageView.layer addAnimation:animation forKey:kBlankImageViewAnimationKey];
            }
        }else if ([self.blankView.imageView.layer animationForKey:kBlankImageViewAnimationKey]) {
            [self.blankView.imageView.layer removeAnimationForKey:kBlankImageViewAnimationKey];
        }
        
    }else if (self.isBlankVisible) {
        [self at_invalidate];
    }
}

- (void)at_invalidate {
    // Notifies that the empty dataset view will disappear
    
    if (self.blankView) {
        [self.blankView prepareForReuse];
        [self.blankView removeFromSuperview];
        
        [self setBlankView:nil];
    }
    
    self.scrollEnabled = YES;
    
    // Notifies that the empty dataset view did disappear
}

@end

