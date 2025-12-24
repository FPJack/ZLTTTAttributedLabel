//
//  UITextImageView.m
//  GMPopView_Example
//
//  Created by admin on 2025/11/5.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "UITextImageView.h"
#import "UIView+kfc.h"

static inline CGRect CGRectInsetWithEdgeInsets(CGRect rect, UIEdgeInsets insets) {
    return CGRectMake(rect.origin.x + insets.left,
                      rect.origin.y + insets.top,
                      rect.size.width - insets.left - insets.right,
                      rect.size.height - insets.top - insets.bottom);
}

@interface UITextImageView ()
@property (nonatomic,strong,readwrite)UILabel *textLabel;
@property (nonatomic,strong,readwrite)UIImageView *imageView;
@property (nonatomic,strong)UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic,copy)void (^initStateBlock)(UITextImageView *view);
@property (nonatomic,copy)void (^configureBlock)(UITextImageView *view);
@property (nonatomic,copy)void (^disabledConfigureBlock)(UITextImageView *view);
@property (nonatomic,copy)void (^selectedConfigureBlock)(UITextImageView *view);
@property (nonatomic,copy)void (^tapActionBlock)(UITextImageView *view);
@property (nonatomic,copy)void (^layoutSubviewBlock)(UITextImageView *view);
@property (nonatomic,copy)void (^updateViewModelBlock)(UITextImageView *view, id viewModel);
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, strong) UIImage *BGImage;
@property (nonatomic, assign) UIImagePosition imagePosition;
@property (nonatomic, assign) UITextImageState viewState;

@property (nonatomic,strong)UIView *flexibleView;
/// 图片和文字之间的间距
@property (nonatomic, assign) CGFloat spacing;

@property (nonatomic,assign)BOOL initStated;
@property (nonatomic,strong)UIStackView *stackView;
@end
@implementation UITextImageView
+ (UITextImageView * _Nonnull (^)(NSString * _Nonnull))text {
    return ^(NSString *text){
        return UITextImageView.new.text(text);
    };
}
+ (UITextImageView * _Nonnull (^)(id _Nonnull))image {
    return ^(id image){
        return UITextImageView.new.image(image);
    };
}
+ (UITextImageView * _Nonnull (^)(void (^ _Nonnull)(UITextImageView * _Nonnull)))initStateBk {
    return ^(void (^block)(UITextImageView *stackView)){
        return UITextImageView.new.initStateBk(block);
    };
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initConfig];
}
- (void)initConfig {
    _bgImageContentMode = UIViewContentModeScaleToFill;
    self.backgroundColor = [UIColor clearColor];
}
- (UIView *)flexibleView {
    if (!_flexibleView) {
        _flexibleView = UIView.new;
        [_flexibleView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [_flexibleView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [_flexibleView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [_flexibleView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    }
    return _flexibleView;
}
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.spacing = 5;
        [self addSubview:_stackView];
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        [_stackView.topAnchor constraintGreaterThanOrEqualToAnchor:self.topAnchor].active = YES;
        [_stackView.bottomAnchor constraintLessThanOrEqualToAnchor:self.bottomAnchor].active = YES;
        [_stackView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor].active = YES;
        [_stackView.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor].active = YES;
        [_stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [_stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    }
    return _stackView;
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:_tapGestureRecognizer];
    }
    return _tapGestureRecognizer;;
}
- (void)setAddFlexibleSpacing:(BOOL)addFlexibleSpacing {
    _addFlexibleSpacing = addFlexibleSpacing;
    [self setNeedsDisplay];
}

- (void)handleTapAction {
    if (self.tapActionBlock) self.tapActionBlock(self);
}
- (UITextImageView * _Nonnull (^)(void (^ _Nonnull)(UITextImageView * _Nonnull)))tapActionBK {
    return ^(void (^block)(UITextImageView *stackView)){
        self.tapActionBlock = block;
        if (block) {
            [self tapGestureRecognizer];
            self.tapGestureRecognizer.enabled = YES;
        }else {
            self -> _tapGestureRecognizer.enabled = NO;
        }
        return self;
    };
}
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = UILabel.new;
    }
    return _textLabel;
}
- (UITextImageView * _Nonnull (^)(NSString * _Nonnull))text {
    return ^(NSString *text){
        self.textLabel.text = text;
        return self;
    };
}
- (UITextImageView * _Nonnull (^)(NSAttributedString * _Nonnull))attributedText {
    return ^(NSAttributedString *attributedText){
        self.textLabel.attributedText = attributedText;
        return self;
    };
}
- (UITextImageView * _Nonnull (^)(id _Nonnull))textColor {
    return ^(id color){
        self.textLabel.textColor = __UIColorFromObj(color);
        return self;
    };
}
- (UITextImageView * _Nonnull (^)(CGFloat))textFontSize {
    return ^(CGFloat fontSize){
        self.textLabel.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}
- (UITextImageView * _Nonnull (^)(CGFloat))textMediumFontSize {
    return ^(CGFloat fontSize){
        self.textLabel.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium];
        return self;
    };
}
- (UITextImageView * _Nonnull (^)(id _Nonnull))image {
    return ^(id image){
        if ([image isKindOfClass:UIImage.class]) {
            self.imageView.image = (UIImage *)image;
        }else if ([image isKindOfClass:NSString.class]) {
            self.imageView.image = [UIImage imageNamed:(NSString *)image];
        }
        return self;
    };
}
- (UITextImageView * _Nonnull (^)(id _Nonnull))bgImage {
    return ^(id image){
        if ([image isKindOfClass:UIImage.class]) {
            self.BGImage = (UIImage *)image;
        }else if ([image isKindOfClass:NSString.class]) {
            self.BGImage = [UIImage imageNamed:(NSString *)image];
        }
        return self;
    };
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = UIImageView.new;
    }
    return _imageView;
}

