//
//  ZLStackViewBuilder.h
//  GMPopView
//
//  Created by admin on 2025/4/22.
//

#import <Foundation/Foundation.h>
#import "ZLBaseConfigure.h"
#define kStackViewRowBuilder [ZLStackViewBuilder row]
#define kStackViewColumnBuilder [ZLStackViewBuilder column]

#define kZLSafeAreaBottom kZLSafeAreaInsets.bottom

#define kZLSafeAreaTop kZLSafeAreaInsets.top

#define kZLSafeAreaInsets \
({UIEdgeInsets insets = UIEdgeInsetsZero; \
if (@available(iOS 11.0, *)) { \
    insets = UIApplication.sharedApplication.delegate.window.safeAreaInsets; \
} \
insets;})

NS_ASSUME_NONNULL_BEGIN
//参考flutter Row的MainAxisAlignment属性
typedef NS_ENUM(NSInteger, ZLMainAxisAlignment) {
    //UIStackView的属性
    ZLMainAxisAlignmentFill = 0,
    ZLMainAxisAlignmentFillEqually,
    ZLMainAxisAlignmentFillProportionally,
    ZLMainAxisAlignmentEqualSpacing,//中间间距相等
    ZLMainAxisAlignmentEqualCentering,
    //新增配置属性，stackview有具体宽度能计算出精确值,以下配置生效
    ZLMainAxisAlignmentStart ,
    ZLMainAxisAlignmentEnd ,
    ZLMainAxisAlignmentCenter ,
    ZLMainAxisAlignmentSpaceEvenly ,//两边和中间间距相等
    ZLMainAxisAlignmentSpaceAround ,//两边间距等于中间间距一半
  
};
id _recursive_objc_getAssociatedObject(id _Nonnull object, const void * _Nonnull key);


@class ZLBaseStackViewBuilder;

@interface ZLViewConfigObj : NSObject
@property (nonatomic,weak,readonly)UIView *view;
@property (nonatomic,assign,readonly)CGFloat alignmentMarge;
@property (nonatomic,assign,readonly)ZLCrossAxisAlignment alignment;
/// 设置view后面的间距
- (ZLViewConfigObj* (^)(CGFloat ))spacing;
- (ZLViewConfigObj* (^)(CGFloat ))frontSpaceing;
- (instancetype )startAlignment;
- (instancetype )endAlignment;
- (instancetype )centerAlignment;
- (instancetype )fillAlignment;
- (ZLViewConfigObj* (^)(CGFloat marge))startAlign;
- (ZLViewConfigObj* (^)(CGFloat marge))endAlign;
- (ZLViewConfigObj* (^)(CGFloat offsetY))centerAlign;
- (ZLViewConfigObj* (^)(ZLCrossAxisAlignment ))align;
@end

@interface ZLUIStackView : UIStackView
@property (nonatomic,strong,readonly)ZLBuilderContext *context;
@property (nonatomic,assign,readonly)ZLMainAxisAlignment mainAxisAlignment;
- (void)removeArrangedSubviewWithTag:(NSInteger )tag;
- (void)insertArrangedSubview:(UIView *)view behindView:(UIView *)siblingSubview;
- (void)insertArrangedSubview:(UIView *)view frontView:(UIView *)siblingSubview;
///刷新布局
- (void)refreshArrangedViewsLayout;
///排序arrangedSubviews 根据tag从小到大
- (void)sortArrangedSubviewsByTag;
@end

@interface ZLItemViewObj : NSObject
@property (nonatomic,strong)UIView *view;
@property (nonatomic,strong)NSArray<UIView *> *arrangedSubviews;
@property (nonatomic,copy)ViewKFCType (^viewBlock)(void) ;
@property (nonatomic,copy)NSArray<UIView *>* (^viewsBlock)(void);
@property (nonatomic,copy)ViewKFCType (^viewBlock1)(ZLBuilderContext *ctx);
@property (nonatomic,copy)NSArray<UIView *>* (^viewsBlock1)(ZLBuilderContext *ctx);
@property (nonatomic,assign)BOOL isSpacer;
@property (nonatomic,assign)CGFloat space;
@property (nonatomic,assign)CGFloat customSpace;
@property (nonatomic,assign)BOOL isAddSubView;
@property (nonatomic,assign)BOOL addMiddleSeparator;
@end

