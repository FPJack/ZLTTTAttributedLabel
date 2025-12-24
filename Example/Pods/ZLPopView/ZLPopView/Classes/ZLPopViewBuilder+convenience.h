//
//  ZLPopViewBuilder+convenience.h
//  GMPopView
//
//  Created by admin on 2025/9/28.
//

#import <ZLPopView/ZLPopView.h>

NS_ASSUME_NONNULL_BEGIN

typedef UIView* _Nullable (^ZLAllocViewBlock)(ZLPopViewBuilder * _Nullable builder,NSString *text);
typedef UITextField* _Nullable (^ZLAllocTextFieldBK)(ZLPopViewBuilder * _Nullable builder,NSString *placeholder);
typedef UIView* _Nullable (^ZLAllocAttributeViewBK)(ZLPopViewBuilder * _Nullable builder,NSAttributedString *attributedText);
typedef UIView* _Nullable (^ZLActionViewsBK)(NSArray<UIView *> *actionViews, ZLPopViewBuilder *builder);


@interface ZLPopViewBuilder (convenience)
@property (class, nonatomic)ZLAllocViewBlock defaultTitleLabelBK;
@property (class, nonatomic)ZLAllocViewBlock defaultMessageLabelBK;
@property (class, nonatomic)ZLAllocAttributeViewBK defaultAttributedViewBK;
@property (class, nonatomic)ZLAllocTextFieldBK defaultTextFieldViewBK;
@property (class, nonatomic)ZLAllocViewBlock defaultCancelViewBK;
@property (class, nonatomic)ZLAllocViewBlock defaultConfirmViewBK;
@property (class, nonatomic)ZLAllocViewBlock defaultDeleteViewBK;
@property (class, nonatomic)ZLAllocViewBlock defaultButtonViewBK;

///! ! ! ! ! actionViews总是展示在最底部 ! ! ! ! !

///添加title 可通过defaultTitleLabelBK 设置默认的titleLabel样式
@property (nonatomic,readonly) ZLPopViewBuilder* (^title)(NSString * _Nullable);
///添加message 可通过defaultMessageLabelBK 设置默认的messageLabel样式
@property (nonatomic,readonly) ZLPopViewBuilder* (^message)(NSString * _Nullable);
///添加富文本message 可通过defaultAttributedViewBK 设置默认的label样式,通过富文本设置对齐方式
@property (nonatomic,readonly) ZLPopViewBuilder* (^attributedMsgText)(NSAttributedString * _Nullable);
///添加输入框 可通过defaultTextFieldViewBK 设置默认的textField样式
@property (nonatomic,readonly) ZLPopViewBuilder* (^addTextField)(void  (^ _Nullable textFieldBK)(UITextField *textField));

///自定义actionViews构建器弹出的时候,可以通过ZLStackViewBuilder来构建垂直或者水平的布局
@property (nonatomic,readonly) ZLPopViewBuilder * (^applyActionViewsContainerBK)(ZLActionViewsBK actionViewsBK);


///是否点击actionView后自动dismiss弹窗，默认YES
@property (nonatomic,readonly)ZLPopViewBuilder* (^autoDismissWhenTapActionView)(BOOL autoDismiss);

///添加自定义actionView
@property (nonatomic,readonly) ZLPopViewBuilder* (^addCustomViewAction)(UIView * _Nullable view, void(^ _Nullable action)(UIView *view));

@property (nonatomic,readonly) ZLPopViewBuilder* (^addCustomActionViewBK)(UIView * _Nullable(^ _Nullable action)(void));


///按条件是否添加actionView
@property (nonatomic,readonly) ZLPopViewBuilder* (^addCustomViewActionIf)(BOOL isAdd,UIView * _Nullable view, void(^ _Nullable action)(UIView *view));


///添加默认样式view 可通过defaultButtonViewBK 设置默认的buttonView样式
@property (nonatomic,readonly) ZLPopViewBuilder* (^addButtonViewStyleActionText)(NSString * _Nullable text, void(^ _Nullable action)(UIView *view));
///添加删除样式view 可通过defaultDeleteViewBK 设置默认的deleteView样式
@property (nonatomic,readonly) ZLPopViewBuilder* (^addDeleteViewStyleActionText)(NSString * _Nullable text, void(^ _Nullable action)(UIView *view));
///添加确认样式view 可通过defaultConfirmViewBK 设置默认的confirmView样式
@property (nonatomic,readonly) ZLPopViewBuilder* (^addConfirmViewStyleActionText)(NSString * _Nullable text, void(^ _Nullable action)(UIView *view));


///添加取消样式view，只能添加一个取消样式view
@property (nonatomic,readonly) ZLPopViewBuilder* (^addCancelViewStyleAction)(void(^ _Nullable action)(UIView *view));
///添加取消样式view ，只能添加一个取消样式view ， 可通过defaultCancelViewBK 设置默认的cancelView样式
@property (nonatomic,readonly) ZLPopViewBuilder* (^addCancelViewStyleActionText)(NSString  * _Nullable text, void(^ _Nullable action)(UIView *view));

///展示alert
@property (nonatomic,readonly)void (^showAlert)(void);
///展示actionSheet
@property (nonatomic,readonly)void (^showActionSheet)(void);
///展示类似微信的actionSheet
@property (nonatomic,readonly)void (^showWXActionSheet)(void);
@end

NS_ASSUME_NONNULL_END
