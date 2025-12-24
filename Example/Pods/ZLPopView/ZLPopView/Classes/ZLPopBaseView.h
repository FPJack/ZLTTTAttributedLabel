//
//  ZLPopBaseView.h
//  GMPopView
//
//  Created by admin on 2025/4/17.
//

#import <UIKit/UIKit.h>
@class ZLUIStackView,ZLUIScrollView;
NS_ASSUME_NONNULL_BEGIN
@class ZLPopBaseView;

typedef void (^ZLCompeteBlock)(BOOL finished);
typedef void(^ZLAnimationComplete)(ZLPopBaseView *popView,ZLCompeteBlock complete);

typedef void(^ZLAnimationBlock)(ZLPopBaseView *popView,ZLCompeteBlock complete);


typedef NS_OPTIONS(NSUInteger, ZLPanGestureActionType) {
    ZLPanGestureActionTypeNone,
    ZLPanGestureActionTypeHor,
    ZLPanGestureActionTypeVer
};

typedef NS_OPTIONS(NSUInteger, ZLAvoidKeyboardType) {
    ZLAvoidKeyboardTypeNone = 0,//不处理键盘弹出事件
    ZLAvoidKeyboardTypeFirstResponder,//键盘弹出的时候如果挡住了第一响应者底部则上移
    ZLAvoidKeyboardTypePopViewBottom ,//键盘弹出的时候如果挡住了PopView底部则上移
    ZLAvoidKeyboardTypeAlwaysCenter//键盘出现的时候popView 在剩余空间居中展示，buildCenterPopView才有效果
};
typedef NS_ENUM(NSInteger, ZLHorizontalLayoutConstraint) {
    ZLHorizontalLayoutConstraintNone,
    ZLHorizontalLayoutConstraintFill, //贴近两边开始布局
    ZLHorizontalLayoutConstraintLeading, //贴近左边开始布局
    ZLHorizontalLayoutConstraintTrailing, //贴近右边开始布局
    ZLHorizontalLayoutConstraintCenter, //水平中心点开始布局

};
///页面展示状态
typedef NS_ENUM(NSInteger, ZLPopViewPageState) {
    ZLPopViewPageStateNone = 0,
    /// 页面正在展示
    ZLPopViewPageStateShowing,
    /// 页面已经展示完成
    ZLPopViewPageStateDidShow,
    /// 页面正在消失
    ZLPopViewPageStateDismissing,
    /// 页面已经消失完成
    ZLPopViewPageStateDidDismissed,
};

typedef void(^PopViewCallbackBK) (ZLPopBaseView *popView);
@interface ZLKeyboardEvent : NSObject
@property (nonatomic,assign)BOOL keyboardIsShowing;
@property (nonatomic,assign)CGFloat keyboardHeight;
@property (nonatomic,assign)CGFloat animateDuration;

+ (instancetype)share;
@end

@interface ZLLayoutConstraintObj : NSObject
@property (nonatomic,weak)NSLayoutConstraint *margeBottomCons;
@property (nonatomic,weak)NSLayoutConstraint *margeTopCons;
@property (nonatomic,weak)NSLayoutConstraint *centerYCons;
@property (nonatomic,weak)NSLayoutConstraint *centerXCons;
@property (nonatomic,weak)NSLayoutConstraint *margeTrailingCons;
@property (nonatomic,weak)NSLayoutConstraint *margeLeadingCons;

@property (nonatomic,weak)NSLayoutConstraint *insetBottomCons;
@property (nonatomic,weak)NSLayoutConstraint *insetTopCons;
@property (nonatomic,weak)NSLayoutConstraint *insetTrailingCons;
@property (nonatomic,weak)NSLayoutConstraint *insetLeadingCons;

@property (nonatomic,weak)NSLayoutConstraint *widthCons;
@property (nonatomic,weak)NSLayoutConstraint *maxWidthCons;
@property (nonatomic,weak)NSLayoutConstraint *widthMultiplierCons;
@property (nonatomic,weak)NSLayoutConstraint *maxWidthMultiplierCons;

@property (nonatomic,weak)NSLayoutConstraint *heightCons;
@property (nonatomic,weak)NSLayoutConstraint *maxHeightCons;
@property (nonatomic,weak)NSLayoutConstraint *heightMultiplierCons;
@property (nonatomic,weak)NSLayoutConstraint *maxHeightMultiplierCons;


