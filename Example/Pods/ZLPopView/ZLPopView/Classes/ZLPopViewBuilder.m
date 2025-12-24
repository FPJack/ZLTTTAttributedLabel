//
//  ZLPopViewBuilder.m
//  GMPopView
//
//  Created by admin on 2025/4/24.
//

#import "ZLPopViewBuilder.h"
#import <objc/runtime.h>
#import <ZLPopView/ZLBaseConfigure.h>
#import "UIView+kfc.h"
#import <ZLPopView/ZLStackViewBuilder.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

static GMConfigureBlock configureBlock;
@interface ZLPopBaseView()
@property (nonatomic,strong)_ZLView *containerView;
@property (nonatomic,strong)UIView *buildView;
@end
@interface ZLBaseStackViewBuilder()
@property (nonatomic,strong)NSMutableArray<ZLItemViewObj*> *views;
- (void)addObject:(ZLItemViewObj *)obj;
@end
@interface ZLPopViewBuilder()
@property (nonatomic,strong)ZLBuildConfigObj *configObj;
@property (nonatomic,weak)UIView *lastLabelView;
@property (nonatomic,strong)NSMutableArray *customActionViews;
@property (nonatomic,assign)int alertType; //1:alert 2:actionSheet
@property (nonatomic,strong)UIView *cancelView;
@property (nonatomic,assign)NSInteger cancelViewIdx;
@property (nonatomic,assign)BOOL dismissWhenTapActionView;
@property (nonatomic,strong)id actionViewsBlock;


- (void)handlerCustomActionView;
@end
@implementation ZLPopViewBuilder
@dynamic buildStackViewToSuperViewLayoutBK;
@dynamic buildScrollViewToSuperViewLayoutBK;
@dynamic buildStackViewToSuperView;
@dynamic buildScrollViewToSuperView;
@dynamic buildStackViewToSuperViewInsets;
@dynamic buildScrollViewToSuperViewInsets;
@dynamic applyBuildBK;

