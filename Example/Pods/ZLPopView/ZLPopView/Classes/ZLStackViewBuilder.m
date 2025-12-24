//
//  ZLStackViewBuilder.m
//  GMPopView
//
//  Created by admin on 2025/4/22.
//

 #import "ZLStackViewBuilder.h"
#import "ZLBaseConfigure.h"
#import <objc/runtime.h>
#import "UIView+kfc.h"

#define kIgnoreViewTag 297812
id _recursive_objc_getAssociatedObject(id _Nonnull object, const void * _Nonnull key) {
    id obj = objc_getAssociatedObject(object, key);
    if (obj) return obj;
    Class superClass = class_getSuperclass(object);
    if (superClass) return _recursive_objc_getAssociatedObject(superClass, key);
    return nil;
}
static inline UIView* _getViewFromViewKFC(ViewKFCType viewKFC) {
    if (!viewKFC) return nil;
    if ([viewKFC isKindOfClass:ZLSeparatorView.class]) {
            ZLSeparatorView *separatorView = (ZLSeparatorView *)viewKFC;
        return separatorView.view ?: separatorView;
    }else if ([viewKFC isKindOfClass:UIView.class]) {
        return (UIView *)viewKFC;
    }else if ([viewKFC isKindOfClass:ZLBaseConfigure.class]) {
        ZLBaseConfigure *configure = (ZLBaseConfigure *)viewKFC;
        return configure.view;
    }
    return nil;
}
@interface ZLBaseConfigure()
@property (nonatomic,strong)ZLViewConfigObj *layoutInStackView;
@end

@interface UIView (GMConfig)
@property (nonatomic,assign)BOOL gm_layoutConfigObj;
@end
@implementation UIView(GMConfig)
- (void)setGm_layoutConfigObj:(BOOL)gm_layoutConfigObj {
    objc_setAssociatedObject(self, @selector(gm_layoutConfigObj), @(gm_layoutConfigObj), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)gm_layoutConfigObj {
    NSNumber *obj = objc_getAssociatedObject(self, @selector(gm_layoutConfigObj));
    return obj ? obj.boolValue : NO;
}
@end
@interface _GMSpacer : UIView

@end
@implementation _GMSpacer



@end
@interface ZLViewConfigObj()
@property (nonatomic,assign,readwrite)CGFloat alignmentMarge;
@property (nonatomic,assign,readwrite)ZLCrossAxisAlignment alignment;
@property (nonatomic,assign)BOOL didSetupConstraints;
@property (nonatomic,assign)BOOL needUpdateConstraints;
@property (nonatomic,weak,readwrite)UIView *view;
@property (nonatomic,weak)NSLayoutConstraint *startCons;
@property (nonatomic,weak)NSLayoutConstraint *endCons;
@property (nonatomic,weak)NSLayoutConstraint *centerCons;
@property (nonatomic,assign)CGFloat spacingValue;
@property (nonatomic,assign)CGFloat frontSpacingValue;
@end
@implementation ZLViewConfigObj
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frontSpacingValue = -1;
        self.spacingValue = -1;
    }
    return self;
}
- (ZLUIStackView *)stackView {
    UIView *stackView = self.view.superview;
    if ([stackView isKindOfClass:ZLUIStackView.class]) {
        return (ZLUIStackView *)stackView;
    }
    return nil;
}
- (void)setAlignment:(ZLCrossAxisAlignment)alignmentValue {
    if (_alignment != alignmentValue) {
        _alignment = alignmentValue;
        self.alignmentMarge = 0;
        self.needUpdateConstraints = YES;
        if (self.didSetupConstraints) [self.stackView refreshArrangedViewsLayout];
    }
}
- (void)setSpacingValue:(CGFloat)spacingValue {
    self.view.gm_layoutConfigObj = YES;
    if (_spacingValue != spacingValue) {
        _spacingValue = spacingValue;
        if (@available(iOS 11.0, *)) [self.stackView setCustomSpacing:MAX(spacingValue, 0) afterView:self.view];
    }
}
- (void)setFrontSpacingValue:(CGFloat)frontSpacingValue {
    self.view.gm_layoutConfigObj = YES;
    if (_frontSpacingValue != frontSpacingValue) {
        _frontSpacingValue = frontSpacingValue;
        ZLUIStackView *stackView = self.stackView;
        if (!stackView) return;
        ZLMainAxisAlignment mainAxisAlignment = stackView.mainAxisAlignment;
        if (mainAxisAlignment == ZLMainAxisAlignmentSpaceEvenly || mainAxisAlignment == ZLMainAxisAlignmentSpaceAround) {
        }else {
            if (@available(iOS 11.0, *)) {
                NSArray<UIView *> *views = self.stackView.arrangedSubviews;
                NSInteger index = [views indexOfObject:self.view];
                if (index != NSNotFound && index > 0) {
                    UIView *preView = views[index - 1];
                    [self.stackView setCustomSpacing:MAX(frontSpacingValue, 0) afterView:preView];
                }
            }
        }
    }
}
- (void)setAlignmentMarge:(CGFloat)alignmentMarge {
    if (_alignmentMarge != alignmentMarge) {
        _alignmentMarge = alignmentMarge;
       // self.view.gm_layoutConfigObj = YES;
        self.needUpdateConstraints = YES;
        if (self.didSetupConstraints) [self.stackView refreshArrangedViewsLayout];
    }
}
- (ZLViewConfigObj * _Nonnull (^)(CGFloat))spacing {
    return  ^ZLViewConfigObj*(CGFloat spacing){
        self.spacingValue = spacing;
        return self;
    };
}
- (ZLViewConfigObj* (^)(CGFloat ))frontSpaceing {
    return  ^ZLViewConfigObj*(CGFloat spacing){
        self.frontSpacingValue = spacing;
        return self;
    };
}
- (ZLViewConfigObj* (^)(ZLCrossAxisAlignment ))align {
    return  ^ZLViewConfigObj*(ZLCrossAxisAlignment alignment){
        self.alignment = alignment;
        return self;
    };
}
- (ZLViewConfigObj* )startAlignment {
    self.alignment = ZLCrossAxisAlignmentStart;
    return self;
}
- (ZLViewConfigObj* )endAlignment {
    self.alignment = ZLCrossAxisAlignmentEnd;
    return self;
}
- (ZLViewConfigObj* )centerAlignment{
    self.alignment = ZLCrossAxisAlignmentCenter;
    return self;
}
- (ZLViewConfigObj* )fillAlignment{
    self.alignment = ZLCrossAxisAlignmentFill;
    return self;
}
- (ZLViewConfigObj* (^)(CGFloat marge))startAlign {
    return  ^ZLViewConfigObj*(CGFloat marge){
        self.alignment = ZLCrossAxisAlignmentStart;
        self.alignmentMarge = marge;
        return self;
    };
}
- (ZLViewConfigObj* (^)(CGFloat marge))endAlign {
    return  ^ZLViewConfigObj*(CGFloat marge){
        self.alignment = ZLCrossAxisAlignmentEnd;
        self.alignmentMarge = marge;
        return self;
    };
}
- (ZLViewConfigObj* (^)(CGFloat offsetY))centerAlign {
    return  ^ZLViewConfigObj*(CGFloat offsetY){
        self.alignment = ZLCrossAxisAlignmentCenter;
        self.alignmentMarge = offsetY;
        return self;
    };
}

