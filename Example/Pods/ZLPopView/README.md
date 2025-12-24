# ZLPopView

ZLPopView是一个基于UIStackView布局展示各种自定义视图的库。在系统UIStackView布局的基础上扩展了弹性布局.
同时封装了多种弹出视图展示方式，支持多种弹出样式（顶部、底部、左侧、右侧、中间、气泡等），并且支持键盘避免遮挡，拖拽关闭，点击遮罩关闭等功能。方便开发者快速创建各种自定义弹窗视图。
1. 支持水平和垂直布局
2. 支持内边距和间距设置
3. 支持分割线设置
4. 支持弹出视图展示和配置
5. 支持键盘避免遮挡
6. 支持拖拽关闭和点击遮罩关闭
7. 支持多种弹出样式（顶部、底部、左侧、右侧、中间、气泡等）
8. 支持默认样式配置，方便全局统一设置弹窗样式
9. 支持快捷弹窗创建（类似系统Alert和ActionSheet和微信）
10.支持手势穿透
11.支持手势冲突处理
12.支持自定义动画
13.支持内容视图自动适应屏幕大小，超出屏幕时自动滚动显示
14.支持设置阴影圆角背景色等属性
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements



<img src="https://github.com/FPJack/ZLPopView/blob/master/IMG_4774.GIF" width="40%" height="40%">   <img src="https://github.com/FPJack/ZLPopView/blob/master/IMG_4775.GIF" width="40%" height="40%">
<img src="https://github.com/FPJack/ZLPopView/blob/master/IMG_4776.GIF" width="40%" height="40%">   <img src="https://github.com/FPJack/ZLPopView/blob/master/IMG_4777.GIF" width="40%" height="40%">



## Installation

```ruby
pod 'ZLPopView'
```



## UIStackView 布局 更多请参考  ZLStackViewBuilder.h 文件和demo
```ruby
UIView *view  = ZLStackViewBuilder
            //水平布局
             //.row
            //垂直布局 
            .column
            //设置间距
            .space(10)
            //设置分布方式
            .distribution(ZLMainAxisAlignmentStart)
            //设置对齐方式
            .alignment(UIStackViewAlignmentTop)
            //设置内边距
            .padding(10, 10, 10, 10)
            //设置分割线颜色
            .separatorColor(UIColor.lightGrayColor)
            //设置分割线粗细
            .separatorThickness(0.5)
            //添加子视图View
            .addView(UILabel.kfc.text(@"UIStackView布局方式 添加Label"))
            //视图View之间插入间距,可以覆盖全局space设置
            .customSpace(20)
            .addView(UILabel.kfc.text(@"UIStackView布局方式 添加Label"))
            //添加弹性空间View
            .addFlexSpaceView()
            //Block添加子视图View
            .addViewBK(^ViewKFCType  _Nonnull{
                return UILabel.kfc.text(@"UIStackView布局方式 添加Label");
            })
            .addViewBK(^ViewKFCType  _Nonnull{
                return UILabel.kfc.text(@"UIStackView布局方式 添加Label");
            })
            //生成UIScrollView,超出固定高度时可以滚动显示
            .buildScrollView
            //生成UIStackView
            .buildStackView;
```