- (NSMutableArray *)customActionViews {
    if (!_customActionViews) {
        _customActionViews = NSMutableArray.array;
    }
    return _customActionViews;
}
+ (void)setDefaultConfigureBK:(GMConfigureBlock)defaultConfigure {
    configureBlock = defaultConfigure;
    objc_setAssociatedObject(self, @selector(defaultConfigureBK), configureBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+ (GMConfigureBlock)defaultConfigureBK {
    return _recursive_objc_getAssociatedObject(self, @selector(defaultConfigureBK));
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        ZLBuildConfigObj* obj = ZLBuildConfigObj.new;
        self.configObj = obj;
        self.alignment(UIStackViewAlignmentFill);
        obj.touchPenetrate = NO;
        obj.horizontalLayout = ZLHorizontalLayoutConstraintNone;
        self.dismissWhenTapActionView = YES;
        if (self.class.defaultConfigureBK) self.class.defaultConfigureBK(obj);
    }
    return self;
}

- (void)addObject:(ZLItemViewObj *)obj {
    [super addObject:obj];
    if (!obj.isAddSubView) self.lastLabelView = nil;
}
- (ZLUIStackView *)buildStackView {
    if ([self respondsToSelector:@selector(handlerCustomActionView)]) {
        [self handlerCustomActionView];
    }
    return [super buildStackView];
}

- (ZLPopViewBuilder* (^)(id ))backgroundColor {
    return  ^ZLPopViewBuilder*(id color){
        self.configObj.backgroundColor = __UIColorFromObj(color);
        return self;
    };
}
- (ZLPopViewBuilder * _Nonnull (^)(NSArray* _Nonnull))bgGradientColors {
    return ^ZLPopViewBuilder* (NSArray * colors){
        self.configObj.bgGradientColors = colors;
        return self;
    };
}
- (ZLPopViewBuilder * _Nonnull (^)(id _Nonnull))bgImage {
    return ^ZLPopViewBuilder* (id image){
        self.configObj.bgImage = image;
        return self;
    };
}
- (ZLPopViewBuilder * _Nonnull (^)(UIViewContentMode))bgImgageContentMode {
    return ^ZLPopViewBuilder* (UIViewContentMode mode){
        self.configObj.bgImgageContentMode = mode;
        return self;
    };
    
}
- (ZLPopViewBuilder * _Nonnull (^)(BOOL))reserveSafeAreaBottom {
    return ^ZLPopViewBuilder* (BOOL reserve){
        self.configObj.reserveSafeAreaBottom = reserve;
        return self;
    };
}
- (instancetype)reserveSafeAreaBottomYes {
    self.configObj.reserveSafeAreaBottom = YES;
    return self;
}
- (ZLPopViewBuilder* (^)(id ))maskColor {
    return  ^ZLPopViewBuilder*(id color){
        self.configObj.maskColor = __UIColorFromObj(color);
        return self;
    };
}
- (ZLPopViewBuilder * _Nonnull (^)(ZLAnimationBlock _Nonnull))animationInBK {
    return ^ZLPopViewBuilder* (ZLAnimationBlock animationIn){
        self.configObj.animationInBlock = animationIn;
        return self;
    };
}
- (ZLPopViewBuilder * _Nonnull (^)(ZLAnimationBlock _Nonnull))animationOutBK {
    return ^ZLPopViewBuilder* (ZLAnimationBlock animationOut){
        self.configObj.animationOutBlock = animationOut;
        return self;
    };
}

- (ZLPopViewBuilder* (^)(UIRectCorner))corners {
    return  ^ZLPopViewBuilder*(UIRectCorner corners){
        self.configObj.corners = corners;
        return self;
    };
}

- (ZLPopViewBuilder * _Nonnull (^)(CGFloat))topCorners {
    return ^ZLPopViewBuilder*(CGFloat radius){
        self.configObj.corners = UIRectCornerTopLeft | UIRectCornerTopRight;
        self.configObj.cornerRadius = radius;
        return self;
    };
}

- (ZLPopViewBuilder * _Nonnull (^)(CGFloat))bottomCorners {
    return ^ZLPopViewBuilder*(CGFloat radius){
        self.configObj.corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        self.configObj.cornerRadius = radius;
        return self;
    };
}
- (instancetype)allCorners {
    self.configObj.corners = UIRectCornerAllCorners;
    return self;
}
//- (ZLPopViewBuilder* (^)(UIEdgeInsets))popViewMarge{
//    return  ^ZLPopViewBuilder*(UIEdgeInsets inset){
//        self.configObj.popViewMarge = inset;
//        return self;
//    };
//}
- (ZLPopViewBuilder * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))popViewMarge {
    return  ^ZLPopViewBuilder*(CGFloat top,CGFloat left,CGFloat bottom,CGFloat right){
        self.configObj.popViewMarge = UIEdgeInsetsMake(top, left, bottom, right);
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))popViewMargeTop {
    return  ^ZLPopViewBuilder*(CGFloat top){
        self.configObj.popViewMarge = UIEdgeInsetsMake(top, self.configObj.popViewMarge.left, self.configObj.popViewMarge.bottom, self.configObj.popViewMarge.right);
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))popViewMargeLeading {
    return  ^ZLPopViewBuilder*(CGFloat left){
        self.configObj.popViewMarge = UIEdgeInsetsMake(self.configObj.popViewMarge.top, left, self.configObj.popViewMarge.bottom, self.configObj.popViewMarge.right);
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))popViewMargeBottom {
    return  ^ZLPopViewBuilder*(CGFloat bottom){
        self.configObj.popViewMarge = UIEdgeInsetsMake(self.configObj.popViewMarge.top, self.configObj.popViewMarge.left, bottom, self.configObj.popViewMarge.right);
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))popViewMargeTrailing {
    return  ^ZLPopViewBuilder*(CGFloat right){
        self.configObj.popViewMarge = UIEdgeInsetsMake(self.configObj.popViewMarge.top, self.configObj.popViewMarge.left, self.configObj.popViewMarge.bottom, right);
        return self;
    };
}
- (ZLPopViewBuilder * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))marge {
    return  ^ZLPopViewBuilder*(CGFloat top,CGFloat left,CGFloat bottom,CGFloat right){
        self.configObj.marge = UIEdgeInsetsMake(top, left, bottom, right);
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))margeAll {
    return  ^ZLPopViewBuilder*(CGFloat m){
        return self.marge(m, m, m, m);
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))margeTop {
    return  ^ZLPopViewBuilder*(CGFloat top){
        self.configObj.marge = UIEdgeInsetsMake(top, self.configObj.marge.left, -self.configObj.marge.bottom, -self.configObj.marge.right);
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))margeLeading {
    return  ^ZLPopViewBuilder*(CGFloat left){
        self.configObj.marge = UIEdgeInsetsMake(self.configObj.marge.top, left, -self.configObj.marge.bottom, -self.configObj.marge.right);
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))margeBottom {
    return  ^ZLPopViewBuilder*(CGFloat bottom){
        self.configObj.marge = UIEdgeInsetsMake(self.configObj.marge.top, self.configObj.marge.left, bottom, -self.configObj.marge.right);
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))margeTrailing {
    return  ^ZLPopViewBuilder*(CGFloat right){
        self.configObj.marge = UIEdgeInsetsMake(self.configObj.marge.top, self.configObj.marge.left, -self.configObj.marge.bottom, right);
        return self;
    };
}