- (void)setImagePosition:(UIImagePosition)imagePosition {
    BOOL needUpdate = (_imagePosition != imagePosition);
    _imagePosition = imagePosition;
    if (needUpdate) {
        [self updateLayout];
    }
}
- (UITextImageView * _Nonnull (^)(UIImagePosition))postion {
    return ^(UIImagePosition position){
        self.imagePosition = position;
        return self;
    };
}
- (instancetype)imageStart {
    self.imagePosition = UIImagePositionStart;
    return self;
}
- (instancetype)imageEnd {
    self.imagePosition = UIImagePositionEnd;
    return self;
}
- (instancetype)imageTop {
    self.imagePosition = UIImagePositionTop;
    return self;
}
- (instancetype)imageBottom {
    self.imagePosition = UIImagePositionBottom;
    return self;
}
- (void)setTextImageCrossAlignment:(UITextImageCrossAxisAlignment)textImageCrossAlignment {
    _textImageCrossAlignment = textImageCrossAlignment;
    switch (textImageCrossAlignment) {
        case UITextImageCrossAxisAlignmentStart:
            self.stackView.alignment = UIStackViewAlignmentLeading;
            break;
        case UITextImageCrossAxisAlignmentCenter:
            self.stackView.alignment = UIStackViewAlignmentCenter;
            break;
        case UITextImageCrossAxisAlignmentEnd:
            self.stackView.alignment = UIStackViewAlignmentTrailing;
            break;
        case UITextImageCrossAxisAlignmentFirstBaseline:
            self.stackView.alignment = UIStackViewAlignmentFirstBaseline;
            break;
        case UITextImageCrossAxisAlignmentLastBaseline:
            self.stackView.alignment = UIStackViewAlignmentLastBaseline;
            break;
        default:
            break;
    }
}
- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    self.stackView.layoutMargins = contentInsets;
    self.stackView.layoutMarginsRelativeArrangement = YES;
}
- (UITextImageView * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))padding {
    return ^(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right){
        self.contentInsets = UIEdgeInsetsMake(top, left, bottom, right);
        return self;
    };
}
- (UITextImageView * _Nonnull (^)(CGFloat, CGFloat))paddingVH {
    return ^(CGFloat vertical, CGFloat horizontal){
        self.contentInsets = UIEdgeInsetsMake(vertical, horizontal, vertical, horizontal);
        return self;
    };
}
- (UITextImageView * _Nonnull (^)(CGFloat, CGFloat))paddingVerTB {
    return ^(CGFloat top, CGFloat bottom){
        self.contentInsets = UIEdgeInsetsMake(top, self.contentInsets.left, bottom, self.contentInsets.right);
        return self;
    };
}
- (UITextImageView * _Nonnull (^)(CGFloat, CGFloat))paddingHorLT {
    return ^(CGFloat leading, CGFloat trailing){
        self.contentInsets = UIEdgeInsetsMake(self.contentInsets.top, leading, self.contentInsets.bottom, trailing);
        return self;
    };
}