## ZLPopViewBuilder继承自ZLStackViewBuilder,更多请参考  ZLPopViewBuilder.h 文件和demo
```ruby
    ZLPopBaseView *popView = ZLPopViewBuilder
                    //水平布局
                     //.row
                    //垂直布局
                    .column
                    //设置间距
                    .space(10)
                    //设置整个容器的四边距，包括背景弹出视图与屏幕边缘的距离
                    .popViewMarge(10, 10, 10, 10)
                    //设置内容视图的内边距
                    .inset(10, 10, 10, 10)
                    //设置内容视图与弹出容器的边距
                    .marge(10, 10, 10, 10)
                    //包裹UIScrollView
                    .wrapScrollView
                    //生成UIScrollView,超出固定高度时可以滚动显示
                    .enableScrollWhenOutBounds
                    //设置固定宽高
                    .width(300)
                    //设置固定高度
                    .height(400)
                    //设置最大宽高
                    .maxWidth(350)
                    //设置最大高度
                    .maxHeight(500)
                    //设置最大宽度比例
                    .maxWidthMultiplier(0.9)
                    //设置最大高度比例
                    .maxHeightMultiplier(0.8)
                    //设置宽度比例
                    .widthMultiplier(0.8)
                    //设置高度比例
                    .heightMultiplier(0.5)
                    //事件穿透，不阻挡底部触摸事件
                    .touchPenetrate
                    //启用拖拽关闭
                    .enableDragDismiss
                    //添加拖拽手势
                    .addDragGesture
                    //拖拽超过指定距离关闭
                    .dragDismissIfGreaterThanDistance(50)
                    //点击遮罩关闭
                    .tapMaskDismiss
                    //弹出动画时间
                    .animateIn(0.25)
                    //关闭动画时间
                    .animateOut(0.25)
                    //设置圆角
                    .corners(UIRectCornerAllCorners)
                    //设置圆角半径
                    .cornerRadius(10)
                    //设置阴影
                    .shadowColor(UIColor.blackColor)
                    //设置阴影半径
                    .shadowRadius(5)
                    //设置阴影偏移量
                    .shadowOffset(CGSizeMake(0, 0))
                    //设置阴影透明度
                    .shadowOpacity(0.2)
                    //设置遮罩颜色
                    .maskColor([UIColor.blackColor colorWithAlphaComponent:0.3])
                    //设置背景颜色
                    .backgroundColor(UIColor.whiteColor)
                    //避免键盘遮挡类型
                    .avoidKeyboardType(ZLAvoidKeyboardTypeFirstResponder)
                    //键盘弹出时底部距离键盘顶部的间距
                    .bottomOffsetToKeyboardTop(10)
                    //弹出视图添加到指定视图上
                    //.popSuperView(viewcontroller.view)
                    //设置分布方式
                    .distribution(ZLMainAxisAlignmentStart)
                    //设置对齐方式
                    .alignment(UIStackViewAlignmentTop)
                    //设置内边距
                    .padding(10, 10, 10, 10)
                    //设置分割线颜色
                    .separatorColor(UIColor.lightGrayColor)
                    //设置分割线粗细
                    .separatorThickness(0.5)
                    //添加子视图View
                    .addView(UILabel.kfc.text(@"UIStackView布局方式 添加Label"))
                    //视图View之间插入间距,可以覆盖全局space设置
                    .customSpace(20)
                    .addView(UILabel.kfc.text(@"UIStackView布局方式 添加Label"))
                    //添加弹性空间View
                    .addFlexSpaceView()
                    //Block添加子视图View
                    .addViewBK(^ViewKFCType  _Nonnull{
                        return UILabel.kfc.text(@"UIStackView布局方式 添加Label");
                    })
                    .addViewBK(^ViewKFCType  _Nonnull{
                        return UILabel.kfc.text(@"UIStackView布局方式 添加Label");
                    })
                    //自定义进场动画
                    .animationInBK(^(ZLPopBaseView * _Nonnull popView, ZLCompeteBlock  _Nonnull complete) {
                        popView.containerView.transform = CGAffineTransformMakeTranslation(0, -self.view.bounds.size.height);
                        popView.backgroundColor = UIColor.clearColor;
                        [UIView animateWithDuration:1
                                              delay:0.0
                             usingSpringWithDamping:0.6
                              initialSpringVelocity:0.8
                                            options:UIViewAnimationOptionCurveEaseOut
                                         animations:^{
                            popView.containerView.transform = CGAffineTransformIdentity;
                            popView.backgroundColor = popView.configObj.maskColor;
                        } completion:^(BOOL finished) {
                            complete(finished);
                        }];
                    })
                    //自定关闭动画
                    .animationOutBK(^(ZLPopBaseView * _Nonnull popView, ZLCompeteBlock  _Nonnull complete) {
                        [UIView animateWithDuration:0.5 animations:^{
                            popView.containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                            popView.backgroundColor = UIColor.clearColor;
                        } completion:^(BOOL finished) {
                            complete(finished);
                        }];
                    })
                    //屏幕右侧弹出
                    .buildRightPopView
                    //屏幕左侧弹出
                    //.buildLeftPopView
                    //屏幕中间弹出
                    //.buildCenterPopView
                    //屏幕底部弹出
                    //.buildBottomPopView
                    //屏幕顶部弹出
                    //.buildTopPopView;
    //设置代理（监听页面生命周期）并显示
    popView.delegate(self).showPopView();

```
    
## ZLPopOverView 更多请参考  ZLPopOverView.h 文件和demo    
```ruby
    支持横竖屏自动调整位置和方向，支持设置背景渐变色，支持设置背景图片，支持设置箭头宽高，支持设置安全区域间距等功能
    
                    ZLPopViewBuilder
                    .column
                    //添加子视图View
                    .addView(UILabel.kfc.text(@"UIStackView布局方式 添加Label"))
                    //视图View之间插入间距,可以覆盖全局space设置
                    .addView(UILabel.kfc.text(@"UIStackView布局方式 添加Label"))
                    //构建ZLPopOverView
                    .buildPopOverView
                    //设置在哪个view周边弹出
                    .setFromView(UIButton.new)
                    //设置弹出点位置
                    .setPoint(CGPointMake(100, 100))
                    //设置箭头指向弹出点的距离
                    .setSpaceToPoint(5)
                    //设置箭头宽度
                    .setArrowWidth(20)
                    //设置箭头高度
                    .setArrowHeight(10)
                    //设置PopOverView四周安全区域间距
                    .setSafeAreaMarge(UIEdgeInsetsMake(10, 10, 10, 10))
                    //设置PopOverView箭头方向
                    .setDirection(ZLPopOverDirectionAuto)
                    //显示PopOverView
                    .showPopView();
```

