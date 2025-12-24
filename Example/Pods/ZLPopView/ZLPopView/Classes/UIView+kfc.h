//
//  UIView+kfc.h
//  GMPopView
//
//  Created by admin on 2025/9/12.
//

#import <UIKit/UIKit.h>
#import "ZLBaseConfigure.h"
@class ZLPopBaseView,ZLViewConfigObj,ZLUIScrollView,ZLBaseConfigure,ZLUILabelConfigure,ZLUITextFieldConfigure,ZLUIButtonConfigure,ZLUIImageViewConfigure,ZLUIViewConfigure,ZLUITextViewConfigure,ZLUISwitchConfigure,ZLUISliderConfigure,ZLUIStackViewConfigure,ZLSeparatorView;
NS_ASSUME_NONNULL_BEGIN
static inline UIColor * __UIColorFromObj(NSObject * obj);
@interface NSString(colorWithHexString)
- (UIColor *)hexColor;
@end
@interface UIColor (kfc)
- (UIImage *)image;
///透明系数
@property (nonatomic,readonly)UIColor *(^alphaFactor)(CGFloat factor);
+ (UIColor *)black10;
+ (UIColor *)black20;
+ (UIColor *)black50;
+ (UIColor *)black60;
+ (UIColor *)black70;
+ (UIColor *)black80;
+ (UIColor *)black100;
@end
@interface UIView (kfc)
@property (nonatomic,strong,readonly)ZLUIViewConfigure *kfc;
@property (nonatomic,strong,readonly,class)ZLUIViewConfigure *kfc;
///是否已经创建了kfc对象
@property (nonatomic,assign,readonly)BOOL kfcCreated;

@end
@interface UILabel(kfc)
@property (nonatomic,strong,readonly)ZLUILabelConfigure *kfc;
@property (nonatomic,strong,readonly,class)ZLUILabelConfigure *kfc;
@end
@interface UITextField(kfc)
@property (nonatomic,strong,readonly)ZLUITextFieldConfigure *kfc;
@property (nonatomic,strong,readonly,class)ZLUITextFieldConfigure *kfc;
@end
@interface UITextView(kfc)
@property (nonatomic,strong,readonly)ZLUITextViewConfigure *kfc;
@property (nonatomic,strong,readonly,class)ZLUITextViewConfigure *kfc;
@end
@interface UIScrollView(kfc)
@property (nonatomic,strong,readonly)ZLUIScrollViewConfigure *kfc;
@property (nonatomic,strong,readonly,class)ZLUIScrollViewConfigure *kfc;
@end
@interface UIButton (kfc)
@property (nonatomic,strong,readonly)ZLUIButtonConfigure *kfc;
@property (nonatomic,strong,readonly,class)ZLUIButtonConfigure *kfc;

+ (instancetype )customTypeButton;
@end
@interface UIImageView(kfc)
@property (nonatomic,strong,readonly)ZLUIImageViewConfigure *kfc;
@property (nonatomic,strong,readonly,class)ZLUIImageViewConfigure *kfc;
@end
@interface UISwitch(kfc)
@property (nonatomic,strong,readonly)ZLUISwitchConfigure *kfc;
@property (nonatomic,strong,readonly,class)ZLUISwitchConfigure *kfc;
@end
@interface UISlider(kfc)
@property (nonatomic,strong,readonly)ZLUISliderConfigure *kfc;
@property (nonatomic,strong,readonly,class)ZLUISliderConfigure *kfc;
@end
@interface UIStackView(kfc)
@property (nonatomic,strong,readonly)ZLUIStackViewConfigure *kfc;
@property (nonatomic,strong,readonly,class)ZLUIStackViewConfigure *kfc;
@end

@interface UITableView(kfc)
@property (nonatomic,strong,readonly)ZLBaseConfigure<ZLUIViewConfigure *,UITableView *> *kfc;
@property (nonatomic,strong,readonly,class)ZLBaseConfigure<ZLUIViewConfigure *,UITableView *> *kfc;
@end
@interface UICollectionView(kfc)
@property (nonatomic,strong,readonly)ZLBaseConfigure<ZLUIViewConfigure *,UICollectionView *> *kfc;
@property (nonatomic,strong,readonly,class)ZLBaseConfigure<ZLUIViewConfigure *,UICollectionView *> *kfc;
@end
@interface GMUIContainerView(kfc)
@property (nonatomic,strong,readonly)ZLBaseConfigure<ZLUIViewConfigure *,GMUIContainerView *> *kfc;
@property (nonatomic,strong,readonly,class)ZLBaseConfigure<ZLUIViewConfigure *,GMUIContainerView *> *kfc;
@end

static inline UIColor * __UIColorFromObj(NSObject * obj) {
    if ([obj isKindOfClass:UIColor.class]) return (UIColor *)obj;
    if ([obj isKindOfClass:NSString.class]) return ((NSString *)obj).hexColor;
    return nil;
}
NS_ASSUME_NONNULL_END