- (ZLPopViewBuilder* (^)(CGFloat,CGFloat))margeHorizontal{
    return  ^ZLPopViewBuilder*(CGFloat leading,CGFloat trailing){
        return self.margeLeading(leading).margeTrailing(trailing);
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))maxWidth {
    return  ^ZLPopViewBuilder*(CGFloat maxWidth){
        self.configObj.maxWidth = maxWidth;
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))widthMultiplier {
    return  ^ZLPopViewBuilder*(CGFloat multiplier){
        self.configObj.widthMultiplier = multiplier;
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))maxWidthMultiplier {
    return  ^ZLPopViewBuilder*(CGFloat maxMultiplier){
        self.configObj.maxWidthMultiplier = maxMultiplier;
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))width {
    return  ^ZLPopViewBuilder*(CGFloat width){
        self.configObj.width = width;
        return self;
    };
}
- (instancetype)alertWidth270 {
    return self.width(270);
}
- (ZLPopViewBuilder* (^)(CGFloat))maxHeight {
    return  ^ZLPopViewBuilder*(CGFloat maxHeight){
        self.configObj.maxHeight = maxHeight;
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))heightMultiplier {
    return  ^ZLPopViewBuilder*(CGFloat multiplier){
        self.configObj.heightMultiplier = multiplier;
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))maxHeightMultiplier {
    return  ^ZLPopViewBuilder*(CGFloat multiplier){
        self.configObj.maxHeightMultiplier = multiplier;
        return self;
    };
}
- (instancetype)enableScrollWhenOutBounds{
    self.configObj.enableScrollWhenOutBounds = YES;
    return self;
}
- (instancetype)wrapScrollView {
    self.configObj.wrapScrollView = YES;
    return self;
}
- (ZLPopViewBuilder* (^)(void (^)(UIScrollView *)))configureScrollView {
    return  ^ZLPopViewBuilder*(void (^configure)(UIScrollView *)){
        self.configObj.configureScrollView = configure;
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))height {
    return  ^ZLPopViewBuilder*(CGFloat height){
        self.configObj.height = height;
        return self;
    };
}

- (instancetype)touchPenetrate {
    self.configObj.touchPenetrate = YES;
    return self;
}
//- (ZLPopViewBuilder* (^)(UIEdgeInsets))inset {
//    return  ^ZLPopViewBuilder*(UIEdgeInsets inset){
//        self.configObj.inset = inset;
//        return self;
//    };
//}
- (ZLPopViewBuilder * _Nonnull (^)(UIBlurEffectStyle))blurEffectStyle {
    return ^ZLPopViewBuilder* (UIBlurEffectStyle style){
        self.configObj.blurEffect = [UIBlurEffect effectWithStyle:style];
        return self;
    };
}
- (ZLPopViewBuilder * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))inset {
    return  ^ZLPopViewBuilder*(CGFloat top,CGFloat left,CGFloat bottom,CGFloat right){
        self.configObj.inset = UIEdgeInsetsMake(top, left, bottom, right);
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))insetAll {
    return  ^ZLPopViewBuilder*(CGFloat inset){
        self.configObj.inset = UIEdgeInsetsMake(inset, inset, inset, inset);
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))insetTop {
    return  ^ZLPopViewBuilder*(CGFloat top){
        self.configObj.inset = UIEdgeInsetsMake(top, self.configObj.inset.left, -self.configObj.inset.bottom, -self.configObj.inset.right);
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))insetLeading {
    return  ^ZLPopViewBuilder*(CGFloat left){
        self.configObj.inset = UIEdgeInsetsMake(self.configObj.inset.top, left, -self.configObj.inset.bottom, -self.configObj.inset.right);
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))insetBottom {
    return  ^ZLPopViewBuilder*(CGFloat bottom){
        self.configObj.inset = UIEdgeInsetsMake(self.configObj.inset.top, self.configObj.inset.left, bottom, -self.configObj.inset.right);
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))insetTrailing {
    return  ^ZLPopViewBuilder*(CGFloat right){
        self.configObj.inset = UIEdgeInsetsMake(self.configObj.inset.top, self.configObj.inset.left, -self.configObj.inset.bottom, right);
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat leading,CGFloat trailing))insetHorizontal{

    return  ^ZLPopViewBuilder*(CGFloat leading,CGFloat trailing){
        self.configObj.inset = UIEdgeInsetsMake(self.configObj.inset.top, leading, -self.configObj.inset.bottom, trailing);
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat top,CGFloat bottom))insetVertical{
    return  ^ZLPopViewBuilder*(CGFloat top,CGFloat bottom){
        self.configObj.inset = UIEdgeInsetsMake(top, self.configObj.inset.left, bottom, -self.configObj.inset.right);
        return self;
    };
}