## 快捷弹窗
```ruby

        kPopViewColumnBuilder
        .title(@"标题")
        .message(@"这是展示的内容")
        .addTextField(^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入内容";
        })
        .addCancelViewStyleActionText(@"取消", ^(UIView * _Nonnull view) {
            
        })
        .addConfirmViewStyleActionText(@"确认", ^(UIView * _Nonnull view) {
            
        })
        //微信样式弹窗
        .showWXActionSheet
        //系统样式弹窗
        .showActionSheet
        //系统Alert
        .showAlert;
```  


## 默认样式配置                  
``` ruby
    BOOL isDark = self.isDark;
    //默认弹窗属性配置
    ZLPopViewBuilder.defaultConfigureBK = ^(ZLBuildConfigObj * _Nonnull configure) {
        configure.tapMaskDismiss = YES;
        configure.enableDragDismiss = YES;
        configure.shadowColor = UIColor.blackColor;
        configure.shadowOpacity = 0.2;
        configure.cornerRadius = 10;
        configure.corners = UIRectCornerAllCorners;
        configure.tapMaskDismiss = YES;
        configure.enableDragDismiss = YES;
        configure.backgroundColor = isDark ? DARK_BG_COLOR : LIGHT_BG_COLOR;
    };
    
    //默认线条样式配置
    ZLPopViewBuilder.defaultSeparatorColor = isDark ? DARK_LINE_COLOR : LIGHT_LINE_COLOR;
    ZLPopViewBuilder.defaultSeparatorThickness = 0.5;
    
    
    //返回自定义展示Title的UILabel
    ZLPopViewBuilder.defaultTitleLabelBK = ^UILabel * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
        return kTitleStyleLabel(text).kfc.textColor(isDark ? DARK_TITLE_COLOR : LIGHT_TITLE_COLOR).margeHorizontal(10).view;
    };
    
    //返回自定义展示Message的UILabel
    ZLPopViewBuilder.defaultMessageLabelBK = ^UILabel * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
        return kSubTitleStyleLabel(text).kfc.textColor(isDark ? DARK_SUBTITLE_COLOR : LIGHT_SUBTITLE_COLOR).margeHorizontal(10).view;
    };
    
    //返回自定义展示AttributedMessage的UILabel
    ZLPopViewBuilder.defaultAttributedViewBK = ^(ZLPopViewBuilder *builder, NSAttributedString *attributedString){
        return UILabel.new.kfc
            .multipleLines
            .spacing(32)
            .frontSpacing(10)
            .margeHorizontal(10)
            .attributedText(attributedString)
            .view;
    };
    
    //返回自定义展示TextField的UITextField
    ZLPopViewBuilder.defaultTextFieldViewBK = ^UITextField * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull placeholder) {
        return UITextField.new.kfc
            .leftPadding(10)
            .placeholder(placeholder)
            .spacing(15)
            .clearButtonMode(UITextFieldViewModeWhileEditing)
            .returnKeyType(UIReturnKeyDone)
            .keyboardType(UIKeyboardTypeDefault)
            .borderWidth(0.5)
            .borderColor(UIColor.lightGrayColor)
            .cornerRadius(5)
            .margeHorizontal(15)
            .height(40)
            .view;
    };
    
    
    UIColor *highlightBgColor = isDark ? [UIColor.darkGrayColor colorWithAlphaComponent:0.5] : [UIColor.lightGrayColor colorWithAlphaComponent:0.1];
    //返回自定义展示删除样式按钮的UIView
    ZLPopViewBuilder.defaultDeleteViewBK = ^UIView * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
        UIColor *color = isDark ? DARK_DESTRUCTIVE_COLOR : LIGHT_DESTRUCTIVE_COLOR;
        return kDeleteStyleBtn.kfc.title(text)
            .titleColor(color)
            .highlightBgColor(highlightBgColor)
            .view;
    };
    
    //返回自定义展示确认样式按钮的UIView
    ZLPopViewBuilder.defaultConfirmViewBK = ^UIView * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
        UIColor *color = isDark ? DARK_BUTTON_COLOR : LIGHT_BUTTON_COLOR;
        return kConfirmStyleBtn.kfc
            .title(text)
            .titleColor(color)
            .highlightBgColor(highlightBgColor)
            .view;
    };
    
    //返回自定义展示普通样式按钮的UIView
    ZLPopViewBuilder.defaultButtonViewBK = ^UIView * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
        UIColor *color = isDark ? DARK_BUTTON_COLOR : LIGHT_BUTTON_COLOR;
        return kConfirmStyleBtn.kfc.title(text)
            .titleColor(color)
            .highlightBgColor(highlightBgColor)
            .view;
    };
    
    //返回自定义展示取消样式按钮的UIView
    ZLPopViewBuilder.defaultCancelViewBK = ^UIView * _Nullable(ZLPopViewBuilder * _Nonnull builder, NSString * _Nonnull text) {
        UIColor *color = isDark ? DARK_CANCEL_COLOR : LIGHT_CANCEL_COLOR;
        return kCancelStyleBtn.kfc
            .title(text)
            .titleColor(color)
            .highlightBgColor(highlightBgColor)
            .view;
    };
```        

## Author

fanpeng, 2551412939@qq.com

## License

ZLPopView is available under the MIT license. See the LICENSE file for more info.