@interface ZLUIScrollView : UIScrollView
- (void)scrollToView:(UIView *)view atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToPage:(NSInteger)page atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;
@end
@interface ZLBaseStackViewBuilder<__covariant ObjectType > : NSObject
@property (nonatomic,class)UIColor *defaultSeparatorColor;
@property (nonatomic,class)CGFloat defaultSeparatorThickness;


@property (nonatomic,strong,readonly)NSMutableArray<ZLItemViewObj*> *views;
@property (nonatomic,strong,readonly)ZLBuilderContext *builderCtx;

@property (nonatomic,weak)ZLItemViewObj *currentViewObj;
// 禁止外部调用 alloc 和 new
+ (instancetype)alloc NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
/// 水平方向
+ (instancetype)row;
+ (instancetype)rowFillEqually;
/// 竖直方向
+ (instancetype)column;
+ (instancetype)columnFillEqually;

///复用同样的构建步骤进行构建
@property (nonatomic, copy, readonly)ObjectType (^applyBuildBK)(void(^)(__kindof ZLBaseStackViewBuilder* builder));
/// 添加view or view.kfc
/// - Parameter view: <#view description#>
@property (nonatomic,readonly)ObjectType (^addView)(ViewKFCType _Nullable view);
/// 通过builder添加view
@property (nonatomic,readonly)ObjectType (^addViewBuilder)(ZLBaseStackViewBuilder * _Nullable);
/// 条件添加view
@property (nonatomic,readonly)ObjectType (^addViewIf)(BOOL shouldAdd,ViewKFCType _Nullable view);
/// 添加view并携带点击事件
@property (nonatomic,readonly)ObjectType (^addViewWithTapBK)(ViewKFCType _Nullable view,void (^)(__kindof UIView * view));
///添加view 在block里面进行初始化配置
@property (nonatomic,readonly)ObjectType (^addViewWithConfigBK)(ViewKFCType _Nullable view,void (^)(__kindof UIView * view));
/// 底部带下划线
@property (nonatomic,readonly)ObjectType (^addViewWBS)(ViewKFCType _Nullable view);
/// 顶部带上划线
@property (nonatomic,readonly)ObjectType (^addViewWTS)(ViewKFCType _Nullable view);
/// 左侧带左划线
@property (nonatomic,readonly)ObjectType (^addViewWLS)(ViewKFCType _Nullable view);
/// 右侧带右划线
@property (nonatomic,readonly)ObjectType (^addViewWRS)(ViewKFCType _Nullable view);
/// 已数组的形式添加
@property (nonatomic,readonly)ObjectType (^addViews)(NSArray<UIView *> *);
/// 已数组的形式添加，view之间带分割线
@property (nonatomic,readonly)ObjectType (^addViewsWMS)(NSArray<UIView *> *);
/// 懒加载添加view
/// - Parameter block: <#block description#>
@property (nonatomic,readonly)ObjectType (^addViewBK)(ViewKFCType _Nullable (^)(void) );
@property (nonatomic,readonly)ObjectType (^addViewsBK)(NSArray<UIView *>* (^)(void) );

///添加一个水平布局的view
@property (nonatomic,readonly)ObjectType (^addRowViews)(ZLMainAxisAlignment,NSArray<UIView *>*);

///添加一个水平布局宽度都相等的view
@property (nonatomic,readonly)ObjectType (^addRowEWViews)(NSArray<UIView *>*);