- (ZLPopViewBuilder* (^)(id ))shadowColor{
    return  ^ZLPopViewBuilder*(id c){
        self.configObj.shadowColor = __UIColorFromObj(c);
        return self;
    };
}

- (ZLPopViewBuilder* (^)(CGSize ))shadowOffset {
    return  ^ZLPopViewBuilder*(CGSize s){
        self.configObj.shadowOffset = s;
        return self;
    };
}

- (ZLPopViewBuilder* (^)(CGFloat ))shadowOpacity {
    return  ^ZLPopViewBuilder*(CGFloat o){
        self.configObj.shadowOpacity = o;
        return self;
    };
}

- (ZLPopViewBuilder* (^)(CGFloat ))shadowRadius {
    return  ^ZLPopViewBuilder*(CGFloat s){
        self.configObj.shadowRadius = s;
        return self;
    };
}

- (ZLPopViewBuilder* (^)(id ))borderColor {
    return  ^ZLPopViewBuilder*(id c){
        self.configObj.borderColor = __UIColorFromObj(c);
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat ))borderWidth {
    return  ^ZLPopViewBuilder*(CGFloat w){
        self.configObj.borderWidth = w;
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat ))cornerRadius{
    return  ^ZLPopViewBuilder*(CGFloat r){
        self.configObj.cornerRadius = r;
        return self;
    };
}
- (instancetype)tapMaskDismiss {
    self.configObj.tapMaskDismiss = YES;
    return self;
}
- (instancetype)enableDragDismiss {
    self.configObj.enableDragDismiss = YES;
    return self;
}
- (instancetype)addDragGesture {
    self.configObj.addDragGestureRecognizer = YES;
    return self;
}
- (ZLPopViewBuilder* (^)(CGFloat))dragDismissIfGreaterThanDistance{
    return  ^ZLPopViewBuilder*(CGFloat dragDismissDistance){
        self.configObj.dragDismissDistance = dragDismissDistance;
        return self;
    };
}

- (ZLPopViewBuilder* (^)(CGFloat))animateIn{
    return  ^ZLPopViewBuilder* (CGFloat a){
        self.configObj.animationIn = a;
        return self;
    };
}
- (ZLPopViewBuilder* (^)(CGFloat))animateOut{
    return  ^ZLPopViewBuilder* (CGFloat a){
        self.configObj.animationOut = a;
        return self;
    };
}
- (ZLPopViewBuilder* (^)(ZLAvoidKeyboardType ))avoidKeyboardType {
    return  ^ZLPopViewBuilder* (ZLAvoidKeyboardType avoidKeyboardType){
        self.configObj.avoidKeyboardType = avoidKeyboardType;
        return self;
    };
}
- (instancetype)avoidKeyboardPopViewBottom {
    return self.avoidKeyboardType(ZLAvoidKeyboardTypePopViewBottom);
}
- (instancetype)avoidKeyboardFirstResponderBottom {
    return self.avoidKeyboardType(ZLAvoidKeyboardTypeFirstResponder);
}
- (instancetype)avoidKeyboardAlwaysCenter {
    return self.avoidKeyboardType(ZLAvoidKeyboardTypeAlwaysCenter);
}

- (ZLPopViewBuilder * _Nonnull (^)(ZLOrientationChangeBK _Nonnull))orientationChangeBK {
    return ^ZLPopViewBuilder* (ZLOrientationChangeBK bk){
        self.configObj.orientationChangeBk = bk;
        return self;
    };
}
- (ZLPopViewBuilder * (^)(ZLHorizontalLayoutConstraint))horizontalLayoutConstraint {
    return  ^ZLPopViewBuilder* (ZLHorizontalLayoutConstraint horizontalAlignment){
        self.configObj.horizontalLayout = horizontalAlignment;
        return self;
    };
}
- (instancetype)horizontalLayoutConstraintCenter{
    return self.horizontalLayoutConstraint(ZLHorizontalLayoutConstraintCenter);
}