@property (nonatomic,weak)NSLayoutConstraint *popViewMargeBottomCons;
@property (nonatomic,weak)NSLayoutConstraint *popViewMargeTopCons;
@property (nonatomic,weak)NSLayoutConstraint *popViewMargeTrailingCons;
@property (nonatomic,weak)NSLayoutConstraint *popViewMargeLeadingCons;


@end


@interface ZLBuildConfigObj : NSObject
@property (nonatomic,weak)UIView *superView;
@property (nonatomic,assign)ZLAvoidKeyboardType avoidKeyboardType;
@property (nonatomic,strong)UIView *containerView;
@property (nonatomic,copy)UIColor *backgroundColor;
@property (nonatomic, strong) NSArray *bgGradientColors;
@property (nonatomic, strong) id bgImage;
@property (nonatomic,assign)UIViewContentMode bgImgageContentMode;
@property (nonatomic,strong)UIStackView *stackView;
@property (nonatomic,strong)UIColor *maskColor;
@property (nonatomic,assign)UIRectCorner corners;
@property (nonatomic,assign)UIEdgeInsets marge;
@property (nonatomic,assign)UIEdgeInsets popViewMarge;
@property (nonatomic,assign)CGFloat maxWidth;
@property (nonatomic,assign)CGFloat widthMultiplier;
@property (nonatomic,assign)CGFloat maxWidthMultiplier;
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,assign)CGFloat maxHeight;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,assign)CGFloat heightMultiplier;
@property (nonatomic,assign)CGFloat maxHeightMultiplier;
@property (nonatomic,strong)UIBlurEffect* blurEffect;
@property (nonatomic,copy)ZLAnimationBlock animationInBlock;
@property (nonatomic,copy)ZLAnimationBlock animationOutBlock;
@property (nonatomic, assign) BOOL reserveSafeAreaBottom;

@property (nonatomic,assign)ZLHorizontalLayoutConstraint horizontalLayout;
@property (nonatomic,assign)UIEdgeInsets inset;
@property (nonatomic,assign)BOOL touchPenetrate;
@property (nonatomic,assign)BOOL enableScrollWhenOutBounds;
@property (nonatomic,assign)BOOL wrapScrollView;
@property (nonatomic,copy)void (^configureScrollView)(UIScrollView *scrollView);
@property (nonatomic,assign)BOOL tapMaskDismiss;
@property (nonatomic,weak)UIView *parentView;
@property (nonatomic,assign)CGFloat animationIn;
@property (nonatomic,assign)CGFloat animationOut;

@property (nonatomic,assign)BOOL enableDragDismiss;
@property (nonatomic,assign)BOOL addDragGestureRecognizer;
@property (nonatomic,assign)CGFloat dragDismissDistance;
@property (nonatomic,assign)CGFloat bottomOffsetToKeyboard;

@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) CGFloat shadowRadius;
// 边框设置
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic) CGFloat topLeadingRadius;
@property (nonatomic) CGFloat topTrailingRadius;
@property (nonatomic) CGFloat bottomLeadingRadius;
@property (nonatomic) CGFloat bottomTrailingRadius;

@property(nonatomic,assign) UILayoutConstraintAxis axis;
@property (nonatomic,copy)void (^orientationChangeBk)(ZLLayoutConstraintObj *constraintObj,ZLBuildConfigObj *configureObj,BOOL isLandscape);

@end


@protocol ZLPopViewDelegate <NSObject>
@optional
- (void)popViewWillShow:(ZLPopBaseView *)popView;
- (void)popViewDidShow:(ZLPopBaseView *)popView;
- (void)popViewWillHidden:(ZLPopBaseView *)popView;
- (void)popViewDidHidden:(ZLPopBaseView *)popView;
/// PopView销毁的时候调用
- (void)popViewDealloc:(ZLPopBaseView *)popView;

- (void)popViewShowExpand:(ZLPopBaseView *)popView;
- (void)popViewShowTight:(ZLPopBaseView *)popView;
/// 拖拽未达到消失阈值，PopView 回弹到原始位置
- (void)popViewWillRebound:(ZLPopBaseView *)popView;
/// 拖拽过程中实时回调拖拽距离（正负表示方向）
- (void)popView:(ZLPopBaseView *)popView
didPanWithDistance:(CGFloat)distance;
@end

@interface _ZLView : UIView
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic,assign)UIRectCorner corners;
@end

typedef UIView* _Nullable (^ZLHitTestBK)(ZLPopBaseView *popView,CGPoint point,UIEvent *event,BOOL *stop);

