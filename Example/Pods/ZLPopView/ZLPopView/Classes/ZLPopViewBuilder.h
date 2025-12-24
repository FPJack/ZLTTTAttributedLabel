//
//  ZLPopViewBuilder.h
//  GMPopView
//
//  Created by admin on 2025/4/24.
//

#import <Foundation/Foundation.h>
#import "ZLStackViewBuilder.h"
#import "ZLPopBaseView.h"
NS_ASSUME_NONNULL_BEGIN
#define kPopViewRowBuilder  [ZLPopViewBuilder row]
#define kPopViewColumnBuilder  [ZLPopViewBuilder column]
typedef void(^ZLOrientationChangeBK)(ZLLayoutConstraintObj *constraintObj,ZLBuildConfigObj *configureObj,BOOL isLandscape);
@class ZLPopViewBuilder;
typedef void(^GMConfigureBlock)(ZLBuildConfigObj *configure);
@interface ZLPopViewBuilder : ZLBaseStackViewBuilder<ZLPopViewBuilder * >

@property (class, nonatomic)GMConfigureBlock defaultConfigureBK;

/// ZLHorizontalLayoutConstraintFill ,如果视屏方式为Fill，则设置宽度参数无效，可以通过marge 设置相对应的左右边距参数
@property (nonatomic,readonly)ZLPopViewBuilder * (^horizontalLayoutConstraint)(ZLHorizontalLayoutConstraint);
@property (nonatomic,readonly)ZLPopViewBuilder *horizontalLayoutConstraintCenter;

@property (nonatomic, copy, readonly)ZLPopViewBuilder* (^applyBuildBK)(void(^)(ZLPopViewBuilder* builder));

/// popView四边距
//@property (nonatomic,readonly)ZLPopViewBuilder * (^popViewMarge)(UIEdgeInsets);
@property (nonatomic,readonly)ZLPopViewBuilder * (^popViewMarge)(CGFloat leading,CGFloat top,CGFloat trailing,CGFloat bottom);
@property (nonatomic,readonly)ZLPopViewBuilder * (^popViewMargeTop)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^popViewMargeLeading)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^popViewMargeBottom)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^popViewMargeTrailing)(CGFloat);



/// 外边距，结合horizontalAlignment使用可实现精准布局
//@property (nonatomic,readonly)ZLPopViewBuilder * (^marge)(UIEdgeInsets);
@property (nonatomic,readonly)ZLPopViewBuilder * (^marge)(CGFloat leading,CGFloat top,CGFloat trailing,CGFloat bottom);
@property (nonatomic,readonly)ZLPopViewBuilder * (^margeAll)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^margeTop)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^margeLeading)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^margeBottom)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^margeTrailing)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^margeHorizontal)(CGFloat leading,CGFloat trailing);
/// width > maxWidth  > multiplier  >maxMultiplier优先级,宽高比都是相对于父视图的宽高,需要结合horizontalLayoutConstraint使用
@property (nonatomic,readonly)ZLPopViewBuilder * (^width)(CGFloat);
///  宽度270,系统alert的宽度
@property (nonatomic,readonly)ZLPopViewBuilder * alertWidth270;
/// 设置容器View最大宽度
@property (nonatomic,readonly)ZLPopViewBuilder * (^maxWidth)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^widthMultiplier)(CGFloat);
/// 如果内容是根据UILabel的宽度自适应，那么一定要设置label的preferredMaxLayoutWidth值，不然横竖平切换的时候不会自动根据内容切换
@property (nonatomic,readonly)ZLPopViewBuilder * (^maxWidthMultiplier)(CGFloat);
/// height > maxHeight 优先级
@property (nonatomic,readonly)ZLPopViewBuilder * (^height)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^maxHeight)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^heightMultiplier)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^maxHeightMultiplier)(CGFloat);

- (instancetype)enableScrollWhenOutBounds;
///scrollview包裹stackView，可以解决scrollview里面放stackview高度不自适应以及内容宽高超出容器宽高滑动的问题
- (instancetype)wrapScrollView;

/// 如果可以滑动外部配置ScrollView
- (ZLPopViewBuilder* (^)(void (^)(UIScrollView *)))configureScrollView;
/// 毛玻璃效果
@property (nonatomic,readonly)ZLPopViewBuilder * (^blurEffectStyle)(UIBlurEffectStyle style);

/// 内边距
//@property (nonatomic,readonly)ZLPopViewBuilder * (^inset)(UIEdgeInsets);
@property (nonatomic,readonly)ZLPopViewBuilder * (^inset)(CGFloat leading,CGFloat top,CGFloat trailing,CGFloat bottom);

@property (nonatomic,readonly)ZLPopViewBuilder * (^insetAll)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^insetTop)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^insetLeading)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^insetBottom)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^insetTrailing)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^insetHorizontal)(CGFloat leading,CGFloat trailing);
@property (nonatomic,readonly)ZLPopViewBuilder * (^insetVertical)(CGFloat top,CGFloat bottom);
/// 设置各个方向圆角
@property (nonatomic,readonly)ZLPopViewBuilder * (^corners)(UIRectCorner);
@property (nonatomic,readonly)ZLPopViewBuilder * (^topCorners)(CGFloat radius);
@property (nonatomic,readonly)ZLPopViewBuilder * (^bottomCorners)(CGFloat radius);
- (instancetype)allCorners;


/// 阴影颜色 default nil
@property (nonatomic,readonly)ZLPopViewBuilder * (^shadowColor)(id color);
/// 阴影偏移 default （0,2）
@property (nonatomic,readonly)ZLPopViewBuilder * (^shadowOffset)(CGSize);