- (void)updateLayout {
    [self.stackView.arrangedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.imagePosition == UIImagePositionStart) {
        self.stackView.axis = UILayoutConstraintAxisHorizontal;
        [self addImageView];
        [self addTextLabel];
    }else if (self.imagePosition == UIImagePositionEnd) {
        self.stackView.axis = UILayoutConstraintAxisHorizontal;
        [self addTextLabel];
        [self addImageView];
    }else if (self.imagePosition == UIImagePositionTop) {
        self.stackView.axis = UILayoutConstraintAxisVertical;
        [self addImageView];
        [self addTextLabel];
    }else if (self.imagePosition == UIImagePositionBottom) {
        self.stackView.axis = UILayoutConstraintAxisVertical;
        [self addTextLabel];
        [self addImageView];
    }
    [self setNeedsDisplay];
}
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.initStateBlock && !self.initStated) {
        self.initStateBlock(self);
        self.initStateBlock = nil;
        self.initStated = YES;
    }
    if (self.updateViewModelBlock) self.updateViewModelBlock(self, self.viewModel);
    
    [self updateForState:self.viewState];
    [self updateLayout];
}
- (void)setSpacing:(CGFloat)spacing {
    _spacing = spacing;
    self.stackView.spacing = spacing;
}
- (UITextImageView * _Nonnull (^)(CGFloat))space {
    return ^(CGFloat spacing){
        self.spacing = spacing;
        return self;
    };
}
- (void)addTextLabel {
    if (_textLabel) [self.stackView addArrangedSubview:self.textLabel];
}
- (void)addImageView {
    if (_imageView ) [self.stackView addArrangedSubview:self.imageView];
}
- (void)setViewState:(UITextImageState)viewState {
    if (!self.superview) return;
    BOOL needUpdate = (_viewState != viewState);
    _viewState = viewState;
    if (needUpdate) [self updateForState:viewState];
    [self setNeedsDisplay];
}
- (UITextImageView * _Nonnull (^)(UITextImageState))state {
    return ^(UITextImageState state){
        self.viewState = state;
        return self;
    };
}
- (void)updateForState:(UITextImageState)state {
    switch (state) {
        case UITextImageStateNormal:
        {
            self.userInteractionEnabled = YES;
            if (self.configureBlock) self.configureBlock(self);
        }
            break;
        case UITextImageStateSelected:
        {
            self.userInteractionEnabled = YES;
            if (self.selectedConfigureBlock) self.selectedConfigureBlock(self);
           
        }
            break;
        case UITextImageStateDisabled:
        {
            self.userInteractionEnabled = NO;
            if (self.disabledConfigureBlock) self.disabledConfigureBlock(self);
        }
            break;
        default:
            break;
    }
}

- (UITextImageView * _Nonnull (^)(void (^ _Nonnull)(UITextImageView * _Nonnull)))initStateBk{
    return ^(void (^block)(UITextImageView *stackView)){
        self.initStateBlock = block;
        return self;
    };
}
- (UITextImageView * _Nonnull (^)(void (^ _Nonnull)(UITextImageView * _Nonnull)))configureBK {
    return ^(void (^block)(UITextImageView *stackView)){
        self.configureBlock = block;
        return self;
    };
}
- (UITextImageView * _Nonnull (^)(void (^ _Nonnull)(UITextImageView * _Nonnull)))disabledConfigureBK {
    return ^(void (^block)(UITextImageView *stackView)){
        self.disabledConfigureBlock = block;
        return self;
    };
}
- (UITextImageView * _Nonnull (^)(void (^ _Nonnull)(UITextImageView * _Nonnull)))selectedConfigureBK{
    return ^(void (^block)(UITextImageView *stackView)){
        self.selectedConfigureBlock = block;
        return self;
    };
}
- (UITextImageView * _Nonnull (^)(void (^ _Nonnull)(UITextImageView * _Nonnull)))layoutSubviewBK {
    return ^(void (^block)(UITextImageView *stackView)){
        self.layoutSubviewBlock = block;
        return self;
    };
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.addFlexibleSpacing) {
        if (self.stackView.arrangedSubviews.count >= 2 && ![self.stackView.arrangedSubviews containsObject:self.flexibleView]) {
            [self.stackView insertArrangedSubview:self.flexibleView atIndex:1];
        }
    }else {
        [_flexibleView removeFromSuperview];
    }
    if (self.layoutSubviewBlock) self.layoutSubviewBlock(self);
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!self.BGImage) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return;
    
    // 计算绘制区域
    CGRect drawRect = [self rectForContentModeInBounds:self.bounds imageSize:self.BGImage.size];
    
    // 绘制图片
    [self.BGImage drawInRect:drawRect];
}