//ParentView -> self -> ContainerView->contentView -> buildView
@interface ZLPopBaseView : UIView
///强引用对象，在某些特殊场合用来保存一些对象，防止被销毁，不需要额外全局去保存对象
@property (nonatomic,strong)id strongObj;
/// 外部控制响应者链的hitTest回调,优先返回响应的view，
@property (nonatomic,readonly)ZLPopBaseView *(^hitTestBK)(ZLHitTestBK block);
/// 页面状态
@property (nonatomic,assign,readonly)ZLPopViewPageState pageState;
///内容视图
@property (nonatomic,strong,readonly)_ZLView *containerView;
/// 所有约束对象
@property (nonatomic,strong,readonly)ZLLayoutConstraintObj *constraintObj;
/// 配置对象
@property (nonatomic,strong,readonly)ZLBuildConfigObj *configObj;
/// 通过stackview可以动态往popview里面添加删除view
@property (nonatomic,weak)ZLUIStackView *stackView;

///只有当设置了宽或高的参数的时候为scrollview对象才有值
@property (nonatomic,weak)ZLUIScrollView *scrollView;
///高斯模糊view
@property (nonatomic,strong,readonly)UIVisualEffectView *blurView;
/// 生命周期代理对象
@property (nonatomic,weak,readonly)id<ZLPopViewDelegate> delegateObj;
/// 页面销毁回调
@property (nonatomic,copy,nullable)ZLPopBaseView *(^deallocBK)(PopViewCallbackBK callback);
/// 类似viewDidLoad，只调用一次
@property (nonatomic,copy,nullable)ZLPopBaseView *(^initStateBK)(PopViewCallbackBK callback);
/// 页面展示完成回调
@property (nonatomic,copy,nullable)ZLPopBaseView *(^didShowBK)(PopViewCallbackBK callback);
/// 页面消失完成回调
@property (nonatomic,copy,nullable)ZLPopBaseView *(^didHiddenBK)(PopViewCallbackBK callback);
/// 设置代理对象
@property (nonatomic,copy,nullable)ZLPopBaseView *(^delegate)(id<ZLPopViewDelegate> delegate);
///
@property (nonatomic,copy,nullable)ZLPopBaseView *(^layoutSubviewBK)(PopViewCallbackBK callback);

/// 弹出popView
@property (nonatomic,readonly)void (^showPopView)(void);
/// 消失popView
@property (nonatomic,readonly)void (^dismissPopView)(void);
/// 弹出popView
- (void)show;
/// 消失popView
- (void)dismiss;
@end

@interface ZLPopTopView : ZLPopBaseView
@end
@interface ZLPopCenterView : ZLPopBaseView
@end
@interface ZLPopBottomView : ZLPopBaseView
@end
@interface ZLPopHorizontalView : ZLPopBaseView
/// 垂直方向中心偏移量
- (ZLPopHorizontalView* (^)(CGFloat ))setCenterYOffset;
@end
@interface ZLPopRightView : ZLPopHorizontalView
@end
@interface ZLPopLeftView : ZLPopHorizontalView
@end
@interface ZLPopFloatView : ZLPopBaseView
/// 默认内容高度的一半
- (ZLPopFloatView* (^)(CGFloat))setFloatHeight;
/// 完全展开状态
- (void)showExpand;
/// 收紧状态
- (void)showTight;
@end
@interface ZLPopBottomFloatView : ZLPopFloatView
@end
typedef NS_ENUM(NSInteger, ZLPopOverDirection) {
    ZLPopOverDirectionAuto = 0,   // 自动判断
    ZLPopOverDirectionUp,
    ZLPopOverDirectionDown,
    ZLPopOverDirectionLeading,
    ZLPopOverDirectionTrailing
};
@interface ZLPopOverView : ZLPopBaseView

/// 优先级大于setPoint,传View支持横竖平切换
- (ZLPopOverView* (^)(UIView *))setFromView;
- (ZLPopOverView* (^)(CGPoint))setPoint;
- (ZLPopOverView* (^)(CGFloat))setArrowWidth;
- (ZLPopOverView* (^)(CGFloat))setArrowHeight;
//- (ZLPopOverView* (^)(id ))setArrowColor;
/// 设置安全区域边距
- (ZLPopOverView* (^)(UIEdgeInsets ))setSafeAreaMarge;
/// 设置箭头和指向点的间距
- (ZLPopOverView* (^)(CGFloat ))setSpaceToPoint;
- (ZLPopOverView* (^)(ZLPopOverDirection))setDirection;
///锚点view的位置改变时刷新箭头位置
- (void)refreshArrowLayout;
@end
NS_ASSUME_NONNULL_END