@end
@interface ZLUIScrollView()
@property (nonatomic, copy) void (^didMoveToSuperviewListener)(ZLUIScrollView *scrollView);
@property (nonatomic, copy) void (^layoutSubViewsListener)(ZLUIScrollView *scrollView);
@property (nonatomic, copy) BOOL (^layoutCallback)(ZLUIScrollView *stackView);
@end
@implementation ZLUIScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}
- (void)scrollToView:(UIView *)view atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
    if (!view || ![view isDescendantOfView:self]) return;
    CGRect rect = [self convertRect:view.bounds fromView:view];
    if (scrollPosition == UICollectionViewScrollPositionCenteredVertically) {
        CGFloat offsetY = rect.origin.y - (self.bounds.size.height - rect.size.height) / 2.0;
        offsetY = MAX(0, MIN(offsetY, self.contentSize.height - self.bounds.size.height));
        [self setContentOffset:CGPointMake(self.contentOffset.x, offsetY) animated:animated];
    }else if (scrollPosition == UICollectionViewScrollPositionCenteredHorizontally) {
        CGFloat offsetX = rect.origin.x - (self.bounds.size.width - rect.size.width) / 2.0;
        offsetX = MAX(0, MIN(offsetX, self.contentSize.width - self.bounds.size.width));
        [self setContentOffset:CGPointMake(offsetX, self.contentOffset.y) animated:animated];
    }else if (scrollPosition == UICollectionViewScrollPositionTop) {
        CGFloat offsetY = rect.origin.y;
        offsetY = MAX(0, MIN(offsetY, self.contentSize.height - self.bounds.size.height));
        [self setContentOffset:CGPointMake(self.contentOffset.x, offsetY) animated:animated];
    }else if (scrollPosition == UICollectionViewScrollPositionBottom) {
        CGFloat offsetY = rect.origin.y + rect.size.height - self.bounds.size.height;
        offsetY = MAX(0, MIN(offsetY, self.contentSize.height - self.bounds.size.height));
        [self setContentOffset:CGPointMake(self.contentOffset.x, offsetY) animated:animated];
    }else if (scrollPosition == UICollectionViewScrollPositionLeft) {
        CGFloat offsetX = rect.origin.x;
        offsetX = MAX(0, MIN(offsetX, self.contentSize.width - self.bounds.size.width));
        [self setContentOffset:CGPointMake(offsetX, self.contentOffset.y) animated:animated];
    }else if (scrollPosition == UICollectionViewScrollPositionRight) {
        CGFloat offsetX = rect.origin.x + rect.size.width - self.bounds.size.width;
        offsetX = MAX(0, MIN(offsetX, self.contentSize.width - self.bounds.size.width));
        [self setContentOffset:CGPointMake(offsetX, self.contentOffset.y) animated:animated];
    }
}
- (void)scrollToPage:(NSInteger)page atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
    if (page < 0) return;
    if (scrollPosition == UICollectionViewScrollPositionCenteredVertically || scrollPosition == UICollectionViewScrollPositionTop || scrollPosition == UICollectionViewScrollPositionBottom || scrollPosition == UICollectionViewScrollPositionCenteredVertically) {
        CGFloat offsetY = page * self.bounds.size.height;
        offsetY = MAX(0, MIN(offsetY, self.contentSize.height - self.bounds.size.height));
        [self setContentOffset:CGPointMake(self.contentOffset.x, offsetY) animated:animated];
    }else if (scrollPosition == UICollectionViewScrollPositionCenteredHorizontally || scrollPosition == UICollectionViewScrollPositionLeft || scrollPosition == UICollectionViewScrollPositionRight || scrollPosition == UICollectionViewScrollPositionCenteredHorizontally) {
        CGFloat offsetX = page * self.bounds.size.width;
        offsetX = MAX(0, MIN(offsetX, self.contentSize.width - self.bounds.size.width));
        [self setContentOffset:CGPointMake(offsetX, self.contentOffset.y) animated:animated];
    }
}
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.didMoveToSuperviewListener) self.didMoveToSuperviewListener(self);
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.superview) return;
    if (self.layoutSubViewsListener) self.layoutSubViewsListener(self);
    if (self.layoutCallback) {
        BOOL res = self.layoutCallback(self);
        if (res) self.layoutCallback = nil;
    }
}
@end
@interface ZLUIStackView()
@property (nonatomic, copy) void (^didMoveToSuperviewListener)(ZLUIStackView *stackView);
@property (nonatomic, copy) void (^layoutSubViewsListener)(ZLUIStackView *stackView);
@property (nonatomic, copy) BOOL (^layoutCallback)(ZLUIStackView *stackView);
@property (nonatomic,assign,readwrite)ZLMainAxisAlignment mainAxisAlignment;
@property (nonatomic,assign)BOOL needRefreshLayoutArrangedView;
@property (nonatomic,assign)BOOL didSetupConstraints;
@property (nonatomic,assign)BOOL adjustViewCrossLayout;
@property (nonatomic,strong,readwrite)ZLBuilderContext *context;

@end
@implementation ZLUIStackView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.needRefreshLayoutArrangedView = YES;
        if (@available(iOS 11.0, *)) self.insetsLayoutMarginsFromSafeArea = NO;
    }
    return self;
}
- (void)setAxis:(UILayoutConstraintAxis)axis {
    if (self.axis == axis) return;
    [super setAxis:axis];
    if (!self.superview) return;
    if (self.adjustViewCrossLayout) {
        NSArray<UIView *> *views = self.arrangedSubviews;
        [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removeArrangedSubview:obj];
            [obj removeFromSuperview];
        }];
        [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.kfc.layoutInStackView.needUpdateConstraints = YES;
            [self addArrangedSubview:obj];
        }];
        [self refreshArrangedViewsLayout];
    }
}
- (void)setLayoutMargins:(UIEdgeInsets)layoutMargins {
    if (UIEdgeInsetsEqualToEdgeInsets(self.layoutMargins, layoutMargins)) return;
    [super setLayoutMargins: layoutMargins];
    self.layoutMarginsRelativeArrangement = YES;
    if (!self.superview) return;
    if (self.adjustViewCrossLayout) {
        [self.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.kfc.layoutInStackView.needUpdateConstraints = YES;
        }];
        [self refreshArrangedViewsLayout];
    }
}
- (void)setSpacing:(CGFloat)spacing {
    if (self.mainAxisAlignment == ZLMainAxisAlignmentSpaceEvenly || self.mainAxisAlignment == ZLMainAxisAlignmentSpaceAround) {
        return [super setSpacing:0];
    }else {
        return [super setSpacing:spacing];
    }
}
- (CGFloat)spacing {
    if (self.mainAxisAlignment == ZLMainAxisAlignmentSpaceEvenly || self.mainAxisAlignment == ZLMainAxisAlignmentSpaceAround) {
        return 0;
    }else {
        return [super spacing];
    }
}
- (void)addArrangedSubview:(UIView *)view {
    if (!view || ![view isKindOfClass:UIView.class]) return;
    if (view.kfcCreated) view = view.kfc.margeView;
    [super addArrangedSubview:view];
    
    if (@available(iOS 11.0, *) ) {
        if (self.mainAxisAlignment == ZLMainAxisAlignmentSpaceEvenly || self.mainAxisAlignment == ZLMainAxisAlignmentSpaceAround) {
        }else {
            
            if (view.gm_layoutConfigObj) {
                CGFloat space = view.kfc.layoutInStackView.spacingValue;
                [super setCustomSpacing:MAX(space, 0) afterView:view];
                if (view.kfc.layoutInStackView.frontSpacingValue >= 0) {
                    NSArray<UIView *> *views = self.arrangedSubviews;
                    NSInteger index = [views indexOfObject:view];
                    if (index != NSNotFound && index > 0) {
                        UIView *preView = views[index - 1];
                        [super setCustomSpacing:MAX(view.kfc.layoutInStackView.frontSpacingValue, 0) afterView:preView];
                    }
                }
            }
        }
    }
}
- (void)insertArrangedSubview:(UIView *)view behindView:(UIView *)siblingSubview {
    NSInteger index = [self.arrangedSubviews indexOfObject:siblingSubview];
    if (index != NSNotFound) {
        [self insertArrangedSubview:view atIndex:index + 1];
    }
}
- (void)insertArrangedSubview:(UIView *)view frontView:(UIView *)siblingSubview {
    NSInteger index = [self.arrangedSubviews indexOfObject:siblingSubview];
    if (index != NSNotFound) {
        [self insertArrangedSubview:view atIndex:index];
    }
}

- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex {
    if (!view || ![view isKindOfClass:UIView.class]) return;
    if (view.kfcCreated) view = view.kfc.margeView;
    [super insertArrangedSubview:view atIndex:stackIndex];
    if (@available(iOS 11.0, *)) {
        if (self.mainAxisAlignment == ZLMainAxisAlignmentSpaceEvenly || self.mainAxisAlignment == ZLMainAxisAlignmentSpaceAround) {
        }else {
            if (view.gm_layoutConfigObj) {
                CGFloat space = view.kfc.layoutInStackView.spacingValue;
                [super setCustomSpacing:MAX(space, 0) afterView:view];
                if (view.kfc.layoutInStackView.frontSpacingValue >= 0) {
                    NSArray<UIView *> *views = self.arrangedSubviews;
                    NSInteger index = [views indexOfObject:view];
                    if (index != NSNotFound && index > 0) {
                        UIView *preView = views[index - 1];
                        [super setCustomSpacing:MAX(view.kfc.layoutInStackView.frontSpacingValue, 0) afterView:preView];
                    }
                }
            }
        }
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.didMoveToSuperviewListener) {
        if ([self.superview isKindOfClass:ZLUIScrollView.class]) {
            self.didMoveToSuperviewListener = nil;
        }else {
            self.didMoveToSuperviewListener(self);
        }
    }
}
- (void)removeArrangedSubviewWithTag:(NSInteger )tag {
    [self.arrangedSubviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == tag) {
            [self removeArrangedSubview:obj];
            [obj removeFromSuperview];
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.superview) return;
    if (!self.didSetupConstraints || (self.didSetupConstraints && self.needRefreshLayoutArrangedView)) {
        [self refreshArrangedViewsLayoutWithoutLayoutIfNeeded];
        self.needRefreshLayoutArrangedView = NO;
        self.didSetupConstraints = YES;
    }
    if (![self.superview isKindOfClass:ZLUIScrollView.class]) {
        if (self.layoutSubViewsListener) self.layoutSubViewsListener(self);
    }
    if (![self.superview isKindOfClass:ZLUIScrollView.class]) {
        if (self.layoutCallback) {
            BOOL res = self.layoutCallback(self);
            if (res) self.layoutCallback = nil;
        }
    }
}
- (void)refreshArrangedViewsLayout {
    [self layoutIfNeeded];
    [self refreshArrangedViewsLayoutWithoutLayoutIfNeeded];
}
- (void)sortArrangedSubviewsByTag {
    NSArray<UIView *> *views = self.arrangedSubviews;
    NSArray<UIView *> *sortedViews = [views sortedArrayUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
        if (obj1.tag < obj2.tag) {
            return NSOrderedAscending;
        } else if (obj1.tag > obj2.tag) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    [sortedViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeArrangedSubview:obj];
        [obj removeFromSuperview];
    }];
    
    [sortedViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addArrangedSubview:obj];
    }];
}
- (void)refreshArrangedViewsLayoutWithoutLayoutIfNeeded {
    __block BOOL adjustViewCrossLayout = NO;
    NSArray<UIView *> *views = self.arrangedSubviews;
    [views enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZLCrossAxisAlignment effectiveAlignment = obj.kfc.alignment;
        ZLCrossAxisAlignment alignment = obj.kfc.alignment;
        if (self.axis == UILayoutConstraintAxisHorizontal) {
            if (self.alignment == UIStackViewAlignmentTop && alignment == ZLCrossAxisAlignmentStart) effectiveAlignment = ZLCrossAxisAlignmentAuto;
            if (self.alignment == UIStackViewAlignmentBottom && alignment == ZLCrossAxisAlignmentEnd) effectiveAlignment = ZLCrossAxisAlignmentAuto;
            if (self.alignment == UIStackViewAlignmentCenter && alignment == ZLCrossAxisAlignmentCenter) effectiveAlignment = ZLCrossAxisAlignmentAuto;
            if (self.alignment == UIStackViewAlignmentFill && alignment == ZLCrossAxisAlignmentFill) effectiveAlignment = ZLCrossAxisAlignmentAuto;

        }else {
            if (self.alignment == UIStackViewAlignmentLeading && alignment == ZLCrossAxisAlignmentStart) effectiveAlignment = ZLCrossAxisAlignmentAuto;
            if (self.alignment == UIStackViewAlignmentTrailing && alignment == ZLCrossAxisAlignmentEnd) effectiveAlignment = ZLCrossAxisAlignmentAuto;
            if (self.alignment == UIStackViewAlignmentCenter && alignment == ZLCrossAxisAlignmentCenter) effectiveAlignment = ZLCrossAxisAlignmentAuto;
            if (self.alignment == UIStackViewAlignmentFill && alignment == ZLCrossAxisAlignmentFill) effectiveAlignment = ZLCrossAxisAlignmentAuto;
        }
        if (effectiveAlignment != ZLCrossAxisAlignmentAuto) {
            adjustViewCrossLayout = YES;
            *stop = YES;
        }
    }];
    self.adjustViewCrossLayout = adjustViewCrossLayout;
    if (!adjustViewCrossLayout) return;
    NSArray *attributes = NSMutableArray.array;
    if (self.axis == UILayoutConstraintAxisHorizontal) {
        if (self.alignment == UIStackViewAlignmentTop) {
           attributes = @[@(NSLayoutAttributeTop)];
       } else if (self.alignment == UIStackViewAlignmentBottom) {
           attributes = @[@(NSLayoutAttributeBottom)];
       }else if (self.alignment == UIStackViewAlignmentCenter) {
           attributes = @[@(NSLayoutAttributeCenterY)];
       }else if (self.alignment == UIStackViewAlignmentFill) {
           attributes = @[@(NSLayoutAttributeTop),@(NSLayoutAttributeBottom)];
       }
    }else {
        if (self.alignment == UIStackViewAlignmentLeading) {
            attributes = @[@(NSLayoutAttributeLeading)];
        }else if (self.alignment == UIStackViewAlignmentTrailing) {
            attributes = @[@(NSLayoutAttributeTrailing)];
        } else if (self.alignment == UIStackViewAlignmentCenter) {
            attributes = @[@(NSLayoutAttributeCenterX)];
        }else if (self.alignment == UIStackViewAlignmentFill) {
            attributes = @[@(NSLayoutAttributeLeading),@(NSLayoutAttributeTrailing)];
        }
    }
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag != kIgnoreViewTag) {
            ZLViewConfigObj *config = obj.kfc.layoutInStackView;
            if (!config.didSetupConstraints || (config.didSetupConstraints && config.needUpdateConstraints)) {
                NSArray *constranints = [self getConstraintsFromSuperview:obj attributes:attributes];
                [constranints enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
                    constraint.active = NO;
                }];
                config.startCons.active = NO;
                config.endCons.active = NO;
                config.centerCons.active = NO;
                [self refreshLayoutArrangedView:obj];
            }
        }
    }];
}

- (void)refreshLayoutArrangedView:(UIView *)view {
    if (view.kfc.alignment == ZLCrossAxisAlignmentAuto) {
        if (self.alignment == UIStackViewAlignmentFill) {
            [self addStartConstraint:view];
            [self addEndConstraint:view];
        }else if ( self.alignment == UIStackViewAlignmentLeading) {
            [self addStartConstraint:view];
        }else if ( self.alignment == UIStackViewAlignmentTrailing) {
            [self addEndConstraint:view];
        }else if ( self.alignment == UIStackViewAlignmentCenter) {
            [self addCenterConstraint:view];
        }else if ( self.alignment == UIStackViewAlignmentTop) {
            [self addStartConstraint:view];
        }else if ( self.alignment == UIStackViewAlignmentBottom) {
            [self addEndConstraint:view];
        }
    }else if (view.kfc.alignment == ZLCrossAxisAlignmentStart) {
        [self addStartConstraint:view];
        if (self.alignment == UIStackViewAlignmentFill) {
            [self addLessThenEndConstraint:view];
        }
    }else if (view.kfc.alignment == ZLCrossAxisAlignmentEnd) {
        [self addEndConstraint:view];
        if (self.alignment == UIStackViewAlignmentFill) {
            [self addGreaterThanStartConstraint:view];
        }
    }else if (view.kfc.alignment == ZLCrossAxisAlignmentCenter) {
        [self addCenterConstraint:view];
        if (self.alignment == UIStackViewAlignmentFill) {
            [self addGreaterThanStartConstraint:view];
            [self addLessThenEndConstraint:view];
        }
    }else if (view.kfc.alignment == ZLCrossAxisAlignmentFill) {
        [self addStartConstraint:view];
        [self addEndConstraint:view];
    }
}
- (void)addStartConstraint:(UIView *)v {
    UIEdgeInsets marge = self.layoutMargins;
    if (v.tag == 33) {
        NSLog(@"");
    }
    ZLViewConfigObj *config = v.kfc.layoutInStackView;
    //self.axis == UILayoutConstraintAxisHorizontal ? (config.startCons = [v.kfc topToView:v.superview offset:marge.top + config.alignmentMarge]) : (config.startCons = [v.kfc leadingToView:v.superview offset:marge.left + config.alignmentMarge]);
    self.axis == UILayoutConstraintAxisHorizontal ? (config.startCons = [v.topAnchor constraintEqualToAnchor:v.superview.layoutMarginsGuide.topAnchor constant:config.alignmentMarge].gm_enableActive) : (config.startCons = [v.leadingAnchor constraintEqualToAnchor:v.superview.layoutMarginsGuide.leadingAnchor constant:config.alignmentMarge].gm_enableActive);

    v.kfc.layoutInStackView.didSetupConstraints = YES;
    v.kfc.layoutInStackView.needUpdateConstraints = NO;
  
}
- (void)addEndConstraint:(UIView *)v {
    UIEdgeInsets marge = self.layoutMargins;
    ZLViewConfigObj *config = v.kfc.layoutInStackView;
    //self.axis == UILayoutConstraintAxisHorizontal ?  (config.endCons=[v.kfc bottomToView:v.superview offset:-marge.bottom - config.alignmentMarge]):(config.endCons=[v.kfc trailingToView:v.superview offset:-marge.right - config.alignmentMarge]);
    self.axis == UILayoutConstraintAxisHorizontal ?  (config.endCons=[v.bottomAnchor constraintEqualToAnchor:v.superview.layoutMarginsGuide.bottomAnchor constant:-config.alignmentMarge].gm_enableActive):(config.endCons=[v.trailingAnchor constraintEqualToAnchor:v.superview.layoutMarginsGuide.trailingAnchor constant:-config.alignmentMarge].gm_enableActive);

    v.kfc.layoutInStackView.didSetupConstraints = YES;
    v.kfc.layoutInStackView.needUpdateConstraints = NO;
   
}

