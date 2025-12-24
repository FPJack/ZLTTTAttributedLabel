//
//  UITextImageView.h
//  GMPopView_Example
//
//  Created by admin on 2025/11/5.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+kfc.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, UIImagePosition) {
    UIImagePositionStart = 0,
    UIImagePositionEnd,
    UIImagePositionTop,
    UIImagePositionBottom
};
typedef NS_ENUM(NSUInteger, UITextImageState) {
    UITextImageStateNormal = 0,
    UITextImageStateDisabled,
    UITextImageStateSelected,
};

typedef NS_ENUM(NSInteger, UITextImageCrossAxisAlignment) {
    UITextImageCrossAxisAlignmentStart,
    UITextImageCrossAxisAlignmentEnd,
    UITextImageCrossAxisAlignmentCenter,
    UITextImageCrossAxisAlignmentFirstBaseline,
    UITextImageCrossAxisAlignmentLastBaseline,
};


@interface UITextImageView<__covariant ViewModelType> : UIView
@property (nonatomic,copy,readonly,class)UITextImageView* (^text)(NSString *text);
@property (nonatomic,copy,readonly,class)UITextImageView* (^image)(id imageOrName);
@property (nonatomic,copy,readonly,class)UITextImageView* (^initStateBk)(void(^)(UITextImageView *view));

///文字
@property (nonatomic,strong,readonly)UILabel *textLabel;
@property (nonatomic,copy,readonly)UITextImageView* (^text)(NSString *text);
@property (nonatomic,copy,readonly)UITextImageView* (^attributedText)(NSAttributedString *attributedText);
@property (nonatomic,copy,readonly)UITextImageView* (^textColor)(id colorOrHex);
@property (nonatomic,copy,readonly)UITextImageView* (^textFontSize)(CGFloat fontSize);
@property (nonatomic,copy,readonly)UITextImageView* (^textMediumFontSize)(CGFloat fontSize);

///图片
@property (nonatomic,strong,readonly)UIImageView *imageView;
@property (nonatomic,copy,readonly)UITextImageView* (^image)(id imageOrName);


///绘制的背景图片
@property (nonatomic,copy,readonly)UITextImageView* (^bgImage)(id imageOrName);
///背景图片显示模式
@property (nonatomic, assign) UIViewContentMode bgImageContentMode;
/// 背景内容边距
@property (nonatomic, assign) UIEdgeInsets bgContentInsets;


/// 内边距
@property (nonatomic,copy,readonly)UITextImageView* (^padding)(CGFloat top,CGFloat leading,CGFloat bottom,CGFloat trailing);
@property (nonatomic,copy,readonly)UITextImageView* (^paddingVH)(CGFloat V,CGFloat H);
@property (nonatomic,copy,readonly)UITextImageView* (^paddingVerTB)(CGFloat top,CGFloat bottom);
@property (nonatomic,copy,readonly)UITextImageView* (^paddingHorLT)(CGFloat leading,CGFloat trailing);



/// 图片位置
@property (nonatomic,copy,readonly)UITextImageView* (^postion)(UIImagePosition position);
/// 图片位置快捷方法
- (instancetype)imageStart;
- (instancetype)imageEnd;
- (instancetype)imageTop;
- (instancetype)imageBottom;

/// 设置状态，触发相对应的block回调进行配置
@property (nonatomic, copy,readonly)UITextImageView* (^state)(UITextImageState state);
/// 图片和文字之间的间距
@property (nonatomic,copy,readonly) UITextImageView* (^space)(CGFloat spacing);

/// 是否在图片和文字之间添加弹性间距，默认为NO,设置为YES时图片和文字会分别靠近两边显示，spacing属性无效
@property (nonatomic, assign) BOOL addFlexibleSpacing;
/// 文字和图片在交叉轴上的对齐方式
@property (nonatomic, assign) UITextImageCrossAxisAlignment textImageCrossAlignment;
/// 初始化回调,只调用一次
@property (nonatomic,copy,readonly)UITextImageView* (^initStateBk)(void(^)(UITextImageView *view));
///normal state configure block
@property (nonatomic,copy,readonly)UITextImageView* (^configureBK)(void(^)(UITextImageView *view));
///disabled state configure block
@property (nonatomic,copy,readonly)UITextImageView* (^disabledConfigureBK)(void(^)(UITextImageView *view));
///selected state configure block
@property (nonatomic,copy,readonly)UITextImageView* (^selectedConfigureBK)(void(^)(UITextImageView *view));
///布局子视图回调
@property (nonatomic,copy,readonly)UITextImageView* (^layoutSubviewBK)(void(^)(UITextImageView *view));
///点击事件回调
@property (nonatomic,copy,readonly)UITextImageView* (^tapActionBK)(void(^)(UITextImageView *view));
///viewModel
@property (nonatomic,strong)ViewModelType _Nullable viewModel;
///viewModel类型
@property (nonatomic,copy,readonly)UITextImageView* (^updateViewModelBK)(void(^)(UITextImageView *view,id _Nullable viewModel));
///手动调用刷新viewModel对应的updateViewModelBK回调
- (void)updateViewModel:(ViewModelType _Nullable)viewModel;
@end
NS_ASSUME_NONNULL_END
