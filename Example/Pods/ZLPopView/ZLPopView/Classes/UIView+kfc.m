//
//  UIView+kfc.m
//  GMPopView
//
//  Created by admin on 2025/9/12.
//

#import "UIView+kfc.h"
#import <objc/runtime.h>
#import "ZLBaseConfigure.h"
#define kRGBHexColor(hex) [UIColor colorWithRed:((CGFloat)((hex >> 16) & 0xFF)/255.0) green:((CGFloat)((hex >> 8) & 0xFF)/255.0) blue:((CGFloat)(hex & 0xFF)/255.0) alpha:1.0]
#define kRGBAHexColor(hex) [UIColor colorWithRed:((CGFloat)((hex >> 16) & 0xFF)/255.0) green:((CGFloat)((hex >> 8) & 0xFF)/255.0) blue:((CGFloat)(hex & 0xFF)/255.0) alpha:1.0]
static inline UIColor *_UIColorFromHexString(NSString *hexStr) {
    hexStr = [hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([hexStr hasPrefix:@"0x"])hexStr = [hexStr substringFromIndex:2];
    if([hexStr hasPrefix:@"#"])hexStr = [hexStr substringFromIndex:1];
    unsigned int hexInt = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    [scanner scanHexInt:&hexInt];
    return hexStr.length > 6 ? kRGBAHexColor(hexInt) : kRGBHexColor(hexInt);
}
@implementation NSString(colorWithHexString)
- (UIColor *)hexColor {
    return _UIColorFromHexString(self);
}
@end
@implementation UIColor (kfc)
- (UIImage *)image {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIColor * _Nonnull (^)(CGFloat))alphaFactor {
    return ^(CGFloat alpha){
        return [self colorWithAlphaComponent:alpha];
    };
}
+ (UIColor *)black10 {
    return [UIColor.blackColor colorWithAlphaComponent:0.1];
}
+ (UIColor *)black20 {
    return [UIColor.blackColor colorWithAlphaComponent:0.2];
}
+ (UIColor *)black50 {
    return [UIColor.blackColor colorWithAlphaComponent:0.5];
}
+ (UIColor *)black60 {
    return [UIColor.blackColor colorWithAlphaComponent:0.7];
}
+ (UIColor *)black70 {
    return [UIColor.blackColor colorWithAlphaComponent:0.6];
}
+ (UIColor *)black80 {
    return [UIColor.blackColor colorWithAlphaComponent:0.8];
}
+ (UIColor *)black100 {
    return UIColor.blackColor;
}
@end

@interface GMStrongView: NSObject
@property (nonatomic,strong)NSMutableSet *set;
@property (nonatomic,assign)BOOL isObserver;
@end
@implementation GMStrongView
+ (instancetype)sharedInstance {
    static GMStrongView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GMStrongView alloc] init];
        instance.set = NSMutableSet.new;
    });
    return instance;
}
- (void)keepAliveUntilRunloopEnd:(UIView *)view {
    if (!view || ![view isKindOfClass:UIView.class]) return;
    [self.set addObject:view];
    if (self.isObserver) return;
    self.isObserver = YES;
    CFRunLoopRef runLoop = CFRunLoopGetMain();
        CFRunLoopActivity activity = kCFRunLoopBeforeWaiting;
        CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(
            kCFAllocatorDefault,
            activity,
            false,
            0,
            ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
                CFRunLoopRemoveObserver(runLoop, observer, kCFRunLoopCommonModes);
                [self.set removeAllObjects];
                self.isObserver = NO;
            }
        );
        CFRunLoopAddObserver(runLoop, observer, kCFRunLoopCommonModes);
}
@end


@implementation UIView (configure)
- (ZLUIViewConfigure *)__createKfc {
    Class configureCls = ZLUIViewConfigure.class;
    if ([self isKindOfClass:UIButton.class]) {
        configureCls = ZLUIButtonConfigure.class;
    }else if ([self isKindOfClass:UILabel.class]) {
        configureCls = ZLUILabelConfigure.class;
    }else if ([self isKindOfClass:UIImageView.class]) {
        configureCls = ZLUIImageViewConfigure.class;
    }else if ([self isKindOfClass:UITextField.class]) {
        configureCls = ZLUITextFieldConfigure.class;
    }else if ([self isKindOfClass:UITextView.class]) {
        configureCls = ZLUITextViewConfigure.class;
    }else if ([self isKindOfClass:UIStackView.class]) {
        configureCls = ZLUIStackViewConfigure.class;
    }else if ([self isKindOfClass:UISwitch.class]) {
        configureCls = ZLUISwitchConfigure.class;
    }else if ([self isKindOfClass:UIScrollView.class]) {
        configureCls = ZLUIScrollViewConfigure.class;
    }else if ([self isKindOfClass:UIView.class]) {
        configureCls = ZLUIViewConfigure.class;
    }
    if (configureCls && [configureCls isSubclassOfClass:ZLBaseConfigure.class]){
        return [configureCls configureWithView:self];
    }
    return [ZLUIViewConfigure configureWithView:self];
}
- (ZLUIViewConfigure *)kfc {
    ZLUIViewConfigure *kfc = objc_getAssociatedObject(self, @selector(kfc));
    if (!kfc) {
        kfc = [self __createKfc];
        [self setKfc:kfc];
    }
    return kfc;
}
+ (ZLUIViewConfigure *)kfc {
    UIView *view = [[self alloc] init];
    return view.kfc;
}
- (void)setKfc:(ZLBaseConfigure *)kfc {
    if ([kfc isKindOfClass:ZLBaseConfigure.class]) {
        [self setKfcCreated:YES];
        [GMStrongView.sharedInstance keepAliveUntilRunloopEnd:self];
        objc_setAssociatedObject(self, @selector(kfc), kfc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
- (BOOL)kfcCreated{
    return objc_getAssociatedObject(self, @selector(kfcCreated)) != nil;
}
- (void)setKfcCreated:(BOOL)kfcCreated {
    objc_setAssociatedObject(self, @selector(kfcCreated), @(kfcCreated), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView * _Nonnull (^)(void (^ _Nonnull)(UIView * _Nonnull)))kfcTapAction {
    return ^(void (^block)(UIView *view)){
        self.kfc.tapAction(block);
        return self;
    };
}
- (UIView * _Nonnull (^)(void (^ _Nonnull)(UIView * _Nonnull)))kfcAddTapAction {
    return ^(void (^block)(UIView *view)){
        self.kfc.addTapAction(block);
        return self;
    };
}
@end

@implementation UIButton (configure)
+ (ZLUIButtonConfigure *)kfc {
    UIButton *button = [self customTypeButton];
    return button.kfc;
}
+ (instancetype )customTypeButton {
    return [self buttonWithType:UIButtonTypeCustom];
}
- (UIButton * _Nonnull (^)(void (^ _Nonnull)(UIButton * _Nonnull)))kfcTouchUpAction {
    return ^(void (^block)(UIButton *btn)){
        self.kfc.touchUpAction(block);
        return self;
    };
}
- (UIButton * _Nonnull (^)(void (^ _Nonnull)(UIButton * _Nonnull)))kfcAddTouchUpAction{
    return ^(void (^block)(UIButton *btn)){
        self.kfc.addTouchUpAction(block);
        return self;
    };
}
@end