- (void)addLessThenEndConstraint:(UIView *)v {
    UIEdgeInsets marge = self.layoutMargins;
    ZLViewConfigObj *config = v.kfc.layoutInStackView;
    if (self.axis == UILayoutConstraintAxisHorizontal) {
        config.endCons = [[v.bottomAnchor constraintLessThanOrEqualToAnchor:v.superview.layoutMarginsGuide.bottomAnchor constant:-config.alignmentMarge] gm_enableActive];
       // config.endCons = [v.kfc.view.bottomAnchor constraintLessThanOrEqualToAnchor:v.superview.bottomAnchor constant:-marge.bottom - config.alignmentMarge].gm_enableActive;
    }else {
        //config.endCons = [v.kfc.view.trailingAnchor constraintLessThanOrEqualToAnchor:v.superview.trailingAnchor constant:-marge.right - config.alignmentMarge].gm_enableActive;
        config.endCons = [v.trailingAnchor constraintLessThanOrEqualToAnchor:v.superview.layoutMarginsGuide.trailingAnchor constant:- config.alignmentMarge].gm_enableActive;

    }
}

- (void)addGreaterThanStartConstraint:(UIView *)v {
    UIEdgeInsets marge = self.layoutMargins;
    ZLViewConfigObj *config = v.kfc.layoutInStackView;
    if (self.axis == UILayoutConstraintAxisHorizontal) {
        //config.startCons = [v.kfc.view.topAnchor constraintGreaterThanOrEqualToAnchor:v.superview.topAnchor constant:marge.top + config.alignmentMarge].gm_enableActive;
        config.startCons = [v.topAnchor constraintGreaterThanOrEqualToAnchor:v.superview.layoutMarginsGuide.topAnchor constant:config.alignmentMarge].gm_enableActive;

    }else {
        //config.startCons = [v.kfc.view.leadingAnchor constraintGreaterThanOrEqualToAnchor:v.superview.leadingAnchor constant:marge.left + config.alignmentMarge].gm_enableActive;
        config.startCons = [v.leadingAnchor constraintGreaterThanOrEqualToAnchor:v.superview.layoutMarginsGuide.leadingAnchor constant:config.alignmentMarge].gm_enableActive;

    }
}

- (void)addCenterConstraint:(UIView *)v {
    ZLViewConfigObj *config = v.kfc.layoutInStackView;
    self.axis == UILayoutConstraintAxisHorizontal ?  (config.centerCons=[v.kfc centerYToView:v.superview offset:0]):(config.centerCons=[v.kfc centerXToView:v.superview offset:0]);
    v.kfc.layoutInStackView.didSetupConstraints = YES;
    v.kfc.layoutInStackView.needUpdateConstraints = NO;
}
-(NSArray<NSLayoutConstraint *> *)getConstraintsFromSuperview:(UIView *)view attributes:(NSArray<NSNumber *> *)attributes {
    UIView *superview = view.superview;
    if (!superview) return @[];
    NSMutableArray<NSLayoutConstraint *> *verticalConstraints = [NSMutableArray array];
    for (NSLayoutConstraint *constraint in superview.constraints) {
        BOOL isRelatedToView = ([constraint.firstItem isEqual:view] || [constraint.secondItem isEqual:view]);
        if (!isRelatedToView) continue;
        BOOL hasCons = NO;
        if ([attributes containsObject:@(constraint.firstAttribute)] ||
            [attributes containsObject:@(constraint.secondAttribute)]) {
            hasCons = YES;
        }
        if (hasCons) [verticalConstraints addObject:constraint];
    }
    return [verticalConstraints copy];
}
@end
@implementation ZLItemViewObj
- (instancetype)init
{
    self = [super init];
    self.customSpace = -1;
    return self;
}
@end
@interface ZLBaseStackViewBuilder()
@property (nonatomic,strong,readwrite)NSMutableArray<ZLItemViewObj*> *views;
@property (nonatomic,assign)CGFloat spaceValue;
@property(nonatomic) UILayoutConstraintAxis axis;
@property(nonatomic) UIStackViewDistribution innerDistribution;
@property(nonatomic) UIStackViewAlignment innerAlignment;
@property(nonatomic,weak) UIView *parentView;
@property (nonatomic,assign)BOOL isReverse;
@property (nonatomic,assign)ZLMainAxisAlignment mainAxisAlignment;
@property (nonatomic,assign)NSLayoutAttribute layoutAttribute;
@property (nonatomic) UIEdgeInsets layoutMargins;
@property (nonatomic,strong,readwrite)ZLBuilderContext *builderCtx;
@property (nonatomic, copy) void (^didMoveToSuperviewListener)(ZLBuilderContext *context);
@property (nonatomic, copy) BOOL (^layoutSubViewsListener)(ZLBuilderContext *context);