// 根据 contentMode 计算绘制区域
- (CGRect)rectForContentModeInBounds:(CGRect)bounds imageSize:(CGSize)imageSize {
    UIEdgeInsets inset = self.bgContentInsets;
    bounds = CGRectInsetWithEdgeInsets(bounds, inset);
    if (imageSize.width == 0 || imageSize.height == 0) {
        return CGRectZero;
    }
    
    CGRect rect = CGRectZero;
    CGFloat viewRatio = bounds.size.width / bounds.size.height;
    CGFloat imageRatio = imageSize.width / imageSize.height;
    
    switch (self.bgImageContentMode) {
        case UIViewContentModeScaleToFill:
            rect = bounds;
            break;
            
        case UIViewContentModeScaleAspectFit: {
            if (viewRatio > imageRatio) {
                // 视图更宽，按高度缩放
                CGFloat width = bounds.size.height * imageRatio;
                rect = CGRectMake((bounds.size.width - width) * 0.5,
                                  inset.top,
                                  width,
                                  bounds.size.height);
            } else {
                // 视图更高，按宽度缩放
                CGFloat height = bounds.size.width / imageRatio;
                rect = CGRectMake(inset.left,
                                  (bounds.size.height - height) * 0.5,
                                  bounds.size.width,
                                  height);
            }
            break;
        }
            
        case UIViewContentModeScaleAspectFill: {
            if (viewRatio > imageRatio) {
                // 视图更宽，按宽度缩放，裁剪上下
                CGFloat height = bounds.size.width / imageRatio;
                rect = CGRectMake(inset.left,
                                  (bounds.size.height - height) * 0.5,
                                  bounds.size.width,
                                  height);
            } else {
                // 视图更高，按高度缩放，裁剪左右
                CGFloat width = bounds.size.height * imageRatio;
                rect = CGRectMake((bounds.size.width - width) * 0.5,
                                  inset.top,
                                  width,
                                  bounds.size.height);
            }
            break;
        }
            
        case UIViewContentModeCenter:
            rect = CGRectMake((bounds.size.width - imageSize.width) * 0.5,
                              (bounds.size.height - imageSize.height) * 0.5,
                              imageSize.width,
                              imageSize.height);
            break;
            
        case UIViewContentModeTop:
            rect = CGRectMake((bounds.size.width - imageSize.width) * 0.5,
                              inset.top,
                              imageSize.width,
                              imageSize.height);
            break;
            
        case UIViewContentModeBottom:
            rect = CGRectMake((bounds.size.width - imageSize.width) * 0.5,
                              bounds.size.height - imageSize.height,
                              imageSize.width,
                              imageSize.height);
            break;
            
        case UIViewContentModeLeft:
            rect = CGRectMake(inset.left,
                              (bounds.size.height - imageSize.height) * 0.5,
                              imageSize.width,
                              imageSize.height);
            break;
            
        case UIViewContentModeRight:
            rect = CGRectMake(bounds.size.width - imageSize.width,
                              (bounds.size.height - imageSize.height) * 0.5,
                              imageSize.width,
                              imageSize.height);
            break;
            
        case UIViewContentModeTopLeft:
            rect = CGRectMake(inset.left, inset.top, imageSize.width, imageSize.height);
            break;
            
        case UIViewContentModeTopRight:
            rect = CGRectMake(bounds.size.width - imageSize.width, 0, imageSize.width, imageSize.height);
            break;
            
        case UIViewContentModeBottomLeft:
            rect = CGRectMake(inset.left, bounds.size.height - imageSize.height, imageSize.width, imageSize.height);
            break;
            
        case UIViewContentModeBottomRight:
            rect = CGRectMake(bounds.size.width - imageSize.width,
                              bounds.size.height - imageSize.height,
                              imageSize.width,
                              imageSize.height);
            break;
            
        default:
            rect = bounds;
            break;
    }
    
    return rect;
}
- (void)setBgContentInsets:(UIEdgeInsets)bgContentInsets {
    _bgContentInsets = bgContentInsets;
    [self setNeedsDisplay];
}
// 图片或 contentMode 改变时重绘
- (void)setBGImage:(UIImage *)BGImage {
    if (_BGImage != BGImage) {
        _BGImage = BGImage;
        [self setNeedsDisplay];
    }
}

- (void)setBgImageContentMode:(UIViewContentMode)bgImageContentMode {
    if (_bgImageContentMode != bgImageContentMode) {
        _bgImageContentMode = bgImageContentMode;
        [self setNeedsDisplay];
    }
}
- (UITextImageView * _Nonnull (^)(void (^ _Nonnull)(UITextImageView * _Nonnull, id _Nonnull)))updateViewModelBK {
    return ^(void (^block)(UITextImageView *view, id viewModel)){
        self.updateViewModelBlock = block;
        return self;
    };
}
- (void)updateViewModel:(id)viewModel {
    self.viewModel = viewModel;
    if (self.updateViewModelBlock) self.updateViewModelBlock(self, viewModel);
}
@end