/// 顶部带上划线
@property (nonatomic,readonly)ObjectType (^addRowEWViewsWTS)(NSArray<UIView *>*);
/// 底部带下划线
@property (nonatomic,readonly)ObjectType (^addRowEWViewsWBS)(NSArray<UIView *>*);
/// view之间带分割线
@property (nonatomic,readonly)ObjectType (^addRowEWViewsWMS)(NSArray<UIView *>*);
/// view之间带分割线,整体顶部也带上划线
@property (nonatomic,readonly)ObjectType (^addRowEWViewsWTMS)(NSArray<UIView *>*);
///添加一个垂直布局高度都相等的view
@property (nonatomic,readonly)ObjectType (^addColumnEHViews)(NSArray<UIView *>*);
/// view之间带分割线
@property (nonatomic,readonly)ObjectType (^addColumnEHViewsWMS)(NSArray<UIView *>*);
@property (nonatomic,readonly)ObjectType (^addColumnEHViewsWTMS)(NSArray<UIView *>*);
/// 条件为YES 懒加载添加view
/// - Parameter block: <#block description#>
@property (nonatomic,readonly)ObjectType (^addViewBKIf)(BOOL shouldAdd, ViewKFCType _Nullable (^)(void));
///携带context
/// - Parameter block: <#block description#>
@property (nonatomic,readonly)ObjectType (^addViewWithCtxBK)(ViewKFCType _Nullable (^)(ZLBuilderContext * ctx));

@property (nonatomic,readonly)ObjectType (^addViewsWithCtxBK)(NSArray<UIView *>* (^)(ZLBuilderContext * ctx));

/////添加SubView [self addSubview:view]
//@property (nonatomic,readonly)ObjectType (^addSubview)(UIView *);
//
//@property (nonatomic,readonly)ObjectType (^addSubviewBK)(UIView* (^)(void));
//
//
//
//@property (nonatomic,readonly)ObjectType (^addSubviewWithCtxBK)(UIView* (^)(ZLBuilderContext * ctx));

/// 设置view的宽高撑开间距
/*
 self.mainAxisAlignment != ZLMainAxisAlignmentFillEqually &&
 self.mainAxisAlignment != ZLMainAxisAlignmentEqualSpacing &&
 self.mainAxisAlignment != ZLMainAxisAlignmentEqualCentering &&
 self.mainAxisAlignment != ZLMainAxisAlignmentFillProportionally
 */


@property (nonatomic,readonly)ObjectType (^addSpaceView)(CGFloat);


@property (nonatomic,readonly)ObjectType (^spaceViewColor)(id color);


/// 设置倒叙排序

@property (nonatomic,readonly)ObjectType (^reverse)(BOOL isReverse);


/// 通过context可全局跨bui'der获取构建的view，（跨builder共享对象）
@property (nonatomic,readonly)ObjectType (^context)(ZLBuilderContext *);

/// 添加可弹性收缩View
/*
 self.mainAxisAlignment == ZLMainAxisAlignmentFill
 */
@property (nonatomic,readonly)ObjectType (^addFlexSpaceView)(void);


@property (nonatomic,readonly)ObjectType (^separatorColor)(id);
@property (nonatomic,readonly)ObjectType (^separatorThickness)(CGFloat);
/// 设置分割线颜色和宽高优先级，数值越大优先级越高,嵌套多个builder的时候使用
@property (nonatomic,readonly)ObjectType (^separatorColorThicknessPriority)(NSInteger);

/// 子控件默认间距
///优先级  kfc.frontSpace >  customSpace > kfc.space  > space
@property (nonatomic,readonly)ObjectType (^space)(CGFloat);
///类似 [stackview setCustomSpacing:3 afterView:view]
@property (nonatomic,readonly)ObjectType (^customSpace)(CGFloat);
/// 内边距
//@property (nonatomic,readonly)ObjectType (^padding)(UIEdgeInsets);