@property (nonatomic,copy)UIColor *_separatorColor;
@property (nonatomic,assign)CGFloat _separatorThickness;
@property (nonatomic,copy)UIColor *_spaceViewColor;
@property (nonatomic,assign)NSInteger colorThicknessPriority;
@property (nonatomic,strong)NSMutableArray<UIView *> *flexibleSpaceViews;
@end
@implementation ZLBaseStackViewBuilder
+ (UIColor *)defaultSeparatorColor {
    return _recursive_objc_getAssociatedObject(self, @selector(defaultSeparatorColor)) ? : ZLSeparatorView.defaultColor;
}
+ (void)setDefaultSeparatorColor:(UIColor *)defaultSeparatorColor {
    objc_setAssociatedObject(self, @selector(defaultSeparatorColor), defaultSeparatorColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)_separatorColor {
    return __separatorColor ? : self.class.defaultSeparatorColor;
}
+ (CGFloat)defaultSeparatorThickness {
    NSNumber *thickness = _recursive_objc_getAssociatedObject(self, @selector(defaultSeparatorThickness));
    return thickness ? thickness.floatValue : ZLSeparatorView.defaultThickness;
}
- (CGFloat)_separatorThickness {
    return __separatorThickness > 0 ? __separatorThickness : self.class.defaultSeparatorThickness;
}
+ (void)setDefaultSeparatorThickness:(CGFloat)defaultSeparatorThickness {
    objc_setAssociatedObject(self, @selector(defaultSeparatorThickness), @(defaultSeparatorThickness), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (instancetype)row {
    ZLBaseStackViewBuilder *builder = [[self alloc] init];
    builder.axis = UILayoutConstraintAxisHorizontal;
    return builder;
}
+ (instancetype)rowFillEqually {
    return [self row].distribution(ZLMainAxisAlignmentFillEqually);
}
+ (instancetype)column {
    ZLBaseStackViewBuilder * builder = [[self alloc] init];
    builder.axis = UILayoutConstraintAxisVertical;
    return builder;
}
+ (instancetype)columnFillEqually {
    return [self column].distribution(ZLMainAxisAlignmentFillEqually);
}
- (instancetype )init
{
    self = [super init];
    if (self) {
        self.builderCtx = ZLBuilderContext.new;
        self.innerAlignment = UIStackViewAlignmentCenter;
        self.mainAxisAlignment = ZLMainAxisAlignmentFill;
    }
    return self;
}
- (NSMutableArray<ZLItemViewObj *> *)views {
    if (!_views) _views = NSMutableArray.array;
    return _views;
}

- (NSLayoutAttribute)layoutAttribute {
    return self.axis == UILayoutConstraintAxisHorizontal ? NSLayoutAttributeWidth : NSLayoutAttributeHeight;
}
- (void)addObject:(ZLItemViewObj *)obj {
    [self.views addObject:obj];
}
- (id  _Nonnull (^)(void (^ _Nonnull)(__kindof ZLBaseStackViewBuilder * _Nonnull)))applyBuildBK {
    return ^id (void (^buildBK)(__kindof ZLBaseStackViewBuilder *builder)){
        if (buildBK) buildBK(self);
        return self;
    };
}
- (id (^)(ViewKFCType _Nullable view))addView {
    return  ^id (ViewKFCType _Nullable viewKFC){
        UIView *view = _getViewFromViewKFC(viewKFC);
        if (!view) return self;
        ZLItemViewObj *obj = ZLItemViewObj.new;
        obj.view = view;
        [self.builderCtx addView:view];
        self.currentViewObj = obj;
        [self addObject:obj];
        return self;
    };
}
- (id  _Nonnull (^)(ZLBaseStackViewBuilder * _Nullable))addViewBuilder {
    return ^id (ZLBaseStackViewBuilder* builder){
        if (!builder) return self;
        UIView *view = ((ZLBaseStackViewBuilder *)builder.context(self.builderCtx)).buildStackView;
        if (!view) return self;
        return self.addView(view);
    };
}
- (id  _Nonnull (^)(BOOL, ViewKFCType _Nullable view))addViewIf {
    return ^id (BOOL condition, ViewKFCType _Nullable view){
        if (!condition) return self;
        return self.addView(view);
    };
}

- (id  _Nonnull (^)(ViewKFCType _Nullable view, void (^ _Nonnull)(__kindof UIView * _Nonnull)))addViewWithTapBK {
    return ^id (ViewKFCType _Nullable viewKFC, void (^handler)(UIView *view)){
        UIView *view = _getViewFromViewKFC(viewKFC);
        if (!view) return self;
        if ([view isKindOfClass:UIButton.class]) {
            UIButton *btn = (UIButton *)view;
            btn.kfc.touchUpAction(handler);
        }else {
            view.kfc.tapAction(handler);
        }
        return self.addView(view);
    };
}
- (id  _Nonnull (^)(ViewKFCType _Nullable view, void (^ _Nonnull)(__kindof UIView * _Nonnull)))addViewWithConfigBK {
    return ^id (ViewKFCType _Nullable viewKFC, void (^handler)(UIView *view)){
        UIView *view = _getViewFromViewKFC(viewKFC);
        if (!view) return self;
        if (handler) handler(view);
        return self.addView(view);
    };
}
- (id (^)(ViewKFCType _Nullable view))addViewWBS {
    return  ^id(ViewKFCType _Nullable viewKFC){
        UIView *view = _getViewFromViewKFC(viewKFC);
        return self.addView(view.kfc.bottomSeparator.view);
    };
}
- (id (^)(ViewKFCType _Nullable view))addViewWTS {
    return  ^id(ViewKFCType _Nullable viewKFC){
        UIView *view = _getViewFromViewKFC(viewKFC);
        return self.addView(view.kfc.topSeparator.view);
    };
}
- (id (^)(ViewKFCType _Nullable view))addViewWLS {
    return  ^id(ViewKFCType _Nullable viewKFC){
        UIView *view = _getViewFromViewKFC(viewKFC);
        return self.addView(view.kfc.leadingSeparator.view);
    };
}
- (id (^)(ViewKFCType _Nullable view))addViewWRS {
    return  ^id(ViewKFCType _Nullable viewKFC){
        UIView *view = _getViewFromViewKFC(viewKFC);
        return self.addView(view.kfc.trailingSeparator.view);
    };
}
- (id (^)(NSArray<UIView *> *))addViews {
    return  ^id(NSArray<UIView * > * views){
        ZLItemViewObj *obj = ZLItemViewObj.new;
        obj.arrangedSubviews = [views copy];
        self.currentViewObj = obj;
        [self addObject:obj];
        return self;
    };
}
- (id (^)(NSArray<UIView *> *))addViewsWMS{
    return  ^id(NSArray<UIView * > * views){
        ZLItemViewObj *obj = ZLItemViewObj.new;
        obj.addMiddleSeparator = YES;
        obj.arrangedSubviews = [views copy];
        self.currentViewObj = obj;
        [self addObject:obj];
        return self;
    };
}
- (id (^)(NSArray<UIView *> *))addRowEWViews{
    return  ^id(NSArray<UIView * > * views){
        return views.count > 0 ? self.addView(ZLStackViewBuilder
                                    .rowFillEqually
                                    .context(self.builderCtx)
                                    .addViews(views)
                                    .buildStackView) : self;
    };
}
- (id  _Nonnull (^)(ZLMainAxisAlignment, NSArray<UIView *> * _Nonnull))addRowViews {
    return ^id (ZLMainAxisAlignment distribution, NSArray<UIView * > * views){
        return views.count > 0 ? self.addView(kStackViewRowBuilder
                                    .distribution(distribution)
                                    .context(self.builderCtx)
                                    .addViews(views)
                                    .buildStackView) : self;
    };
}
- (id (^)(NSArray<UIView *> *))addRowEWViewsWTS {
    return  ^id(NSArray<UIView * > * views){
        return views.count > 0 ?  self.addView(ZLStackViewBuilder
                                    .rowFillEqually
                                    .context(self.builderCtx)
                                    .addViews(views)
                                    .buildStackView.kfc
                                    .topSeparator
                                    .view) : self;
    };
}
- (id (^)(NSArray<UIView *> *))addRowEWViewsWBS {
    return  ^id(NSArray<UIView * > * views){
        return views.count > 0 ?  self.addView(ZLStackViewBuilder
                                    .rowFillEqually
                                    .context(self.builderCtx)
                                    .addViews(views)
                                    .buildStackView
                                    .kfc.bottomSeparator
                                    .view) : self;
    };
}
- (id (^)(NSArray<UIView *> *))addRowEWViewsWMS {
    return  ^id(NSArray<UIView * > * views){
        return views.count > 0 ? self.addView(ZLStackViewBuilder
                                    .rowFillEqually
                                    .context(self.builderCtx)
                                    .addViewsWMS(views)
                                    .buildStackView) : self;
    };
}
- (id (^)(NSArray<UIView *> *))addRowEWViewsWTMS {
    return  ^id(NSArray<UIView * > * views){
        return views.count > 0 ?  self.addViewWTS(ZLStackViewBuilder
                                    .rowFillEqually
                                    .context(self.builderCtx)
                                    .addViewsWMS(views)
                                    .buildStackView) : self;
    };
}

- (id (^)(NSArray<UIView *> *))addColumnEHViews{
    return  ^id(NSArray<UIView * > * views){
        return views.count > 0 ?  self.addView(ZLStackViewBuilder
                                    .columnFillEqually
                                    .alignmentFill
                                    .context(self.builderCtx)
                                    .addViews(views)
                                    .buildStackView) : self;
    };
}
- (id (^)(NSArray<UIView *> *))addColumnEHViewsWMS {
    return  ^id(NSArray<UIView * > * views){
        return views.count > 0 ?  self.addView(ZLStackViewBuilder
                                    .columnFillEqually
                                    .alignmentFill
                                    .context(self.builderCtx)
                                    .addViewsWMS(views)
                                    .buildStackView) : self;
    };
}
- (id (^)(NSArray<UIView *> *))addColumnEHViewsWTMS {
    return  ^id(NSArray<UIView * > * views){
        return views.count > 0 ? self.addViewWTS(ZLStackViewBuilder
                                    .columnFillEqually
                                    .alignmentFill
                                    .context(self.builderCtx)
                                    .addViewsWMS(views)
                                    .buildStackView) : self;
    };
}
- (id (^)(CGFloat))addSpaceView {
    return  ^id(CGFloat space){
        ZLItemViewObj *obj = ZLItemViewObj.new;
        obj.space = space;
        self.currentViewObj = obj;
        [self addObject:obj];
        return self;
    };
}
- (id (^)(id ))spaceViewColor {
    return ^id(id color){
        self._spaceViewColor = __UIColorFromObj(color);
        return self;
    };
}
- (id (^)(void))addFlexSpaceView {
    return  ^id(void){
        ZLItemViewObj *obj = ZLItemViewObj.new;
        obj.isSpacer = YES;
        self.currentViewObj = obj;
        [self addObject:obj];
        return self;
    };
}
- (id (^)(id))separatorColor {
    return  ^id(id color){
        self.colorThicknessPriority = 1;
        self._separatorColor = __UIColorFromObj(color);
        return self;
    };
}
- (id (^)(CGFloat ))separatorThickness {
    return  ^id(CGFloat thickness){
        self.colorThicknessPriority = 1;
        self._separatorThickness = thickness;
        return self;
    };
}
- (id  _Nonnull (^)(NSInteger))separatorColorThicknessPriority{
    return ^id(NSInteger priority){
        self._separatorThickness = MAX(self._separatorThickness, 0);
        self.colorThicknessPriority = priority;
        return self;
    };
}

- (id  _Nonnull (^)(ViewKFCType _Nonnull (^ _Nonnull)(void)))addViewBK {
    return ^id(ViewKFCType (^block)(void)){
        return self.addViewBKIf(YES, block);
    };
}

- (id  _Nonnull (^)(NSArray<UIView *> * _Nonnull (^ _Nonnull)(void)))addViewsBK{
    return ^id(NSArray<UIView *>*(^block)(void)){
        ZLItemViewObj *obj = ZLItemViewObj.new;
        obj.viewsBlock = [block copy];
        self.currentViewObj = obj;
        [self addObject:obj];
        return self;
    };
}
- (id  _Nonnull (^)(ViewKFCType _Nonnull (^ _Nonnull)(ZLBuilderContext * _Nonnull)))addViewWithCtxBK{
    return ^id(ViewKFCType (^block)(ZLBuilderContext *)){
        ZLItemViewObj *obj = ZLItemViewObj.new;
        obj.viewBlock1 = block;
        self.currentViewObj = obj;
        [self addObject:obj];
        return self;
    };
}
- (id  _Nonnull (^)(NSArray<UIView *> * _Nonnull (^ _Nonnull)(ZLBuilderContext * _Nonnull)))addViewsWithCtxBK {
    return ^id(NSArray<UIView *>*(^block)(ZLBuilderContext *)){
        ZLItemViewObj *obj = ZLItemViewObj.new;
        obj.viewsBlock1 = [block copy];
        self.currentViewObj = obj;
        [self addObject:obj];
        return self;
    };
}

- (id  _Nonnull (^)(BOOL, ViewKFCType _Nonnull (^ _Nonnull)(void)))addViewBKIf{
    return ^id(BOOL shouldAdd, ViewKFCType (^block)(void)){
        if (!shouldAdd) return self;
        ZLItemViewObj *obj = ZLItemViewObj.new;
        obj.viewBlock = block;
        self.currentViewObj = obj;
        [self addObject:obj];
        return self;
    };
}
//- (id (^)(UIView *))addSubview{
//    return  ^id(UIView* view){
//        ZLItemViewObj *obj = ZLItemViewObj.new;
//        obj.isAddSubView = YES;
//        obj.view = view;
//        [self.builderCtx addView:view];
//        self.currentViewObj = obj;
//        [self addObject:obj];
//        return self;
//    };
//}
//- (id  _Nonnull (^)(UIView * _Nonnull (^ _Nonnull)(void)))addSubviewBK {
//    return ^id(UIView* (^block)(void)){
//        ZLItemViewObj *obj = ZLItemViewObj.new;
//        obj.isAddSubView = YES;
//        obj.viewBlock = block;
//        self.currentViewObj = obj;
//        [self addObject:obj];
//        return self;
//    };
//}
//
//- (id  _Nonnull (^)(UIView * _Nonnull (^ _Nonnull)(ZLBuilderContext * _Nonnull)))addSubviewWithCtxBK{
//    return ^id(UIView* (^block)(ZLBuilderContext *)){
//        ZLItemViewObj *obj = ZLItemViewObj.new;
//        obj.isAddSubView = YES;
//        obj.viewBlock1 = block;
//        self.currentViewObj = obj;
//        [self addObject:obj];
//        return self;
//    };
//}
- (id  (^)(CGFloat))space {
    return  ^id(CGFloat space){
        self.spaceValue = space;
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))customSpace {
    return  ^id(CGFloat space){
        self.currentViewObj.customSpace = space;
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))padding {
    return  ^id(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing){
        self.layoutMargins = UIEdgeInsetsMake(top, leading, bottom, trailing);
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat, CGFloat))paddingHorLT {
    return  ^id(CGFloat horizontal, CGFloat vertical){
        self.layoutMargins = UIEdgeInsetsMake(self.layoutMargins.top, horizontal, self.layoutMargins.bottom, horizontal);
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat, CGFloat))paddingVerTB {
    return  ^id(CGFloat vertical, CGFloat horizontal){
        self.layoutMargins = UIEdgeInsetsMake(vertical, self.layoutMargins.left, vertical, self.layoutMargins.right);
        return self;
    };
}
- (id (^)(CGFloat ))paddingTop {
    return  ^id(CGFloat top){
        self.layoutMargins = UIEdgeInsetsMake(top, self.layoutMargins.left, self.layoutMargins.bottom, self.layoutMargins.right);
        return self;
    };
}   
- (id (^)(CGFloat ))paddingLeading {
    return  ^id(CGFloat leading){
        self.layoutMargins = UIEdgeInsetsMake(self.layoutMargins.top, leading, self.layoutMargins.bottom, self.layoutMargins.right);
        return self;
    };
}
- (id (^)(CGFloat ))paddingBottom {
    return  ^id(CGFloat bottom){
        self.layoutMargins = UIEdgeInsetsMake(self.layoutMargins.top, self.layoutMargins.left, bottom, self.layoutMargins.right);
        return self;
    };
}
- (id (^)(CGFloat ))paddingTrailing {
    return  ^id(CGFloat trailing){
        self.layoutMargins = UIEdgeInsetsMake(self.layoutMargins.top, self.layoutMargins.left, self.layoutMargins.bottom, trailing);
        return self;
    };
}

- (id  (^)(ZLMainAxisAlignment))distribution {
    return  ^id(ZLMainAxisAlignment mainAxisAlignment){
        self.mainAxisAlignment = mainAxisAlignment;
        if (mainAxisAlignment == ZLMainAxisAlignmentFillEqually) {
            self.innerDistribution = UIStackViewDistributionFillEqually;
        }else if (mainAxisAlignment == ZLMainAxisAlignmentFillProportionally){
            self.innerDistribution = UIStackViewDistributionFillProportionally;
        }else if (mainAxisAlignment == ZLMainAxisAlignmentEqualSpacing){
            self.innerDistribution = UIStackViewDistributionEqualSpacing;
        }else if (mainAxisAlignment == ZLMainAxisAlignmentEqualCentering){
            self.innerDistribution = UIStackViewDistributionEqualCentering;
        }else if (mainAxisAlignment == ZLMainAxisAlignmentFill){
            self.innerDistribution = UIStackViewDistributionFill;
        }else if (mainAxisAlignment == ZLMainAxisAlignmentSpaceEvenly){
            self.innerDistribution = UIStackViewDistributionEqualSpacing;
        }else if (mainAxisAlignment == ZLMainAxisAlignmentSpaceAround){
            self.innerDistribution = UIStackViewDistributionEqualSpacing;
        }
        return self;
    };
}
- (instancetype )distributionFillEqually {
    return self.distribution(ZLMainAxisAlignmentFillEqually);
}
- (instancetype )distributionEqualSpacing {
    return self.distribution(ZLMainAxisAlignmentEqualSpacing);
}
- (instancetype )distributionFill {
    return self.distribution(ZLMainAxisAlignmentFill);
}
- (instancetype )distributionFillProportionally {
    return self.distribution(ZLMainAxisAlignmentFillProportionally);
}
- (instancetype )distributionEqualCentering {
    return self.distribution(ZLMainAxisAlignmentEqualCentering);
}
- (instancetype )distributionStart {
    return self.distribution(ZLMainAxisAlignmentStart);
}
- (instancetype )distributionEnd {
    return self.distribution(ZLMainAxisAlignmentEnd);
}
- (instancetype )distributionCenter {
    return self.distribution(ZLMainAxisAlignmentCenter);
}
- (instancetype )distributionSpaceEvenly {
    return self.distribution(ZLMainAxisAlignmentSpaceEvenly);
}
- (instancetype )distributionSpaceAround {
    return self.distribution(ZLMainAxisAlignmentSpaceAround);
}
- (id (^)(BOOL isReverse))reverse {
    return  ^id(BOOL isReverse){
        self.isReverse = isReverse;
        return self;
    };
}
- (id (^)(ZLBuilderContext *context))context {
    return  ^id(ZLBuilderContext *context){
        if (!context) return self;
        [self.builderCtx.allViews.allObjects enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [context  addView:obj];
        }];
        self.builderCtx = context;
        return self;
    };
}
- (id  (^)(UIStackViewAlignment))alignment{
    return  ^id(UIStackViewAlignment alignment){
        self.innerAlignment = alignment;
        return self;
    };
}
- (instancetype)alignmentFill {
    return self.alignment(UIStackViewAlignmentFill);
}
- (instancetype)alignmentStart {
    return self.alignment(UIStackViewAlignmentLeading);
}
- (instancetype)alignmentEnd{
    return self.alignment(UIStackViewAlignmentTrailing);
}
- (instancetype)alignmentCenter {
    return self.alignment(UIStackViewAlignmentCenter);
}

- (id (^)(UIView *))superView {
    return  ^id(UIView *superView){
        self.parentView = superView;
        return self;
    };
}
- (void)addArrangedSubviewFromArray:(NSArray<UIView *> *)views stackView:(ZLUIStackView *)stackView {
    if ([views isKindOfClass:NSArray.class]) {
        [views enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([view isKindOfClass:UIView.class]) {
                [stackView addArrangedSubview:view];
                [self.builderCtx addView:view];
            }
        }];
    }
}
- (void)addArrangedSubviewFromArray:(NSArray<UIView *> *)views stackView:(ZLUIStackView *)stackView addMiddleSeparator:(BOOL)addMiddleSeparator {
    if ([views isKindOfClass:NSArray.class]) {
        [views enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([view isKindOfClass:UIView.class]) {
                [stackView addArrangedSubview:view];
                [self.builderCtx addView:view];
            }
            if (idx != views.count - 1 && addMiddleSeparator) {
                if (self.axis == UILayoutConstraintAxisHorizontal) {
                    [view.kfc trailingSeparator];
                }else {
                    [view.kfc bottomSeparator];
                }
            }
        }];
    }
}
- (void)traverseAllSubviewsWithView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:ZLSeparatorView.class]) {
            ZLSeparatorView *sepView = (ZLSeparatorView *)subview;
            if (self.colorThicknessPriority < sepView.colorThicknessPriority) continue;
            sepView.colorThicknessPriority = self.colorThicknessPriority;
            if (self._separatorColor) sepView.backgroundColor = self._separatorColor;
            if (self._separatorThickness > 0) {
                if (sepView.isHorizontal) {
                    sepView.heightCons.constant = self._separatorThickness;
                }else {
                    sepView.widthCons.constant = self._separatorThickness;
                }
            }
        }
        [self traverseAllSubviewsWithView:subview];
    }
}
- (ZLUIStackView *)buildStackView {
    ZLUIStackView *stackView = [[ZLUIStackView alloc] init];
    stackView.context = self.builderCtx;
    stackView.mainAxisAlignment = self.mainAxisAlignment;
    self.builderCtx.stackView = stackView;
    if (self.didMoveToSuperviewListener) {
        __block ZLBuilderContext *context = self.builderCtx;
        __block void (^didMoveToSuperviewListener)(ZLBuilderContext *context) = self.didMoveToSuperviewListener;
        stackView.didMoveToSuperviewListener = ^(ZLUIStackView *stackView) {
            if (didMoveToSuperviewListener) {
                didMoveToSuperviewListener(context);
                context = nil;
                didMoveToSuperviewListener = nil;
            }
        };
    }
    if (self.layoutSubViewsListener) {
        __block ZLBuilderContext *context = self.builderCtx;
        __block BOOL (^layoutSubViewsListener)(ZLBuilderContext *context) = self.layoutSubViewsListener;
        stackView.layoutSubViewsListener = ^(ZLUIStackView *stackView) {
            if (layoutSubViewsListener) {
                if (layoutSubViewsListener(context)) {
                    context = nil;
                    layoutSubViewsListener = nil;
                }
            }
        };
    }
    stackView.axis = self.axis;
    stackView.spacing = self.spaceValue;
    stackView.alignment = self.innerAlignment;
    stackView.distribution = self.innerDistribution;
    if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero,self.layoutMargins)){
            stackView.layoutMargins = self.layoutMargins;
            stackView.layoutMarginsRelativeArrangement = YES;
    }
    [self.views enumerateObjectsWithOptions:self.isReverse ? NSEnumerationReverse : 0 usingBlock:^(ZLItemViewObj * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.arrangedSubviews isKindOfClass:NSArray.class] && obj.arrangedSubviews.count > 0) {
            [self adjustCustomSpacingWithView:obj.arrangedSubviews.lastObject spacing:obj.customSpace];
            [self addArrangedSubviewFromArray:obj.arrangedSubviews stackView:stackView addMiddleSeparator:obj.addMiddleSeparator];
        }else if (obj.viewsBlock) {
            NSArray<UIView *> *views = obj.viewsBlock();
            [self adjustCustomSpacingWithView:views.lastObject spacing:obj.customSpace];
            [self addArrangedSubviewFromArray:views stackView:stackView addMiddleSeparator:obj.addMiddleSeparator];
        }else if (obj.viewsBlock1) {
            NSArray<UIView *> *views = obj.viewsBlock1(self.builderCtx);
            [self adjustCustomSpacingWithView:views.lastObject spacing:obj.customSpace];
            [self addArrangedSubviewFromArray:views stackView:stackView addMiddleSeparator:obj.addMiddleSeparator];
        } else {
            UIView *view = [self addArrangedSubviewWithObj:obj stackView:stackView];
           [self adjustCustomSpacingWithView:view spacing:obj.customSpace];
            if ([view isKindOfClass:UIView.class]) {
                if (obj.isAddSubView) {
                    [stackView addSubview:view];
                }else {
                    [stackView addArrangedSubview:view];
                }
                if (![self.builderCtx.allViews containsObject:view]) {
                    [self.builderCtx addView:view];
                }
            }
            
        }
    }];
    UIView* (^blankViewBlock)(void) = ^{
        if (self.axis == UILayoutConstraintAxisHorizontal) {
            return UIView.kfc.userInteractionEnabled(NO).width(0.01).tag(kIgnoreViewTag).view;
        }else {
            return UIView.kfc.userInteractionEnabled(NO).height(0.01).tag(kIgnoreViewTag).view;
        }
    };
    if (self.mainAxisAlignment == ZLMainAxisAlignmentSpaceEvenly && stackView.arrangedSubviews.count > 1) {
        [stackView insertArrangedSubview:blankViewBlock() atIndex:0];
        [stackView addArrangedSubview:blankViewBlock()];
//        [stackView layoutIfNeeded];
    }

    if (self.mainAxisAlignment == ZLMainAxisAlignmentSpaceAround && stackView.arrangedSubviews.count > 1) {
        NSArray *views = stackView.arrangedSubviews;
        [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger index = [stackView.arrangedSubviews indexOfObject:obj];
            if (index != NSNotFound) {
                [stackView insertArrangedSubview:blankViewBlock() atIndex:index+1];
            }
        }];
        [stackView insertArrangedSubview:blankViewBlock() atIndex:0];