- (ZLPopViewBuilder* (^)(CGFloat ))bottomOffsetToKeyboardTop {
    return  ^ZLPopViewBuilder* (CGFloat offset){
        self.configObj.bottomOffsetToKeyboard = offset;
        return self;
    };
}
- (ZLPopViewBuilder* (^)(UIView *))popSuperView {
    return  ^ZLPopViewBuilder* (UIView *superView){
        self.configObj.superView = superView;
        return self;
    };
}
- (ZLPopBaseView* )configPopView:(ZLPopBaseView *)view {
    ZLBuildConfigObj *j = self.configObj;
    if (!j.touchPenetrate && j.maskColor == nil) {
        self.configObj.maskColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    if (self.configObj.touchPenetrate) j.tapMaskDismiss = NO;
    UIStackView *stackV = nil;
    if (self.configObj.wrapScrollView ) {
        ZLUIScrollView *scrollView = [self buildScrollView];
        UIStackView *stackView = [scrollView viewWithTag:kZLUIStackViewTag];
        if ([stackView isKindOfClass:UIStackView.class]) {
            self.configObj.axis = stackView.axis;
        }
        scrollView.scrollEnabled = self.configObj.enableScrollWhenOutBounds;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        if (j.configureScrollView) j.configureScrollView(scrollView);
        view.buildView = scrollView;
        view.stackView = (ZLUIStackView *)stackView;
        view.scrollView = scrollView;
        stackV = stackView;
    }else {
        ZLUIStackView *stackView = [self buildStackView];
        self.configObj.axis = stackView.axis;
        view.buildView = stackView;
        view.stackView = stackView;
        stackV = stackView;
    }
    if (self.configObj.reserveSafeAreaBottom
        && stackV.layoutMargins.bottom < kZLSafeAreaBottom
        && -self.configObj.inset.bottom < kZLSafeAreaBottom
        ) {
        stackV.layoutMargins = UIEdgeInsetsMake(stackV.layoutMargins.top, stackV.layoutMargins.left, stackV.layoutMargins.bottom + kZLSafeAreaBottom, stackV.layoutMargins.right);
    }
    [view setValue:self.configObj forKey:@"configObj"];
    [self.builderCtx addView:view];
    return view;
}

- (ZLPopBottomView* )buildBottomPopView{
    if (self.configObj.horizontalLayout == ZLHorizontalLayoutConstraintNone) {
        self.configObj.horizontalLayout = ZLHorizontalLayoutConstraintFill;
    }
    return (ZLPopBottomView*)[self configPopView:ZLPopBottomView.new];
}
- (void (^)(void))showBottomPopView {
    return ^{
        [[self buildBottomPopView] show];
    };
}

- (ZLPopRightView* )buildRightPopView{
    self.configObj.horizontalLayout = ZLHorizontalLayoutConstraintTrailing;
    return (ZLPopRightView*)[self configPopView:ZLPopRightView.new];
}
- (void (^)(void) )showRightPopView {
    return ^{
        [[self buildRightPopView] show];
    };
}
- (ZLPopLeftView* )buildLeftPopView{
    self.configObj.horizontalLayout = ZLHorizontalLayoutConstraintLeading;
    return (ZLPopLeftView*)[self configPopView:ZLPopLeftView.new];
}
- (void (^)(void))showLeftPopView {
    return ^{
        [[self buildLeftPopView] show];
    };
}

- (ZLPopBottomView* )buildBottomPopFloatView{
    if (self.configObj.horizontalLayout == ZLHorizontalLayoutConstraintNone) {
        self.configObj.horizontalLayout = ZLHorizontalLayoutConstraintFill;
    }
    return (ZLPopBottomView*)[self configPopView:ZLPopBottomFloatView.new];
}

- (ZLPopOverView* )buildPopOverView{
    self.configObj.horizontalLayout = ZLHorizontalLayoutConstraintNone;
    return (ZLPopOverView*)[self configPopView:ZLPopOverView.new];
}
- (void (^)(void))showPopOverView {
    return ^{
        [[self buildPopOverView] show];
    };
}

- (ZLPopTopView* )buildTopPopView{
    if (self.configObj.horizontalLayout == ZLHorizontalLayoutConstraintNone) {
        self.configObj.horizontalLayout = ZLHorizontalLayoutConstraintFill;
    }
    return (ZLPopTopView*)[self configPopView:ZLPopTopView.new];
}
- (void (^)(void))showTopPopView {
    return ^{
        [[self buildTopPopView] show];
    };
}
- (ZLPopCenterView* )buildCenterPopView{
    if (self.configObj.horizontalLayout == ZLHorizontalLayoutConstraintNone) {
        self.configObj.horizontalLayout = ZLHorizontalLayoutConstraintCenter;
    }
    return (ZLPopCenterView*)[self configPopView:ZLPopCenterView.new];
}
- (void (^)(void))showCenterPopView {
    return ^{
        [[self buildCenterPopView] show];
    };
}
@end
#pragma clang diagnostic pop
