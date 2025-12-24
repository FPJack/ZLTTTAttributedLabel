//
//  ZLPopViewBuilder+convenience.m
//  GMPopView
//
//  Created by admin on 2025/9/28.
//

#import "ZLPopViewBuilder+convenience.h"
#import <objc/runtime.h>
@interface ZLPopViewBuilder()
@property (nonatomic,strong)ZLBuildConfigObj *configObj;
@property (nonatomic,weak)UIView *lastLabelView;
@property (nonatomic,strong)NSMutableArray *customActionViews;
@property (nonatomic,assign)int alertType; //1:alert 2:actionSheet 3:wxActionSheet
@property (nonatomic,strong)UIView *cancelView;
@property (nonatomic,assign)BOOL dismissWhenTapActionView;
@property (nonatomic,assign)NSInteger cancelViewIdx;
@property (nonatomic,copy)UIColor *_separatorColor;
@property (nonatomic,assign)CGFloat _separatorThickness;
@property (nonatomic,copy)UIColor *_spaceViewColor;
@property (nonatomic,strong)ZLActionViewsBK actionViewsBlock;
@end
@implementation ZLPopViewBuilder (convenience)


+ (void)setDefaultTitleLabelBK:(ZLAllocViewBlock)defaultTitleLabel {
    objc_setAssociatedObject(self, @selector(defaultTitleLabelBK), defaultTitleLabel, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+ (ZLAllocViewBlock)defaultTitleLabelBK {
    ZLAllocViewBlock titleLabelBlock = _recursive_objc_getAssociatedObject(self, @selector(defaultTitleLabelBK));
    if (!titleLabelBlock) {
        titleLabelBlock = ^(ZLPopViewBuilder *builder, NSString *title){
            return UILabel.kfc
                .text(title)
                .systemFontSizeMedium(18)
                .textColor(UIColor.blackColor)
                .multipleLines
                .textAlignmentCenter
                .spacing(16)
                .margeHorizontal(10)
                .view;
        };
        [self setDefaultTitleLabelBK:titleLabelBlock];
    }
    return titleLabelBlock;
}
+ (void)setDefaultMessageLabelBK:(ZLAllocViewBlock)defaultMessageLabel {
    objc_setAssociatedObject(self, @selector(defaultMessageLabelBK), defaultMessageLabel, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
+ (ZLAllocViewBlock)defaultMessageLabelBK {
    ZLAllocViewBlock messageLabelBlock = _recursive_objc_getAssociatedObject(self, @selector(defaultMessageLabelBK));
    if (!messageLabelBlock) {
        messageLabelBlock = ^(ZLPopViewBuilder *builder, NSString *message){
            return UILabel.kfc
                .text(message)
                .systemFontSize(14)
                .textColor([UIColor.blackColor colorWithAlphaComponent:0.5])
                .multipleLines
                .textAlignmentCenter
                .spacing(32)
                .margeHorizontal(10)
                .view;
        };
        [self setDefaultMessageLabelBK:messageLabelBlock];
    }
    return messageLabelBlock;
}
+ (ZLAllocViewBlock)defaultCancelViewBK {
    ZLAllocViewBlock cancelViewBlock = _recursive_objc_getAssociatedObject(self, @selector(defaultCancelViewBK));
    if (!cancelViewBlock) {
        cancelViewBlock = ^(ZLPopViewBuilder *builder, NSString *title){
            return UIButton.kfc
                .title(title ?: @"取消")
                .titleSystemFontSizeMedium(14)
                .titleColor(UIColor.systemRedColor)
                .height(50)
                .dismissPopViewWhenTap
                .defaultHighlightBgColor
                .view;
        };
        [self setDefaultCancelViewBK:cancelViewBlock];
    }
    return cancelViewBlock;
}
+ (ZLAllocViewBlock)defaultConfirmViewBK {
    ZLAllocViewBlock confirmViewBlock = _recursive_objc_getAssociatedObject(self, @selector(defaultConfirmViewBK));
    if (!confirmViewBlock) {
        confirmViewBlock = ^(ZLPopViewBuilder *builder, NSString *title){
            return UIButton.kfc
                .title(title ?: @"确定")
                .titleSystemFontSizeMedium(14)
                .titleColor(UIColor.systemBlueColor)
                .defaultHighlightBgColor
                .height(50)
                .view;
        };
        [self setDefaultConfirmViewBK:confirmViewBlock];
    }
    return confirmViewBlock;
}
+ (ZLAllocViewBlock)defaultDeleteViewBK {
    ZLAllocViewBlock deleteViewBlock = _recursive_objc_getAssociatedObject(self, @selector(defaultDeleteViewBK));
    if (!deleteViewBlock) {
        deleteViewBlock = ^(ZLPopViewBuilder *builder, NSString *title){
            return UIButton.kfc
                .title(title ?: @"删除")
                .titleSystemFontSizeMedium(14)
                .titleColor(UIColor.systemRedColor)
                .defaultHighlightBgColor
                .height(50)
                .dismissPopViewWhenTap
                .view;
        };
        [self setDefaultDeleteViewBK:deleteViewBlock];
    }
    return deleteViewBlock;
}
+ (ZLAllocViewBlock)defaultButtonViewBK {
    ZLAllocViewBlock buttonViewBlock = _recursive_objc_getAssociatedObject(self, @selector(defaultButtonViewBK));
    if (!buttonViewBlock) {
        buttonViewBlock = ^(ZLPopViewBuilder *builder, NSString *title){
            return UIButton.kfc
                .title(title ?: @"按钮")
                .titleSystemFontSizeMedium(14)
                .titleColor(UIColor.systemBlueColor)
                .defaultHighlightBgColor
                .height(50)
                .view;
        };
        [self setDefaultButtonViewBK:buttonViewBlock];
    }
    return buttonViewBlock;
}
+ (ZLAllocTextFieldBK)defaultTextFieldViewBK {
    ZLAllocTextFieldBK textFieldViewBlock = _recursive_objc_getAssociatedObject(self, @selector(defaultTextFieldViewBK));
    if (!textFieldViewBlock) {
        textFieldViewBlock = ^(ZLPopViewBuilder *builder, NSString *placeholder){
            return UITextField.kfc
                .placeholder(placeholder)
                .frontSpacing(20)
                .spacing(15)
                .borderWidth(0.5)
                .leftPadding(10)
                .clearButtonMode(UITextFieldViewModeWhileEditing)
                .returnKeyType(UIReturnKeyDone)
                .borderColor(UIColor.lightGrayColor)
                .cornerRadius(5)
                .margeHorizontal(15)
                .height(40)
                .view;
        };
        [self setDefaultTextFieldViewBK:textFieldViewBlock];
    };
    return textFieldViewBlock;
}
+ (void)setDefaultTextFieldViewBK:(ZLAllocTextFieldBK)defaultTextFieldViewBK {
    objc_setAssociatedObject(self, @selector(defaultTextFieldViewBK), defaultTextFieldViewBK, OBJC_ASSOCIATION_COPY_NONATOMIC);

}
+ (void)setDefaultButtonViewBK:(ZLAllocViewBlock)defaultButtonViewBK {
    objc_setAssociatedObject(self, @selector(defaultButtonViewBK), defaultButtonViewBK, OBJC_ASSOCIATION_COPY_NONATOMIC);

}
+ (void)setDefaultDeleteViewBK:(ZLAllocViewBlock)defaultDeleteViewBK {
    objc_setAssociatedObject(self, @selector(defaultDeleteViewBK), defaultDeleteViewBK, OBJC_ASSOCIATION_COPY_NONATOMIC);

}
+ (void)setDefaultConfirmViewBK:(ZLAllocViewBlock)defaultConfirmViewBK {
    objc_setAssociatedObject(self, @selector(defaultConfirmViewBK), defaultConfirmViewBK, OBJC_ASSOCIATION_COPY_NONATOMIC);

}
+ (void)setDefaultCancelViewBK:(ZLAllocViewBlock)defaultCancelViewBK {
    objc_setAssociatedObject(self, @selector(defaultCancelViewBK), defaultCancelViewBK, OBJC_ASSOCIATION_COPY_NONATOMIC);

}
+ (void)setDefaultAttributedViewBK:(ZLAllocAttributeViewBK)defaultAttributedViewBK {
    objc_setAssociatedObject(self, @selector(defaultAttributedViewBK), defaultAttributedViewBK, OBJC_ASSOCIATION_COPY_NONATOMIC);

}
+ (ZLAllocAttributeViewBK)defaultAttributedViewBK {
    ZLAllocAttributeViewBK attributedViewBlock = _recursive_objc_getAssociatedObject(self, @selector(defaultAttributedViewBK));
    if (!attributedViewBlock) {
        attributedViewBlock = ^(ZLPopViewBuilder *builder, NSAttributedString *attributedString){
            return UILabel.kfc
                .multipleLines
                .spacing(32)
                .margeHorizontal(10)
                .attributedText(attributedString)
                .view;
        };
        [self setDefaultAttributedViewBK:attributedViewBlock];
    }
    return attributedViewBlock;
}
- (ZLPopViewBuilder *)defaultInsetTop {
    CGFloat insetTop = self.configObj.inset.top;
    if (insetTop <= 0) self.insetTop(20);
    return self;
}
- (ZLPopViewBuilder * (^)(NSString *))title {
    return ^ZLPopViewBuilder *(NSString *title){
        UIView *view = self.class.defaultTitleLabelBK(self,title);
        self.defaultInsetTop.addView(view);
        self.lastLabelView = view;
        return self;
    };
}
- (ZLPopViewBuilder * (^)(NSString *))message {
    return ^ZLPopViewBuilder *(NSString *message){
        UIView *view = self.class.defaultMessageLabelBK(self,message);
        self.defaultInsetTop.addView(view);
        self.lastLabelView = view;
        return self;
    };
}
- (ZLPopViewBuilder * _Nonnull (^)(NSAttributedString * _Nullable))attributedMsgText {
    return ^ZLPopViewBuilder *(NSAttributedString *attributedString){
        UIView *view = self.class.defaultAttributedViewBK(self,attributedString);
        self.defaultInsetTop.addView(view);
        self.lastLabelView = view;
        return self;
    };
}
- (ZLPopViewBuilder * _Nonnull (^)(void (^ _Nullable)(UITextField * _Nonnull)))addTextField {
    return ^ZLPopViewBuilder *(void(^action)(UITextField *textField)){
        UITextField *textField = self.class.defaultTextFieldViewBK(self,@"");
        if (action) action(textField);
        self.lastLabelView = textField;
        self.defaultInsetTop.addView(textField);
        return self;
    };
}
- (ZLPopViewBuilder * _Nonnull (^)(BOOL))autoDismissWhenTapActionView {
    return ^ZLPopViewBuilder *(BOOL autoDismiss){
        self.dismissWhenTapActionView = autoDismiss;
        return self;
    };
}

- (ZLPopViewBuilder * _Nonnull (^)(ZLActionViewsBK _Nonnull))applyActionViewsContainerBK {
    return ^ZLPopViewBuilder *(ZLActionViewsBK block){
        self.actionViewsBlock = block;
        return self;
    };
}
- (void)configureActionView:(UIView *)view action:(void(^)(UIView *view))action {
    if ([view isKindOfClass:UIView.class]) {
        BOOL dismiss = self.dismissWhenTapActionView;
        if ([view isKindOfClass:UIButton.class]) {
            ((UIButton *)view).kfc.addTouchUpAction(^(UIButton * _Nonnull button) {
                if (action) action(button);
                if (dismiss) button.kfc.dismissPopView();
            });
        }else {
            view.kfc.addTapAction(^(UIView * _Nonnull view) {
                if (action) action(view);
                if (dismiss) view.kfc.dismissPopView();
            });
        }
    }
}
- (void)defaultInsetBottom {
    CGFloat insetBottom = self.configObj.inset.bottom;
    if (insetBottom <= 0) self.insetBottom(20);
}
- (void)handlerCustomActionView{
    CGFloat radius = self.configObj.cornerRadius > 0 ? self.configObj.cornerRadius : 10;
    if (self.alertType == 1) {
        if (self.cancelView && self.cancelViewIdx >= 0 && self.cancelViewIdx <= self.customActionViews.count) {
            [self.customActionViews insertObject:self.cancelView atIndex:self.cancelViewIdx];
        }
        if (self.customActionViews.count > 0) {
            if (self.customActionViews.count > 2) {
                self.addColumnEHViewsWTMS(self.customActionViews);
            }else {
                self.addRowEWViewsWTMS(self.customActionViews);
            }
        }
        if (self.lastLabelView) [self defaultInsetBottom];
    } else if (self.alertType == 2) {
        
        ZLStackViewBuilder *builder = kStackViewColumnBuilder;
        [builder.views addObjectsFromArray:self.views];
        if (self.lastLabelView || self.views.count > 0) {
            builder.addColumnEHViewsWTMS(self.customActionViews);
        }else {
            builder.addColumnEHViewsWMS(self.customActionViews);
        }
        UIView *contentView = builder
            .alignmentFill
            .paddingTop((self.lastLabelView || self.views.count > 0) ? 15 : 0)
            .paddingBottom(self.customActionViews.count > 0 ? 0 : 15)
            .buildStackView.kfc
            .cornerRadius(radius)
            .backgroundColor(self.configObj.backgroundColor ?: UIColor.whiteColor)
            .spacing(8)
            .view;
        [self.views removeAllObjects];
        self.addView(contentView);
        if (self.cancelView) {
            CGFloat radius = self.cancelView.layer.cornerRadius > 0 ?: (self.configObj.cornerRadius > 0 ? self.configObj.cornerRadius : 10);

            UIView *cancelView = self.cancelView.kfc
                .cornerRadius(radius)
                .backgroundColor(self.cancelView.backgroundColor ?: self.configObj.backgroundColor ?: UIColor.whiteColor)
                .view;
            self.addView(cancelView);
        }
        self.backgroundColor(UIColor.clearColor);
    }else if (self.alertType == 3) {
        if (!self.lastLabelView && self.views.count == 0) {
            self.addColumnEHViewsWMS(self.customActionViews);
            if (self.configObj.inset.top <= 0) {
                self.insetTop(0);
            }
        }else {
            if (self.customActionViews.count > 0) {
                self.addColumnEHViewsWTMS(self.customActionViews);
                if (-self.configObj.inset.bottom >= 0) {
                    self.insetBottom(kZLSafeAreaBottom);
                }
                if (self.configObj.inset.top <= 0) {
                    self.insetTop(20);
                }
            }
        }
        if (self.lastLabelView || self.views.count > 0 || self.customActionViews.count > 0) {
            self.addSpaceView(8);
        }
        if (self.cancelView) {
            CGFloat radius = self.cancelView.layer.cornerRadius > 0 ?: (self.configObj.cornerRadius > 0 ? self.configObj.cornerRadius : 10);
            UIView *cancelView = self.cancelView.kfc
                .cornerRadius(radius)
                .view;
            self.addView(cancelView);
        }
    }else {
        if (self.customActionViews.count > 0) {
            if (self.cancelView && self.cancelViewIdx >= 0 && self.cancelViewIdx <= self.customActionViews.count) {
                [self.customActionViews insertObject:self.cancelView atIndex:self.cancelViewIdx];
            }
            if (self.actionViewsBlock) {
                self.addView(self.actionViewsBlock(self.customActionViews, self));
                self.actionViewsBlock = nil;
            }else {
                self.addRowEWViewsWTMS(self.customActionViews);
            }
        }else {
            if (self.cancelView) {
                self.addView(self.cancelView);
            }
        }
    }
    self.cancelView = nil;
}
- (instancetype)addCustomActionView:(UIView *)view handler:(void(^)(UIView *view))action{
    if (![view isKindOfClass:UIView.class]) return self;
    [self configureActionView:view action:action];
    [self.customActionViews addObject:view];
    return self;
}
- (ZLPopViewBuilder * _Nonnull (^)(UIView * _Nonnull, void (^ _Nonnull)(UIView * _Nonnull)))addCustomViewAction {
    return ^ZLPopViewBuilder *(UIView *view, void(^action)(UIView *view)){
        return [self addCustomActionView:view handler:action];
    };
}
- (ZLPopViewBuilder * _Nonnull (^)(UIView * _Nullable (^ _Nullable)(void)))addCustomActionViewBK {
    return ^ZLPopViewBuilder *(UIView *(^viewBK)(void)){
        if (viewBK) {
            UIView *view = viewBK();
            return [self addCustomActionView:view handler:nil];
        }
        return self;
    };
}
- (ZLPopViewBuilder * _Nonnull (^)(BOOL, UIView * _Nonnull, void (^ _Nullable)(UIView * _Nonnull)))addCustomViewActionIf {
    
    return ^ZLPopViewBuilder *(BOOL isAdd,UIView *view, void(^action)(UIView *view)){
        return isAdd ? self.addCustomViewAction(view,action) : self;
    };
}
///添加默认样式view 可通过defaultButtonViewBK 设置默认的buttonView样式
- (instancetype)addButtonStyleActionViewText:(NSString *)text handler:(void(^)(UIView *view))action{
    UIView *view = self.class.defaultButtonViewBK(self,text);
    [self addCustomActionView:view handler:action];
    return self;
}
- (ZLPopViewBuilder * _Nonnull (^)(NSString * _Nonnull, void (^ _Nonnull)(UIView * _Nonnull)))addButtonViewStyleActionText {
    return ^ZLPopViewBuilder *(NSString *text, void(^action)(UIView *view)){
        return [self addButtonStyleActionViewText:text handler:action];
    };
}
- (instancetype)addDeleteStyleActionViewText:(NSString *)text handler:(void(^)(UIView *view))action {
    UIView *view = self.class.defaultDeleteViewBK(self,text);
    [self addCustomActionView:view handler:action];
    return self;
}
- (ZLPopViewBuilder * _Nonnull (^)(NSString * _Nonnull, void (^ _Nonnull)(UIView * _Nonnull)))addDeleteViewStyleActionText {
    return ^ZLPopViewBuilder *(NSString *text, void(^action)(UIView *view)){
        return [self addDeleteStyleActionViewText:text handler:action];
    };
}
- (instancetype)addConfirmStyleActionViewText:(NSString *)text handler:(void(^)(UIView *view))action {
    UIView *view = self.class.defaultConfirmViewBK(self,text);
    [self addCustomActionView:view handler:action];
    return self;
}
- (ZLPopViewBuilder * _Nonnull (^)(NSString * _Nonnull, void (^ _Nonnull)(UIView * _Nonnull)))addConfirmViewStyleActionText {
    return ^ZLPopViewBuilder *(NSString *text, void(^action)(UIView *view)){
        return [self addConfirmStyleActionViewText:text handler:action];
    };
}
- (instancetype)addCancelStyleActionView:(UIView *)view handler:(void(^)(UIView *view))action {
    self.cancelView = view;
    self.cancelViewIdx = self.customActionViews.count;
    [self configureActionView:view action:action];
    return self;
}
- (ZLPopViewBuilder * _Nonnull (^)(void (^ _Nonnull)(UIView * _Nonnull)))addCancelViewStyleAction {
    return ^ZLPopViewBuilder *(void(^action)(UIView *view)){
        return [self addCancelStyleActionViewText:@"取消" handler:action];
    };
}
- (instancetype)addCancelStyleActionViewText:(NSString *)text handler:(void(^)(UIView *view))action {
    UIView *view = self.class.defaultCancelViewBK(self,text);
    self.cancelView = view;
    self.cancelViewIdx = self.customActionViews.count;
    BOOL dismiss = self.dismissWhenTapActionView;
    if ([view isKindOfClass:UIButton.class]) {
        UIButton *btn = (UIButton *)view;
        btn.kfc.addTouchUpAction(^(UIButton * _Nonnull button) {
            if (action) action(button);
            if (dismiss) {
                button.kfc.dismissPopView();
            }
        });
    }else if ([view isKindOfClass:UIView.class]) {
        view.kfc.addTapAction(^(UIView * _Nonnull view) {
            if (action) action(view);
            if (dismiss) {
                view.kfc.dismissPopView();
            }
        });
    }
    return self;
}
- (ZLPopViewBuilder * _Nonnull (^)(NSString * _Nonnull, void (^ _Nonnull)(UIView * _Nonnull)))addCancelViewStyleActionText {
    return ^ZLPopViewBuilder *(NSString *text, void(^action)(UIView *view)){
        return [self addCancelStyleActionViewText:text handler:action];
    };
}
- (void (^)(void))showActionSheet {
    self.alertType = 2;
    UIEdgeInsets marge = self.configObj.marge;
    CGFloat defaultSpace = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? UIScreen.mainScreen.bounds.size.width * 0.25 : 8;
    CGFloat bottomSpace = 8;
    if (!self.configObj.orientationChangeBk) {
        self.orientationChangeBK(^(ZLLayoutConstraintObj * _Nonnull constraintObj, ZLBuildConfigObj * _Nonnull configureObj, BOOL isLandscape) {
            if (isLandscape) {
                CGFloat marge = 0;
                if (kZLSafeAreaBottom > 0 || kZLSafeAreaTop > 0 || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    marge = UIScreen.mainScreen.bounds.size.width * 0.33;
                }else {
                    marge = (UIScreen.mainScreen.bounds.size.width - UIScreen.mainScreen.bounds.size.height) / 2.0;
                }
                constraintObj.margeLeadingCons.constant = marge;
                constraintObj.margeTrailingCons.constant = -marge;
            }else {
                constraintObj.margeLeadingCons.constant = configureObj.marge.left;
                constraintObj.margeTrailingCons.constant = configureObj.marge.right;
            }
        });
    }
    self
        .shadowColor(UIColor.clearColor)
        .insetAll(0)
        .horizontalLayoutConstraint(ZLHorizontalLayoutConstraintFill)
        .marge(0, marge.left > 0 ? marge.left : defaultSpace, -marge.bottom > 0 ? -marge.bottom : (kZLSafeAreaBottom + bottomSpace), -marge.right > 0 ? -marge.right : defaultSpace);
    return ^{
        self.showBottomPopView();
    };
}
- (void (^)(void))showWXActionSheet {
    self.alertType = 3;
    UIColor *spaceColor = self._separatorColor ?: ZLPopViewBuilder.defaultSeparatorColor;
    self.spaceViewColor(self._spaceViewColor ?: [spaceColor colorWithAlphaComponent:0.5])
        .shadowColor(UIColor.clearColor)
        .horizontalLayoutConstraint(ZLHorizontalLayoutConstraintFill)
        .corners(UIRectCornerTopLeft | UIRectCornerTopRight)
        .margeAll(0);
    return ^{
        self.showBottomPopView();
    };
}
- (void (^)(void))showAlert {
    self.alertType = 1;
    if (self.configObj.width <= 0 && self.configObj.maxWidthMultiplier <= 0) {
        [self.alertWidth270 horizontalLayoutConstraintCenter];
    }
    return ^{
        self.showCenterPopView();
    };
}
@end