//        [stackView layoutIfNeeded];
    }
    
    if (self.mainAxisAlignment == ZLMainAxisAlignmentStart) {
        UIView *spacer = [self createSpacer];
        [stackView addArrangedSubview:spacer];
    }
    if (self.mainAxisAlignment == ZLMainAxisAlignmentEnd) {
        UIView *spacer = [self createSpacer];
        [stackView insertArrangedSubview:spacer atIndex:0];
    }
    if (self.mainAxisAlignment == ZLMainAxisAlignmentCenter) {
        UIView *spacer1 = [self createSpacer];
        UIView *spacer2 = [self createSpacer];
        [stackView insertArrangedSubview:spacer1 atIndex:0];
        [stackView addArrangedSubview:spacer2];
        [NSLayoutConstraint constraintWithItem:spacer1
                                    attribute:self.layoutAttribute
                                    relatedBy:NSLayoutRelationEqual
                                        toItem:spacer2
                                    attribute:self.layoutAttribute
                                   multiplier:1
                                     constant:0].active = YES;
    }
    [self.views removeAllObjects];
    self.views = nil;
    if (self._separatorColor || self._separatorThickness > 0) {
        [self traverseAllSubviewsWithView:stackView];
    }
    
    if (self.flexibleSpaceViews && self.flexibleSpaceViews.count > 1) {
        ///设置flexibleSpaceViews里面的view等宽或等高
        UIView *firstView = self.flexibleSpaceViews.firstObject;
        [self.flexibleSpaceViews enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
            if (view != firstView) {
                [NSLayoutConstraint constraintWithItem:firstView
                                             attribute:self.layoutAttribute
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:view
                                             attribute:self.layoutAttribute
                                            multiplier:1
                                              constant:0].active = YES;
            }
        }];
        [self.flexibleSpaceViews removeAllObjects];
        self.flexibleSpaceViews = nil;
    }
    
    return stackView;
}
- (void)adjustCustomSpacingWithView:(UIView *)view spacing:(CGFloat)spacing {
    if (spacing > 0) {
        view.kfc.spacing(spacing);
    }
}
- (UIView *)createSpacer {
    UIView *view = [[_GMSpacer alloc] init];
    view.tag = kIgnoreViewTag;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    if (self.axis == UILayoutConstraintAxisHorizontal) {
        [view setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [view setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }else {
        [view setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [view setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    }
    return view;
}
- (UIView *)addArrangedSubviewWithObj:(ZLItemViewObj *)viewObj stackView:(UIStackView *)stackView{
    UIView *view;
    if (viewObj.view) {
        view = viewObj.view;
    }else if (viewObj.viewBlock) {
        view = _getViewFromViewKFC(viewObj.viewBlock());
    }else if (viewObj.viewBlock1) {
        view = _getViewFromViewKFC(viewObj.viewBlock1(self.builderCtx));
    }else if (viewObj.space > 0 &&
              self.mainAxisAlignment != ZLMainAxisAlignmentFillEqually &&
              self.mainAxisAlignment != ZLMainAxisAlignmentEqualSpacing &&
              self.mainAxisAlignment != ZLMainAxisAlignmentEqualCentering &&
              self.mainAxisAlignment != ZLMainAxisAlignmentFillProportionally
              ) {
        view = [[UIView alloc] init];
        view.tag = kIgnoreViewTag;
        view.backgroundColor = self._spaceViewColor;
        if (self.axis == UILayoutConstraintAxisHorizontal) {
            [view.kfc setViewWidth:viewObj.space];
        }else {
            [view.kfc setViewHeight:viewObj.space];
        }
    }else if (viewObj.isSpacer && self.mainAxisAlignment == ZLMainAxisAlignmentFill) {
        view = [self createSpacer];
        if (self.flexibleSpaceViews == nil) {
            self.flexibleSpaceViews = NSMutableArray.array;
        }
        view.kfc.frontSpacing(0).spacing(0);
        [self.flexibleSpaceViews addObject:view];
    }
    if (view && ![view isKindOfClass:UIView.class]) {
    #if DEBUG
         NSAssert(NO, @"ZLStackViewBuilder Error: The arrangedSubview must be a kind of UIView.");
    #endif
    }
    return view;
}
- (ZLUIScrollView *)buildScrollView {
    ZLUIScrollView *scrollView = ZLUIScrollView.new;
    self.builderCtx.scrollView = scrollView;
    if (self.layoutSubViewsListener) {
        __block BOOL (^layoutSubViewsListener)(ZLBuilderContext *context) = self.layoutSubViewsListener;
        __block ZLBuilderContext *context = self.builderCtx;
        scrollView.layoutSubViewsListener = ^(ZLUIScrollView *scrollView) {
            if (layoutSubViewsListener) {
                if (layoutSubViewsListener(context)) {
                    layoutSubViewsListener = nil;
                    context = nil;
                }
            }
        };
    }
    if (self.didMoveToSuperviewListener) {
        __block void (^didMoveToSuperviewListener)(ZLBuilderContext *context) = self.didMoveToSuperviewListener;
        __block ZLBuilderContext *context = self.builderCtx;
        scrollView.didMoveToSuperviewListener = ^(ZLUIScrollView *scrollView) {
            if (didMoveToSuperviewListener) {
                didMoveToSuperviewListener(context);
                didMoveToSuperviewListener = nil;
                context = nil;
            }
        };
    }
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
    }
    UIStackView *stackView = [self buildStackView];
    stackView.tag = kZLUIStackViewTag;
    [scrollView addSubview:stackView];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *axisLayout;
    if (self.axis == UILayoutConstraintAxisHorizontal) {
        axisLayout =  [stackView.heightAnchor constraintEqualToAnchor:scrollView.heightAnchor];
        //（1）scrollView 的宽度 = stackView 宽度（低优先级）
        NSLayoutConstraint *equalHeight =
        [scrollView.widthAnchor constraintEqualToAnchor:stackView.widthAnchor];
        equalHeight.priority = UILayoutPriorityDefaultLow;   // 低优先级
        equalHeight.active = YES;
    }else {
        axisLayout =  [stackView.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor];
        //（1）scrollView 的高度 = stackView 高度（低优先级）
        NSLayoutConstraint *equalHeight =
            [scrollView.heightAnchor constraintEqualToAnchor:stackView.heightAnchor];
        equalHeight.priority = UILayoutPriorityDefaultLow;   // 低优先级
        equalHeight.active = YES;
    }
    axisLayout.active = YES;
    [NSLayoutConstraint activateConstraints:[stackView.kfc edgeToView:scrollView edge:UIEdgeInsetsZero]];
    return scrollView;
}
- (void (^)(UIView * _Nonnull, BOOL (^ _Nonnull)(ZLUIStackView * _Nonnull)))buildStackViewToSuperViewLayoutBK {
    return ^void(UIView *superView, BOOL (^callback)(ZLUIStackView *)){
        if ([superView isKindOfClass:UIView.class]) {
            ZLUIStackView *stackView = [self buildStackView];
            stackView.layoutCallback = callback;
            [superView addSubview:stackView];
            [stackView.kfc edgeToView:superView edge:UIEdgeInsetsZero];
        }
    };
}
- (void (^)(UIView * _Nonnull, BOOL (^ _Nonnull)(ZLUIScrollView * _Nonnull)))buildScrollViewToSuperViewLayoutBK {
    return ^void(UIView *superView, BOOL (^callback)(ZLUIScrollView *)){
        if ([superView isKindOfClass:UIView.class]) {
            ZLUIScrollView *scrollView = [self buildScrollView];
            scrollView.layoutCallback = callback;
            [superView addSubview:scrollView];
            [scrollView.kfc edgeToView:superView edge:UIEdgeInsetsZero];
        }
    };
}

- (void (^)(UIView * _Nonnull))buildStackViewToSuperView {
    return ^(UIView *superView){
        if ([superView isKindOfClass:UIView.class]){
            ZLUIStackView *stackView = [self buildStackView];
            [superView addSubview:stackView];
            [stackView.kfc edgeToView:superView edge:UIEdgeInsetsZero];
        }
    };
}
- (void (^)(UIView * _Nonnull))buildScrollViewToSuperView {
    return ^(UIView *superView){
        if ([superView isKindOfClass:UIView.class]){
            ZLUIScrollView *scrollView = [self buildScrollView];
            [superView addSubview:scrollView];
            [scrollView.kfc edgeToView:superView edge:UIEdgeInsetsZero];
        }
    };
}
- (id  _Nonnull (^)(void (^ _Nonnull)(ZLBuilderContext * _Nonnull)))didMoveTopSuperViewListenerBK {
    return ^id(void (^listener)(ZLBuilderContext *)){
        self.didMoveToSuperviewListener = listener;
        return self;
    };
}

- (ZLUIStackView * _Nonnull (^)(UIView * _Nonnull, CGFloat, CGFloat, CGFloat, CGFloat))buildStackViewToSuperViewInsets {
    return ^ ZLUIStackView* (UIView *superView,CGFloat top, CGFloat left, CGFloat bottom, CGFloat right){
        ZLUIStackView *stackView = [self buildStackView];
        if ([superView isKindOfClass:UIView.class]) {
            [superView addSubview:stackView];
            [stackView.kfc edgeToView:superView edge:UIEdgeInsetsMake(top, left, -bottom, -right)];
            return stackView;
        }
        return stackView;
    };
}
- (ZLUIScrollView * _Nonnull (^)(UIView * _Nonnull, CGFloat, CGFloat, CGFloat, CGFloat))buildScrollViewToSuperViewInsets {
    return ^ZLUIScrollView* (UIView *superView,CGFloat top, CGFloat left, CGFloat bottom, CGFloat right){
        ZLUIScrollView *scrollView = [self buildScrollView];
        if ([superView isKindOfClass:UIView.class]) {
            [superView addSubview:scrollView];
            [scrollView.kfc edgeToView:superView edge:UIEdgeInsetsMake(top, left, -bottom, -right)];
            return scrollView;
        }
        return scrollView;
    };
}

- (id  _Nonnull (^)(BOOL (^ _Nonnull)(ZLBuilderContext * _Nonnull)))layoutSubviewsListenerBK {
    return ^id(BOOL (^listener)(ZLBuilderContext *)){
        self.layoutSubViewsListener = listener;
        return self;
    };
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"dealloc -- %@",self);
#else
#endif
}
@end


@implementation ZLStackViewBuilder
@dynamic applyBuildBK;

@end