@property (nonatomic,readonly)ObjectType (^padding)(CGFloat leading,CGFloat top,CGFloat trailing,CGFloat bottom);
@property (nonatomic,readonly)ObjectType (^paddingHorLT)(CGFloat leading,CGFloat trailing);
@property (nonatomic,readonly)ObjectType (^paddingVerTB)(CGFloat leading,CGFloat trailing);
@property (nonatomic,readonly)ObjectType (^paddingTop)(CGFloat);
@property (nonatomic,readonly)ObjectType (^paddingLeading)(CGFloat);
@property (nonatomic,readonly)ObjectType (^paddingBottom)(CGFloat);
@property (nonatomic,readonly)ObjectType (^paddingTrailing)(CGFloat);


/// 主轴布局方式
@property (nonatomic,readonly)ObjectType (^distribution)(ZLMainAxisAlignment);

/// 设置主轴布局方式为填充
- (instancetype )distributionFill;
- (instancetype )distributionFillEqually;
- (instancetype )distributionFillProportionally;
- (instancetype )distributionEqualSpacing;
- (instancetype )distributionEqualCentering;
- (instancetype )distributionStart;
- (instancetype )distributionEnd;
- (instancetype )distributionCenter;
- (instancetype )distributionSpaceEvenly;
- (instancetype )distributionSpaceAround;

/// 对齐方式
@property (nonatomic,readonly)ObjectType (^alignment)(UIStackViewAlignment);

/// 设置对齐方式为填充
- (instancetype)alignmentCenter;
- (instancetype)alignmentFill;
- (instancetype)alignmentStart;
- (instancetype)alignmentEnd;



/// stackView或者scrollView被添加到父视图上的时候回调，此时 arrangedSubview也全部被添加到stackView里面,只会调用一次
@property (nonatomic,readonly)ObjectType (^didMoveTopSuperViewListenerBK)(void (^)(ZLBuilderContext *ctx));
///stackView或者scrollView layoutSubview被调用时调用，里面可以拿到布局完后的frame,返回YES 后面停止监听,！！！当返回NO的时候注意self的循环引用
@property (nonatomic,readonly)ObjectType (^layoutSubviewsListenerBK)(BOOL (^) (ZLBuilderContext *context));
/// 构建stackView
- (ZLUIStackView *)buildStackView;
/// 构建可滑动ScrollView,当StackView自动撑开的高度大于外部ScrollView宽高时候可以滑动
- (ZLUIScrollView *)buildScrollView;

///构建buildView 添加到父视图上,自动添加约束
@property (nonatomic,readonly)void (^buildStackViewToSuperView)(UIView *superView);
@property (nonatomic,readonly)void (^buildScrollViewToSuperView)(UIView *superView);

/// 构建buildView添加到父视图上，
/// - Parameters:
///   - superView: 父视图
///   - insets: 布局边距

@property (nonatomic,readonly)ZLUIStackView* (^buildStackViewToSuperViewInsets)(UIView *superView,CGFloat top,CGFloat leading,CGFloat trailing,CGFloat bottom);
@property (nonatomic,readonly)ZLUIScrollView* (^buildScrollViewToSuperViewInsets)(UIView *superView,CGFloat top,CGFloat leading,CGFloat trailing,CGFloat bottom);

///  构建buildView添加到父视图上，布局的时候回调
/// - Parameters:
///   - superView: 父视图
///   - callback:构建的stackView或者scrollView方法layoutSubview调用的时候回调，返回YES callback只会调用一次
@property (nonatomic,readonly)void (^buildStackViewToSuperViewLayoutBK)(UIView *superView,BOOL (^layoutCallback)(ZLUIStackView *stackView));

@property (nonatomic,readonly)void (^buildScrollViewToSuperViewLayoutBK)(UIView *superView,BOOL (^layoutCallback)(ZLUIScrollView *scrollView));

@end


@class ZLStackViewBuilder;
@interface ZLStackViewBuilder : ZLBaseStackViewBuilder<ZLStackViewBuilder *>
@property (nonatomic, copy, readonly)ZLStackViewBuilder* (^applyBuildBK)(void(^)(ZLStackViewBuilder* builder));
@end


NS_ASSUME_NONNULL_END