/// 阴影透明度 default 0
@property (nonatomic,readonly)ZLPopViewBuilder * (^shadowOpacity)(CGFloat);

/// 阴影圆角 default 3
@property (nonatomic,readonly)ZLPopViewBuilder * (^shadowRadius)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^borderColor)(id color);
@property (nonatomic,readonly)ZLPopViewBuilder * (^borderWidth)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^cornerRadius)(CGFloat);

///内容视图的背景色
@property (nonatomic,readonly)ZLPopViewBuilder * (^backgroundColor)(id bgColor);
///  内容背景渐变色,UIColor or #333333
@property (nonatomic, readonly)ZLPopViewBuilder * (^bgGradientColors)(NSArray * colors);

@property (nonatomic, readonly)ZLPopViewBuilder * (^bgImage)(id imageOrName);
@property (nonatomic, readonly)ZLPopViewBuilder * (^bgImgageContentMode)(UIViewContentMode mode);

///是否保留底部安全区域，默认NO
@property (nonatomic, readonly)ZLPopViewBuilder * (^reserveSafeAreaBottom)(BOOL reserve);
- (instancetype)reserveSafeAreaBottomYes;


/// 背景蒙版颜色
@property (nonatomic,readonly)ZLPopViewBuilder * (^maskColor)(id color);
///自定义进入动画
@property (nonatomic,readonly)ZLPopViewBuilder * (^animationInBK)(ZLAnimationBlock aniationIn);
///自定义消失动画
@property (nonatomic,readonly)ZLPopViewBuilder * (^animationOutBK)(ZLAnimationBlock aniationOut);

/// 设置空白区域事件是否穿透到父视图
- (instancetype)touchPenetrate;
/// 点击蒙版是否dismiss,只有 setTouchPenetrate 为NO的时候才有效果
- (instancetype)tapMaskDismiss;
/// 是否添加拖拽手势，默认NO
- (instancetype)addDragGesture;
/// 是否支持拖拽dismiss ,中心弹出的不支持,默认NO,设置YES的时候setAddDragGesture也会自动设置为YES
- (instancetype)enableDragDismiss;
@property (nonatomic,readonly)ZLPopViewBuilder * (^dragDismissIfGreaterThanDistance)(CGFloat);
/// 动画时间,如需自定义动画把时间设置0,可以在popViewDidShow 和popViewDidHidden两个方法里面自己实现展示和消失的动画 default 0.25s
@property (nonatomic,readonly)ZLPopViewBuilder * (^animateIn)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^animateOut)(CGFloat);
@property (nonatomic,readonly)ZLPopViewBuilder * (^avoidKeyboardType)(ZLAvoidKeyboardType);
- (instancetype)avoidKeyboardPopViewBottom;
- (instancetype)avoidKeyboardFirstResponderBottom;
- (instancetype)avoidKeyboardAlwaysCenter;
///屏幕旋转监听回调, isLandscape 是否横屏,可拿到相对应的约束对象自行改变布局约束
@property (nonatomic,readonly)ZLPopViewBuilder * (^orientationChangeBK)(ZLOrientationChangeBK);
/// 底部到键盘的间距
@property (nonatomic,readonly)ZLPopViewBuilder * (^bottomOffsetToKeyboardTop)(CGFloat offset);
/// 设置父视图，默认window
@property (nonatomic,readonly)ZLPopViewBuilder * (^popSuperView)(UIView * superview);
/// 顶部弹出
- (ZLPopTopView* )buildTopPopView;
@property (nonatomic,readonly)void (^showTopPopView)(void);
/// 中心弹出
- (ZLPopCenterView* )buildCenterPopView;
@property (nonatomic,readonly)void (^showCenterPopView)(void);

/// 底部弹出
- (ZLPopBottomView* )buildBottomPopView;
@property (nonatomic,readonly)void (^showBottomPopView)(void);

/// 右边弹出
- (ZLPopRightView* )buildRightPopView;
@property (nonatomic,readonly)void (^showRightPopView)(void);


/// 左边弹出
- (ZLPopLeftView* )buildLeftPopView;
@property (nonatomic,readonly)void (^showLeftPopView)(void);

/// 底部悬浮
- (ZLPopBottomFloatView* )buildBottomPopFloatView;


/// 根据某个坐标聚焦弹出
- (ZLPopOverView* )buildPopOverView;

- (ZLUIStackView *)buildStackView NS_UNAVAILABLE;
- (ZLUIScrollView *)buildScrollView NS_UNAVAILABLE;

@property (nonatomic,readonly)void (^buildStackViewToSuperViewLayoutBK)(UIView *superView,BOOL (^layoutCallback)(ZLUIStackView *stackView)) NS_UNAVAILABLE;
@property (nonatomic,readonly)void (^buildScrollViewToSuperViewLayoutBK)(UIView *superView,BOOL (^layoutCallback)(ZLUIScrollView *scrollView)) NS_UNAVAILABLE;
@property (nonatomic,readonly)void (^buildStackViewToSuperView)(UIView *superView) NS_UNAVAILABLE;
@property (nonatomic,readonly)void (^buildScrollViewToSuperView)(UIView *superView) NS_UNAVAILABLE;
@property (nonatomic,readonly)ZLUIStackView* (^buildStackViewToSuperViewInsets)(UIView *superView,CGFloat leading,CGFloat top,CGFloat trailing,CGFloat bottom) NS_UNAVAILABLE;
@property (nonatomic,readonly)ZLUIScrollView* (^buildScrollViewToSuperViewInsets)(UIView *superView,CGFloat leading,CGFloat top,CGFloat trailing,CGFloat bottom) NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
