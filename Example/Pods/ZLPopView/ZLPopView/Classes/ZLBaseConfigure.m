//
//  GMConfigProxy.m
//  GMPopView
//
//  Created by admin on 2025/9/12.
//

#import "ZLBaseConfigure.h"

#import <ZLPopView/ZLPopView.h>
#import <objc/runtime.h>
#define kSeptorDefaultHeight ZLSeparatorView.defaultThickness





@interface UIView()
@property (nonatomic,assign)BOOL gm_layoutConfigObj;
@end
@interface GMUIContainerView()
@property (nonatomic,weak,readwrite)UIView* childView;
@end
@implementation GMUIContainerView
+ (instancetype)initView:(UIView *)view inset:(UIEdgeInsets)inset {
    GMUIContainerView *container = [[self alloc] init];
    [container addSubview:view];
    container.childView = view;
    container.inset = inset;
    return container;
}
- (void)setInset:(UIEdgeInsets)inset {
    if (UIEdgeInsetsEqualToEdgeInsets(inset, _inset)) return;
    _inset = inset;
    [self layoutChildView:inset];
}
- (void)layoutChildView:(UIEdgeInsets) inset {
    self.childView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.constraints enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof NSLayoutConstraint * _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
        if (constraint.firstItem == self.childView || constraint.secondItem == self.childView) {
            constraint.active = NO;
            [self removeConstraint:constraint];
        }
    }];
    
        // 添加新的约束
        [NSLayoutConstraint activateConstraints:@[
            [self.childView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:inset.left],
            [self.childView.topAnchor constraintEqualToAnchor:self.topAnchor constant:inset.top],
            [self.childView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-inset.right],
            [self.childView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-inset.bottom]
        ]];
}
- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
#else
#endif
}
@end

@interface ZLViewConfigObj()
@property (nonatomic,weak,readwrite)UIView *view;
@end
@interface __ZLTapGestureRecognizer : UITapGestureRecognizer
@property (nonatomic,copy)void (^block)(UIView *);
@end
@implementation __ZLTapGestureRecognizer
@end

@interface __ZLLongPressGestureRecognizer : UILongPressGestureRecognizer
@property (nonatomic,copy)void (^block)(UIView *,UILongPressGestureRecognizer *);
@end
@implementation __ZLLongPressGestureRecognizer
- (instancetype)init
{
    return  [super initWithTarget:self action:@selector(longPressAction:)];
}
- (void)longPressAction:(UILongPressGestureRecognizer *) gesture {
    if (self.block) {
        self.block(gesture.view,gesture);
    }
}
@end

typedef void(^_ZLActionBlock)(id);
@interface ZLMultiActionObj : NSObject
@property (nonatomic,strong)NSMutableArray<_ZLActionBlock> *blocks;
@property (nonatomic,strong)_ZLActionBlock block;
@property (nonatomic,weak)UIView *view;
@end
@implementation ZLMultiActionObj
- (NSMutableArray<_ZLActionBlock> *)blocks {
    if (!_blocks) {
        _blocks = NSMutableArray.array;
    }
    return _blocks;
}
- (void)addBlock:(_ZLActionBlock)block {
    if (block) [self.blocks  addObject:block];
}
- (void)setBlock:(_ZLActionBlock)block {
    [self.blocks  removeObject:_block];
    _block = block;
    if (_block) [self.blocks addObject:_block];
}
- (void)action:(id)target {
    if (_blocks) {
        [self.blocks enumerateObjectsUsingBlock:^(_ZLActionBlock  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) obj(self.view);
        }];
    }
}
@end

@implementation NSLayoutConstraint(GMPopView)
- (NSLayoutConstraint*)gm_enableActive {
    self.active = YES;
    return self;
}
- (NSLayoutConstraint*)gm_setPriority:(UILayoutPriority)priority {
    self.priority = priority;
    return self;
}
@end
@implementation CALayer (AnchorPointAdjust)
- (void)setAnchorPointWithoutMoving:(CGPoint)anchorPoint {
    CGPoint lastAnchor = self.anchorPoint;
    self.anchorPoint = anchorPoint;
    // 计算新的 position 以保持图层视觉位置不变
    CGFloat x = self.position.x + (anchorPoint.x - lastAnchor.x) * self.bounds.size.width;
    CGFloat y = self.position.y + (anchorPoint.y - lastAnchor.y) * self.bounds.size.height;
    // 更新 position
    self.position = CGPointMake(x, y);
}
@end

@interface ZLBaseConfigure()
@property (nonatomic,weak,readwrite)UIView *view;
@property (nonatomic,assign,readwrite)BOOL isFirstResponder;
@property (nonatomic,strong)ZLViewConfigObj *layoutInStackView;
@property (nonatomic,assign,readwrite)UIEdgeInsets margeViewInset;
@property (nonatomic,assign)BOOL isObservedBounds;
@property (nonatomic,copy)void (^enableConfigBlock) (UIView *,id);
@property (nonatomic,copy)void (^disableConfigBlock) (UIView *,id);
@property (nonatomic,copy)void (^didUpdateViewModelBlock) (__kindof UIView *, id,BOOL);
@property (nonatomic,assign)BOOL isUserInteractionEnabled;
@property (nonatomic,weak,readwrite)ZLBuilderContext *context;
@property (nonatomic,weak)Class viewModelCls;
@property (nonatomic,strong)id observer;
@property (nonatomic,strong,readwrite)id  viewModel;
@property (nonatomic,strong)NSMutableDictionary *viewModelBlocksInfo;

@property  (nonatomic,readonly)ZLMultiActionObj *tapActionObj;
@property  (nonatomic,readonly)ZLMultiActionObj *touchUpActionObj;
@property  (nonatomic,strong)NSMutableDictionary<NSString *,ZLMultiActionObj *> *multiActionDic;
@end

@interface ZLBuilderContext()
@property (nonatomic, strong,readwrite) NSHashTable *allViews;
@end
@implementation ZLBuilderContext
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allViews = [NSHashTable weakObjectsHashTable];
    }
    return self;
}
- (UIView *)viewWithTag:(NSInteger )tag {
    for (UIView *view in self.allViews) {
        if (view.tag == tag) {
            return view;
        }else {
            UIView* child = [view viewWithTag:tag];
            if (child) return child;
        }
    }
    return nil;
}
- (void)updateViewModel {
    if (self.stackView) {
        [self.stackView.kfc  updateViewModel];
    }else {
        [self.scrollView.kfc updateViewModel];
    }
}
- (void)updateViewModelWithViewTag:(NSInteger)tag {
    UIView *view = [self viewWithTag:tag];
    [view.kfc updateViewModel];
}
- (void)addView:(UIView *)view {
    if (!view) return;
    [self.allViews addObject:view];
    view.kfc.context = self;
}
- (UIView * _Nonnull (^)(NSInteger))viewTag {
    return ^UIView *(NSInteger tag) {
        return [self viewWithTag:tag];
    };
}
- (UILabel * _Nullable (^)(NSInteger))labelTag {
    return ^UILabel *(NSInteger tag) {
        return kIS_UILabel(self.viewTag(tag));
    };
}
- (UIButton * _Nullable (^)(NSInteger))buttonTag {
    return ^UIButton *(NSInteger tag) {
        return kIS_UIButton(self.viewTag(tag));
    };
}
- (UIImageView * _Nullable (^)(NSInteger))imgViewTag {
    return ^UIImageView *(NSInteger tag) {
        return kIS_UIImageView(self.viewTag(tag));
    };
}
- (UITextView * _Nullable (^)(NSInteger))textViewTag {
    return ^UITextView *(NSInteger tag) {
        return kIS_UITextView(self.viewTag(tag));
    };
}
- (UITextField * _Nullable (^)(NSInteger))textFieldTag {
    return ^UITextField *(NSInteger tag) {
        return kIS_UITextField(self.viewTag(tag));
    };
}
- (UISwitch * _Nullable (^)(NSInteger))switchTag   {
    return ^UISwitch *(NSInteger tag) {
        return kIS_UISwitch(self.viewTag(tag));
    };
}
- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
#else
#endif
}
@end

@implementation ZLPopViewBuilderContext
- (ZLPopBaseView *)popView {
    return [self containerView].kfc.popView;
}
- (UIView *)containerView {
    return self.stackView ? self.stackView : self.scrollView;
}
- (void)show {
    [self.popView show];
}
- (void)dismiss {
    [self.popView dismiss];
}
@end


static UIColor *_defaultColor;
static CGFloat _defaultThickness = 1.0f;
@interface ZLSeparatorView()
@property (nonatomic,strong)NSLayoutConstraint *topCons;
@property (nonatomic,strong)NSLayoutConstraint *bottomCons;
@property (nonatomic,strong)NSLayoutConstraint *leadingCons;
@property (nonatomic,strong)NSLayoutConstraint *trailingCons;
@property (nonatomic,strong,readwrite)NSLayoutConstraint *heightCons;
@property (nonatomic,strong,readwrite)NSLayoutConstraint *widthCons;
@property (nonatomic,weak,readwrite)UIView *view;
@end
@implementation ZLSeparatorView
+ (void)setDefaultColor:(UIColor *)defaultColor {
    _defaultColor = defaultColor;
}
+ (UIColor *)defaultColor {
    return _defaultColor ?: @"#F1F1F1".hexColor;
}
+ (void)setDefaultThickness:(CGFloat)defaultThickness {
    _defaultThickness = defaultThickness;
}
+ (CGFloat)defaultThickness {
    
    return _defaultThickness > 0 ? _defaultThickness : 1.0f;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = ZLSeparatorView.defaultColor;
    }
    return self;
}
- (ZLSeparatorView * _Nonnull (^)(id  _Nonnull))color {
    return ^ZLSeparatorView* (id color) {
        self.backgroundColor = __UIColorFromObj(color);
        return self;
    };
}
- (ZLSeparatorView * (^)(UIEdgeInsets inset,id color))config {
    return ^ZLSeparatorView* (UIEdgeInsets inset, id color) {
        self.backgroundColor = __UIColorFromObj(color);
        return self.layoutInset(inset);
    };
}
- (NSLayoutConstraint *)topCons {
    if (!_topCons) {
        _topCons = [self.kfc topToView:self.superview offset:0];
    }
    return _topCons;
}
- (NSLayoutConstraint *)bottomCons {
    if (!_bottomCons) {
        _bottomCons = [self.kfc bottomToView:self.superview offset:0];
    }
    return _bottomCons;
}
- (NSLayoutConstraint *)leadingCons {
    if (!_leadingCons) {
        _leadingCons = [self.kfc leadingToView:self.superview offset:0];
    }
    return _leadingCons;
}
- (NSLayoutConstraint *)trailingCons {
    if (!_trailingCons) {
        _trailingCons = [self.kfc trailingToView:self.superview offset:0];
    }
    return _trailingCons;
}
- (NSLayoutConstraint *)heightCons {
    if (!_heightCons) {
        _heightCons = [self.kfc setViewHeight:0];
    }
    return _heightCons;
}
- (NSLayoutConstraint *)widthCons {
    if (!_widthCons) {
        _widthCons = [self.kfc setViewWidth:0];
    }
    return _widthCons;
}
- (ZLSeparatorView * (^)(CGFloat thickness))thickness {
    return ^ZLSeparatorView* (CGFloat thickness) {
        if (self.tag == kTopSeparatorTag || self.tag == kBottomSeparatorTag) {
            self.heightCons.constant = thickness;
        }else if (self.tag == kLeadingSeparatorTag || self.tag == kTrailingSeparatorTag) {
            self.widthCons.constant = thickness;
        }
        return self;
    };
}
- (instancetype)top{
    self.tag = kTopSeparatorTag;
    return self.layoutInset(UIEdgeInsetsMake(0, 0, kSeptorDefaultHeight, 0));
}
- (instancetype )bottom {
    self.tag = kBottomSeparatorTag;
    return self.layoutInset(UIEdgeInsetsMake(kSeptorDefaultHeight, 0, 0, 0));
}
- (instancetype)leading {
    
    self.tag = kLeadingSeparatorTag;
    return self.layoutInset(UIEdgeInsetsMake(0, 0, 0, kSeptorDefaultHeight));
}
- (instancetype)trailing {
    self.tag = kTrailingSeparatorTag;
    return self.layoutInset(UIEdgeInsetsMake(0, kSeptorDefaultHeight, 0, 0));
}

- (void)deactiveTopCons {
    if (_topCons) _topCons.active = NO;
}
- (void)deactiveBottomCons {
    if (_bottomCons) _bottomCons.active = NO;
}
- (void)deactiveLeadingCons {
    if (_leadingCons) _leadingCons.active = NO;
}
- (void)deactiveTrailingCons {
    if (_trailingCons) _trailingCons.active = NO;
}
- (void)deactiveHeightCons {
    if (_heightCons) _heightCons.active = NO;
}
- (void)deactiveWidthCons {
    if (_widthCons) _widthCons.active = NO;
}
- (ZLSeparatorView * _Nonnull (^)(UIEdgeInsets))layoutInset {
    return ^ZLSeparatorView* (UIEdgeInsets inset) {
        if (!self.view) return self;
        if (self.superview == nil) [self.view addSubview:self];
        NSInteger tag = self.tag;
        if (tag == kTopSeparatorTag || tag == kBottomSeparatorTag){
            self.isHorizontal = YES;
            self.leadingCons.constant = inset.left;
            self.trailingCons.constant = -inset.right;
            if (tag == kTopSeparatorTag) {
                [self deactiveBottomCons];
                self.topCons.constant = inset.top;
                self.heightCons.constant = MAX(inset.bottom, 0);
            }else {
                [self deactiveTopCons];
                self.bottomCons.constant = -inset.bottom;
                self.heightCons.constant = MAX(inset.top, 0);
            }
            [self deactiveWidthCons];
        }else if (tag == kLeadingSeparatorTag || tag == kTrailingSeparatorTag) {
            self.isHorizontal = NO;
            self.topCons.constant = inset.top;
            self.bottomCons.constant = -inset.bottom;
            if (tag == kLeadingSeparatorTag) {
                self.leadingCons.constant = inset.left;
                self.widthCons.constant = MAX(inset.right, 0);
                [self deactiveTrailingCons];
            }else {
                self.trailingCons.constant = -inset.right;
                self.widthCons.constant = MAX(inset.left, 0);
                [self deactiveLeadingCons];
            }
            [self deactiveHeightCons];
        }
        return self;
    };
}
@end




@implementation ZLBaseConfigure
- (NSMutableDictionary<NSString *,ZLMultiActionObj *> *)multiActionDic {
    if (!_multiActionDic) {
        _multiActionDic = [NSMutableDictionary dictionary];
    }
    return _multiActionDic;
}
- (ZLMultiActionObj *)tapActionObj {
    NSString   *key = NSStringFromSelector(_cmd);
    ZLMultiActionObj *action =  self.multiActionDic[key];
    if (!action) {
        action = ZLMultiActionObj.new;
        action.view = self.view;
        [self.multiActionDic setValue:action forKey:key];
    }
    return action;
}
- (ZLMultiActionObj *)touchUpActionObj {
    NSString   *key = NSStringFromSelector(_cmd);
    ZLMultiActionObj *action =  self.multiActionDic[key];
    if (!action) {
        action = ZLMultiActionObj.new;
        action.view = self.view;
        [self.multiActionDic setValue:action forKey:key];
    }
    return action;
}

- (UIView *)margeView {
    if (UIEdgeInsetsEqualToEdgeInsets(self.margeViewInset, UIEdgeInsetsZero)) return self.view;
    GMUIContainerView *container;
    if ([self.view.superview isKindOfClass:GMUIContainerView.class]) {
        container = (GMUIContainerView *)self.view.superview;
        container.inset = self.margeViewInset;
    }else {
        container = [GMUIContainerView initView:self.view inset:self.margeViewInset];
    }
    if ([container respondsToSelector:@selector(setKfc:)]) {
        ZLUIViewConfigure *kfc = [ZLUIViewConfigure configureWithView:container];
        kfc.layoutInStackView = self.layoutInStackView;
        kfc.layoutInStackView.view = container;
        [container performSelector:@selector(setKfc:) withObject:kfc];
        container.gm_layoutConfigObj = self.view.gm_layoutConfigObj;
    }
    return container;
}
- (ZLViewConfigObj *)layoutInStackView {
    if (!_layoutInStackView) {
        _layoutInStackView = ZLViewConfigObj.new;
        _layoutInStackView.view = self.view;
    }
    return _layoutInStackView;
}

+ (instancetype)configureWithView:(UIView *)view {
    ZLBaseConfigure *cfg = [[self alloc] init];
    cfg.isUserInteractionEnabled = view.isUserInteractionEnabled;
    cfg.view = view;
    return cfg;
}
- (NSMutableDictionary *)viewModelBlocksInfo {
    if (!_viewModelBlocksInfo) {
        _viewModelBlocksInfo = [NSMutableDictionary dictionary];
    }
    return _viewModelBlocksInfo;
}
- (ZLPopBaseView *)popView {
    UIView *superView = self.view;
    while (superView && ![superView isKindOfClass:ZLPopBaseView.class]) superView = superView.superview;
    if ([superView isKindOfClass:ZLPopBaseView.class]) return (ZLPopBaseView *)superView;
    return nil;
}
- (void (^)(void))dismissPopView {
    return ^{
        ZLPopBaseView *popView = self.popView;
        if (popView) [popView dismiss];
    };
}
- (instancetype )addTapAction:(void(^)(UIView *))block add:(BOOL)isAdd{
    __block BOOL isAddedTap = NO;
    [self.view.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:__ZLTapGestureRecognizer.class]) {
            isAddedTap = YES;
            *stop = YES;
        }
    }];
    if (!isAddedTap) {
        __ZLTapGestureRecognizer *tap = [[__ZLTapGestureRecognizer alloc] initWithTarget:self.tapActionObj action:@selector(action:)];
        self.view.userInteractionEnabled = YES;
        [self.view addGestureRecognizer:tap];
    }
    if (isAdd) {
        [self.tapActionObj addBlock:block];
    }else{
        self.tapActionObj.block = block;
    }
    return self;
}
- (id  _Nonnull (^)(void (^ _Nonnull)(__kindof UIView * _Nonnull)))tapAction {
    return ^id (void(^block)(UIView *view)) {
        return [self addTapAction:block add:NO];
    };
}
- (id  _Nonnull (^)(void (^ _Nonnull)(__kindof UIView * _Nonnull)))addTapAction {
    return ^id (void(^block)(UIView *view)) {
        return [self addTapAction:block add:YES];
    };
}
- (id  _Nonnull (^)(void (^ _Nonnull)(__kindof UIView * _Nonnull,UILongPressGestureRecognizer *)))longPressAction {
    return ^id (void(^block)(UIView *view,UILongPressGestureRecognizer *gesture)) {
        __block BOOL  isAddedTap = NO;
        [self.view.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof __ZLLongPressGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:__ZLLongPressGestureRecognizer.class]) {
                obj.block = block;
                isAddedTap = YES;
                *stop = YES;
            }
        }];
        if (!isAddedTap) {
            __ZLLongPressGestureRecognizer *tap = [[__ZLLongPressGestureRecognizer alloc] init];
            tap.block = block;
            self.view.userInteractionEnabled = YES;
            [self.view addGestureRecognizer:tap];
        }
        return self;
    };
}
- (id  _Nonnull (^)(Class  _Nonnull __unsafe_unretained))viewModelClass {
    return ^id (Class cls) {
        self.viewModelCls = cls;
        return self;
    };
}
- (id)viewModelIsStringClass {
    self.viewModelCls = NSString.class;
    return self;
}
- (id  _Nonnull (^)(void (^ _Nonnull)(__kindof UIView * _Nonnull, id _Nonnull,BOOL)))updateViewModelBK {
    return ^id (void(^block)(__kindof UIView *view, id viewModel,BOOL isUpdate)) {
        BOOL isvalid = YES;
        if (self.viewModel && self.viewModelCls && ![self.viewModel isKindOfClass:self.viewModelCls]) {
            isvalid = NO;
        }
        if (isvalid && block) block(self.view,self.viewModel,NO);
        [self addRefreshConfigBKObserver];
        self.didUpdateViewModelBlock = block;
        return self;
    };
}
- (id  _Nonnull (^)(id _Nonnull, void (^ _Nonnull)(__kindof UIView * _Nonnull, id _Nullable)))updateViewModelBKWhen {
    return ^id (id vm, void(^block)(__kindof UIView *view, id viewModel)) {
        if (block && vm) {
            [self.viewModelBlocksInfo setValue:block forKey:vm];
            [self addRefreshConfigBKObserver];
        }
        return self;
    };
}

- (void)updateViewModel {
    NSMutableDictionary *userInfo = NSMutableDictionary.dictionary;
    [userInfo setValue:self.view forKey:@"view"];
    if (!self.observer && self.viewModel) {
        if (_viewModelBlocksInfo && self.viewModelBlocksInfo.count > 0) {
            void(^bk)(UIView *,id) = [self.viewModelBlocksInfo objectForKey:self.viewModel];
            if (bk) {
                bk(self.view,self.viewModel);
            }
        }
    }
    if (!self.observer && self.didUpdateViewModelBlock) {
        BOOL isvalid = YES;
        if (self.viewModelCls
                && self.viewModel
                && ![self.viewModel isKindOfClass:self.viewModelCls]) {
            isvalid = NO;
        }
        if (isvalid) {
            self.didUpdateViewModelBlock(self.view, self.viewModel, YES);
        }
    }
    [NSNotificationCenter.defaultCenter postNotificationName:kRefreshConfigBKNotification object:self.context userInfo:userInfo];
}
- (void)updateViewModel:(id)viewModel {
    self.viewModel = viewModel;
    [self updateViewModel];
}
- (id (^)(void (^ _Nonnull)(__kindof UIView * _Nonnull,id)))enableConfigBK{
    return ^(void(^block)(UIView *view,id viewModel)){
        self.enableConfigBlock = block;
        if (self.isUserInteractionEnabled) self.enableConfigBlock(self.view,self.viewModel);
        return self;
    };
}
- (id (^)(void (^ _Nonnull)(__kindof UIView * _Nonnull,id)))disableConfigBK {
    return ^(void(^block)(UIView *view,id viewModel)){
        self.disableConfigBlock = block;
        if (!self.isUserInteractionEnabled) self.disableConfigBlock(self.view,self.viewModel);
        return self;
    };
}
- (id (^)(BOOL))userInteractionEnabled {
    return ^id(BOOL enable){
        if (enable == self.isUserInteractionEnabled) return self;
        self.isUserInteractionEnabled = enable;
        self.view.userInteractionEnabled = enable;
        if (enable) {
            if (self.enableConfigBlock) self.enableConfigBlock(self.view,self.viewModel);
        }else {
            if (self.disableConfigBlock) self.disableConfigBlock(self.view,self.viewModel);
        }
        return self;
    };
}


- (UIView * _Nonnull (^)(NSInteger))viewTag {
    return ^UIView* (NSInteger tag){
        return [self.view viewWithTag:tag];
    };
}
- (id  _Nonnull (^)(BOOL))hidden {
    return ^id (BOOL hidden){
        self.view.hidden = hidden;
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))alpha {
    return ^id (CGFloat alpha){
        self.view.alpha = alpha;
        return self;
    };
}
- (void)setContext:(ZLBuilderContext *)context {
    _context = context;
    if (self.didUpdateViewModelBlock ||  (_viewModelBlocksInfo && self.viewModelBlocksInfo.count > 0)) {
        [self addRefreshConfigBKObserver];
    }
}
- (void)addRefreshConfigBKObserver {
    __weak typeof(self) weakSelf = self;
    if (!self.context) return;
    if (self.observer) [NSNotificationCenter.defaultCenter removeObserver:self.observer];
    self.observer = [NSNotificationCenter.defaultCenter addObserverForName:kRefreshConfigBKNotification object:self.context queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull notification) {
        ZLBuilderContext *ctx = notification.object;
        if (!weakSelf || !ctx) return;
        NSDictionary *userInfo = notification.userInfo;
        if (![userInfo isKindOfClass:NSDictionary.class]) return;
        UIView *view = [userInfo objectForKey:@"view"];
        if (!view || ![view isKindOfClass:UIView.class]) return;
        if (![weakSelf.view isDescendantOfView:view]) return;
        
        if (weakSelf.viewModel) {
            void(^bk)(UIView *,id) = [weakSelf.viewModelBlocksInfo objectForKey:weakSelf.viewModel];
            if (bk) {
                bk(weakSelf.view,weakSelf.viewModel);
            }
        }
        
        if (weakSelf.viewModelCls
                && weakSelf.viewModel
                && ![weakSelf.viewModel isKindOfClass:weakSelf.viewModelCls]) {
                return;
        }
        if (weakSelf.didUpdateViewModelBlock){
            weakSelf.didUpdateViewModelBlock(weakSelf.view,weakSelf.viewModel,YES);
        }
    }];
}
- (void)refreshConfigBK {
    NSMutableDictionary *userInfo = NSMutableDictionary.dictionary;
    [userInfo setValue:self.view forKey:@"view"];
    [NSNotificationCenter.defaultCenter postNotificationName:kRefreshConfigBKNotification object:self.context userInfo:userInfo];
}

- (void)updateViewModelWithSuperViewTag:(NSInteger)tag {
    UIView *superView = self.view.superview;
    while (superView && superView.tag != tag) {
        superView = superView.superview;
    }
    if (superView && superView.tag == tag) {
        [superView.kfc updateViewModel];
    }
}
- (void)updateViewModelWithChildViewTag:(NSInteger)tag {
    UIView *childView = [self.view viewWithTag:tag];
    if (childView) [childView.kfc updateViewModel];
}

- (instancetype)dismissPopViewWhenTap {
    if ([self.view isKindOfClass:UIButton.class]) {
        UIButton *btn = (UIButton *)self.view;
        btn.kfc.touchUpAction(^(UIButton * _Nonnull button) {
            [button.kfc.popView dismiss];
        });
    }else if([self.view isKindOfClass:UIView.class]) {
        self.view.kfc.tapAction(^(UIView * _Nonnull view) {
            [view.kfc.popView dismiss];
        });
    }
    return self;
}
- (instancetype )becomeFirstResponderWhenPopViewAppear{
    self.isFirstResponder = YES;
    return self;
}
- (id  _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))marge {
    return ^id (CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
        self.margeViewInset = UIEdgeInsetsMake(top, left, bottom, right);
        return self;
    };
}
- (instancetype (^)(CGFloat ))margeAll {
    return ^ZLBaseConfigure* (CGFloat m) {
        self.margeViewInset = UIEdgeInsetsMake(m, m, m, m);
        return self;
    };
}
- (instancetype (^)(CGFloat ))margeTop {
    return ^ZLBaseConfigure* (CGFloat marge) {
        self.margeViewInset = UIEdgeInsetsMake(marge, self.margeViewInset.left, self.margeViewInset.bottom, self.margeViewInset.right);
        return self;
    };
}
- (instancetype (^)(CGFloat ))margeBottom {
    return ^ZLBaseConfigure* (CGFloat marge) {
        self.margeViewInset = UIEdgeInsetsMake(self.margeViewInset.top, self.margeViewInset.left, marge, self.margeViewInset.right);
        return self;
    };
}
- (instancetype (^)(CGFloat ))margeLeading {
    return ^ZLBaseConfigure* (CGFloat marge) {
        self.margeViewInset = UIEdgeInsetsMake(self.margeViewInset.top, marge, self.margeViewInset.bottom, self.margeViewInset.right);
        return self;
    };
}
- (instancetype (^)(CGFloat ))margeTrailing {
    return ^ZLBaseConfigure* (CGFloat marge) {
        self.margeViewInset = UIEdgeInsetsMake(self.margeViewInset.top, self.margeViewInset.left, self.margeViewInset.bottom, marge);
        return self;
    };
}
- (instancetype (^)(CGFloat ))margeHorizontal {
    return ^ZLBaseConfigure* (CGFloat marge) {
        self.margeViewInset = UIEdgeInsetsMake(self.margeViewInset.top, marge, self.margeViewInset.bottom, marge);
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat, CGFloat))margeHorLT {
    return ^id (CGFloat leading, CGFloat trailing) {
        self.margeViewInset = UIEdgeInsetsMake(self.margeViewInset.top, leading, self.margeViewInset.bottom, trailing);
        return self;
    };
}
- (instancetype (^)(CGFloat ))margeVertical {
    return ^ZLBaseConfigure* (CGFloat marge) {
        self.margeViewInset = UIEdgeInsetsMake(marge, self.margeViewInset.left, marge, self.margeViewInset.right);
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat, CGFloat))margeVerTB {
    return ^id (CGFloat top, CGFloat bottom) {
        self.margeViewInset = UIEdgeInsetsMake(top, self.margeViewInset.left, bottom, self.margeViewInset.right);
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))layoutMargins {
    return ^id (CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
        if (@available(iOS 11.0, *)) {
            self.view.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(top, left, bottom, right);
        } else {
            self.view.layoutMargins = UIEdgeInsetsMake(top, left, bottom, right);
        }
        if ([self.view isKindOfClass:UIStackView.class]) {
            UIStackView *stackView = (UIStackView *)self.view;
            stackView.layoutMarginsRelativeArrangement = YES;
        }
        return self;
    };
}
- (instancetype (^)(CGFloat ))topLeftCorner {
    return ^ZLBaseConfigure* (CGFloat cornerRadius) {
        if (@available(iOS 11.0, *)) {
            self.view.layer.maskedCorners = kCALayerMinXMinYCorner;
        } else {
            // Fallback on earlier versions
        }
        self.view.layer.cornerRadius = cornerRadius;
        self.view.layer.masksToBounds = YES;
        return self;
    };
}
- (instancetype (^)(CGFloat ))topRightCorner {
    return ^ZLBaseConfigure* (CGFloat cornerRadius) {
        if (@available(iOS 11.0, *)) {
            self.view.layer.maskedCorners = kCALayerMaxXMinYCorner;
        } else {
            // Fallback on earlier versions
        }
        self.view.layer.cornerRadius = cornerRadius;
        self.view.layer.masksToBounds = YES;
        return self;
    };
}
- (instancetype (^)(CGFloat ))bottomLeftCorner {
    return ^ZLBaseConfigure* (CGFloat cornerRadius) {
        if (@available(iOS 11.0, *)) {
            self.view.layer.maskedCorners = kCALayerMinXMaxYCorner;
        } else {
            // Fallback on earlier versions
        }
        self.view.layer.cornerRadius = cornerRadius;
        self.view.layer.masksToBounds = YES;
        return self;
    };
}
- (instancetype (^)(CGFloat ))bottomRightCorner {
    return ^ZLBaseConfigure* (CGFloat cornerRadius) {
        if (@available(iOS 11.0, *)) {
            self.view.layer.maskedCorners = kCALayerMaxXMaxYCorner;
        } else {
            // Fallback on earlier versions
        }
        self.view.layer.cornerRadius = cornerRadius;
        self.view.layer.masksToBounds = YES;
        return self;
    };
}
- (instancetype (^)(CGFloat ))topCorners {
    return ^ZLBaseConfigure* (CGFloat cornerRadius) {
        if (@available(iOS 11.0, *)) {
            self.view.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
        } else {
            // Fallback on earlier versions
        }
        self.view.layer.cornerRadius = cornerRadius;
        self.view.layer.masksToBounds = YES;
        return self;
    };
}
- (instancetype (^)(CGFloat ))bottomCorners {
    return ^ZLBaseConfigure* (CGFloat cornerRadius) {
        if (@available(iOS 11.0, *)) {
            self.view.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
        } else {
            // Fallback on earlier versions
        }
        self.view.layer.cornerRadius = cornerRadius;
        self.view.layer.masksToBounds = YES;
        return self;
    };
}

#pragma mark 布局
- (void)translatesAutoresizingMaskIntoConstraints:(BOOL)translatesAutoresizingMaskIntoConstraints {
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    if (self.view.translatesAutoresizingMaskIntoConstraints != translatesAutoresizingMaskIntoConstraints) {
        self.view.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints;
    }
}
- (void)deactivieConstraints:(NSLayoutAttribute)attribute relation:(NSLayoutRelation)relation {
    [self.view.constraints enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof NSLayoutConstraint * _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
        if (constraint.firstAttribute == attribute &&
            [constraint.firstItem isEqual:self.view] &&
            constraint.relation == relation &&
            constraint.secondItem == nil) {
            constraint.active = NO;
            [self.view removeConstraint:constraint];
        }
    }];
}
- (id  _Nonnull (^)(UIView * _Nonnull))addedToSuperview {
    return ^id (UIView *superview) {
        if ([superview isKindOfClass:UIView.class] && ![superview isEqual:self.view]) {
            [superview addSubview:self.view];
        }
        return self;
    };
}
- (id  _Nonnull (^)(UIView * _Nonnull, NSInteger))insertedToSuperview {
    return ^id (UIView *superview,NSInteger index) {
        if ([superview isKindOfClass:UIView.class] && ![superview isEqual:self.view]) {
            [superview insertSubview:self.view atIndex:index];
        }
        return self;
    };
}
- (id  _Nonnull (^)(ViewLayoutType _Nullable, CGFloat))topTo {
    return ^id (ViewLayoutType _Nullable view, CGFloat c) {
        view = view ?: self.view.superview;
        id anchor = [view isKindOfClass:UIView.class] ? ((UIView *)view).topAnchor : view;
        [self translatesAutoresizingMaskIntoConstraints:NO];
        [[self.view.topAnchor constraintEqualToAnchor:anchor constant:c] gm_enableActive];
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))top {
    return ^id (CGFloat c) {
        return self.topTo(self.view.superview,c);
    };
}

- (id  _Nonnull (^)(ViewLayoutType _Nullable, CGFloat))bottomTo {
    return ^id (ViewLayoutType _Nullable view, CGFloat c) {
        view = view ?: self.view.superview;
        id anchor = [view isKindOfClass:UIView.class] ? ((UIView *)view).bottomAnchor : view;
        [self translatesAutoresizingMaskIntoConstraints:NO];
        [[self.view.bottomAnchor constraintEqualToAnchor:anchor constant:c] gm_enableActive];
        return self;
    };
}

- (id  _Nonnull (^)(CGFloat))bottom {
    return ^id (CGFloat c) {
        return self.bottomTo(self.view.superview,c);
    };
}

- (id  _Nonnull (^)(ViewLayoutType _Nullable, CGFloat))leadingTo {
    return ^id (ViewLayoutType _Nullable view, CGFloat c) {
        view = view ?: self.view.superview;
        id anchor = [view isKindOfClass:UIView.class] ? ((UIView *)view).leadingAnchor : view;
        [self translatesAutoresizingMaskIntoConstraints:NO];
        [[self.view.leadingAnchor constraintEqualToAnchor:anchor constant:c] gm_enableActive];
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))leading {
    return ^id (CGFloat c) {
        return self.leadingTo(self.view.superview,c);
    };
}

- (id  _Nonnull (^)(ViewLayoutType _Nullable, CGFloat))trailingTo {
    return ^id (ViewLayoutType _Nullable view, CGFloat c) {
        view = view ?: self.view.superview;
        id anchor = [view isKindOfClass:UIView.class] ? ((UIView *)view).trailingAnchor : view;
        [self translatesAutoresizingMaskIntoConstraints:NO];
        [[self.view.trailingAnchor constraintEqualToAnchor:anchor constant:c] gm_enableActive];
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))trailing {
    return ^id (CGFloat c) {
        return self.trailingTo(self.view.superview,c);
    };
}
- (id  _Nonnull (^)(UIView * _Nullable))centerTo {
    return ^id (UIView *  _Nullable view) {
        self.centerX(0);
        self.centerY(0);
        return self;
    };
}
- (id  _Nonnull (^)(ViewLayoutType _Nullable, CGFloat))centerXTo {
    return ^id (ViewLayoutType _Nullable view, CGFloat c) {
        view = view ?: self.view.superview;
        id anchor = [view isKindOfClass:UIView.class] ? ((UIView *)view).centerXAnchor : view;
        [self translatesAutoresizingMaskIntoConstraints:NO];
        [[self.view.centerXAnchor constraintEqualToAnchor:anchor constant:c] gm_enableActive];
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))centerX {
    return ^id (CGFloat c) {
        return self.centerXTo(self.view.superview,c);
    };
}

- (id  _Nonnull (^)(ViewLayoutType _Nullable, CGFloat))centerYTo {
    return ^id (ViewLayoutType _Nullable view, CGFloat c) {
        view = view ?: self.view.superview;
        id anchor = [view isKindOfClass:UIView.class] ? ((UIView *)view).centerYAnchor : view;
        [self translatesAutoresizingMaskIntoConstraints:NO];
        [[self.view.centerYAnchor constraintEqualToAnchor:anchor constant:c] gm_enableActive];
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))centerY {
    return ^id (CGFloat c) {
        return self.centerYTo(self.view.superview,c);
    };
}
- (id  _Nonnull (^)(ViewLayoutType _Nonnull))heightEqTo {
    return ^id (ViewLayoutType _Nullable view) {
        if (!view) return self;
        id anchor = [view isKindOfClass:UIView.class] ? ((UIView *)view).heightAnchor : view;
        [self translatesAutoresizingMaskIntoConstraints:NO];
        [[self.view.heightAnchor constraintEqualToAnchor:anchor constant:0] gm_enableActive];
        return self;
    };
}

- (id  _Nonnull (^)(ViewLayoutType _Nonnull))widthEqTo {
    return ^id (ViewLayoutType _Nullable view) {
        if (!view) return self;
        id anchor = [view isKindOfClass:UIView.class] ? ((UIView *)view).widthAnchor : view;
        [self translatesAutoresizingMaskIntoConstraints:NO];
        [[self.view.widthAnchor constraintEqualToAnchor:anchor constant:0] gm_enableActive];
        return self;
    };
}

- (id  _Nonnull (^)(UIView *view, CGFloat, CGFloat, CGFloat, CGFloat))edgeTo   {
    return ^id (UIView * view, CGFloat t,CGFloat l,CGFloat b,CGFloat trailing) {
        view = view ?: self.view.superview;
        [self translatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [self.view.topAnchor constraintEqualToAnchor:view.topAnchor constant:t],
            [self.view.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:l],
            [self.view.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:b],
            [self.view.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:trailing],
        ]];
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))edge {
    return ^id (CGFloat t,CGFloat l,CGFloat b,CGFloat trailing) {
        return self.edgeTo(self.view.superview,t,l,b,trailing);
    };
}
- (id  _Nonnull (^)(void))edgeZero {
    return ^id (void) {
        return self.edge(0,0,0,0);
    };
}
- (NSLayoutConstraint *)topToView:(UIView *)view offset:(CGFloat)offset {
    if (!view) return nil;
    [self translatesAutoresizingMaskIntoConstraints:NO];
    return [self.view.topAnchor constraintEqualToAnchor:view.topAnchor constant:offset].gm_enableActive;
}
- (NSLayoutConstraint *)bottomToView:(UIView *)view offset:(CGFloat)offset {
    if (!view) return nil;
    [self translatesAutoresizingMaskIntoConstraints:NO];
    return [self.view.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:offset].gm_enableActive;
}
- (NSLayoutConstraint *)leadingToView:(UIView *)view offset:(CGFloat)offset {
    if (!view) return nil;
    [self translatesAutoresizingMaskIntoConstraints:NO];
    return [self.view.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:offset].gm_enableActive;
}
- (NSLayoutConstraint *)trailingToView:(UIView *)view offset:(CGFloat)offset {
    if (!view) return nil;
    
    [self translatesAutoresizingMaskIntoConstraints:NO];
    return [self.view.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:offset].gm_enableActive;
}
- (NSLayoutConstraint *)setViewWidth:(CGFloat)width {
    [self translatesAutoresizingMaskIntoConstraints:NO];
    [self deactivieConstraints:NSLayoutAttributeWidth relation:NSLayoutRelationEqual];
    return [self.view.widthAnchor constraintEqualToConstant:width].gm_enableActive;
}
- (NSLayoutConstraint *)setViewHeight:(CGFloat)height {
    [self translatesAutoresizingMaskIntoConstraints:NO];
    [self deactivieConstraints:NSLayoutAttributeHeight relation:NSLayoutRelationEqual];
    return [self.view.heightAnchor constraintEqualToConstant:height].gm_enableActive;
}
- (NSLayoutConstraint *)setViewHeightEqualToView:(UIView *)view {
    [self translatesAutoresizingMaskIntoConstraints:NO];
    return [self.view.heightAnchor constraintEqualToAnchor:view.heightAnchor].gm_enableActive;
}
- (NSLayoutConstraint *)setViewWidthEqualToView:(UIView *)view{
    [self translatesAutoresizingMaskIntoConstraints:NO];
    return [self.view.widthAnchor constraintEqualToAnchor:view.widthAnchor].gm_enableActive;
}
- (NSArray<NSLayoutConstraint *> *)centerInView:(UIView *)view {
    if (!view) return nil;
    [self translatesAutoresizingMaskIntoConstraints:NO];
    return @[[self.view.centerXAnchor constraintEqualToAnchor:view.centerXAnchor].gm_enableActive,
             [self.view.centerYAnchor constraintEqualToAnchor:view.centerYAnchor].gm_enableActive];
}

- (NSLayoutConstraint *)centerXToView:(UIView *)view offset:(CGFloat)offset {
    if (!view) return nil;
    [self translatesAutoresizingMaskIntoConstraints:NO];
    return [self.view.centerXAnchor constraintEqualToAnchor:view.centerXAnchor constant:offset].gm_enableActive;
}

- (NSLayoutConstraint *)centerYToView:(UIView *)view offset:(CGFloat)offset {
    if (!view) return nil;
    [self translatesAutoresizingMaskIntoConstraints:NO];
    return [self.view.centerYAnchor constraintEqualToAnchor:view.centerYAnchor constant:offset].gm_enableActive;
}
- (NSArray<NSLayoutConstraint *> *)centerInView:(UIView *)view centerOffset:(CGPoint)centerOffset {
    if (!view) return nil;
    [self translatesAutoresizingMaskIntoConstraints:NO];
    return @[[self.view.centerXAnchor constraintEqualToAnchor:view.centerXAnchor constant:centerOffset.x].gm_enableActive,
             [self.view.centerYAnchor constraintEqualToAnchor:view.centerYAnchor constant:centerOffset.y].gm_enableActive];
}
- (NSArray<NSLayoutConstraint *> *)edgeToView:(UIView *)view edge:(UIEdgeInsets)edge {
    if (!view) return nil;
    [self translatesAutoresizingMaskIntoConstraints:NO];
    return @[
        [self.view.topAnchor constraintEqualToAnchor:view.topAnchor constant:edge.top].gm_enableActive,
        [self.view.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:edge.left].gm_enableActive,
        [self.view.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:edge.bottom].gm_enableActive,
        [self.view.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:edge.right].gm_enableActive
    ];
}
- (instancetype)removeAllConstraints{
    UIView *view = self.view;
    // 1. 移除自身约束
    [view removeConstraints:view.constraints];

    // 2. 移除父视图中引用该 view 的约束
    UIView *superView = view.superview;
    if (!superView) return self;

    NSMutableArray *toRemove = [NSMutableArray array];
    for (NSLayoutConstraint *constraint in superView.constraints) {
        if (constraint.firstItem == view ||
            constraint.secondItem == view) {
            [toRemove addObject:constraint];
        }
    }
    [superView removeConstraints:toRemove];
    return self;
}
- (instancetype (^)(CGFloat ))height{
    return ^ZLBaseConfigure* (CGFloat height) {
        [[self setViewHeight:height] gm_enableActive];
        return self;
    };
}
- (instancetype (^)(CGFloat ))width{
    return ^ZLBaseConfigure* (CGFloat width) {
        [[self setViewWidth:width] gm_enableActive];
        return self;
    };
}
- (instancetype (^)(CGFloat ))minHeight{
    return ^ZLBaseConfigure* (CGFloat height) {
        [self translatesAutoresizingMaskIntoConstraints:NO];
        [self deactivieConstraints:NSLayoutAttributeHeight relation:NSLayoutRelationGreaterThanOrEqual];
        [self.view.heightAnchor constraintGreaterThanOrEqualToConstant:height].active = YES;
        return self;
    };
}
- (instancetype (^)(CGFloat ))minWidth{
    return ^ZLBaseConfigure* (CGFloat width) {
        [self translatesAutoresizingMaskIntoConstraints:NO];
        [self deactivieConstraints:NSLayoutAttributeWidth relation:NSLayoutRelationGreaterThanOrEqual];
        [self.view.widthAnchor constraintGreaterThanOrEqualToConstant:width].active = YES;
        return self;
    };
}
- (instancetype (^)(CGFloat ))maxHeight{
    return ^ZLBaseConfigure* (CGFloat height) {
        [self translatesAutoresizingMaskIntoConstraints:NO];
        [self deactivieConstraints:NSLayoutAttributeHeight relation:NSLayoutRelationLessThanOrEqual];
        [self.view.heightAnchor constraintLessThanOrEqualToConstant:height].active = YES;
        return self;
    };
}
- (instancetype (^)(CGFloat ))maxWidth{
    return ^ZLBaseConfigure* (CGFloat width) {
        [self translatesAutoresizingMaskIntoConstraints:NO];
        [self deactivieConstraints:NSLayoutAttributeWidth relation:NSLayoutRelationLessThanOrEqual];
        [self.view.widthAnchor constraintLessThanOrEqualToConstant:width].active = YES;
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))size {
    return ^id (CGFloat wh) {
        self.width(wh);
        self.height(wh);
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat,CGFloat))sizeWH {
    return ^id (CGFloat w,CGFloat h) {
        self.width(w);
        self.height(h);
        return self;
    };
}
- (instancetype (^)(NSInteger ))tag {
    return  ^ZLBaseConfigure*(NSInteger tag){
        self.view.tag = tag;
        return self;
    };
}

- (id  _Nonnull (^)(UILayoutPriority))verCompressionPriority {
    return ^id (UILayoutPriority priority) {
        [self.view setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisVertical];
        return self;
    };
}
- (id  _Nonnull (^)(UILayoutPriority))horCompressionPriority {
    return ^id (UILayoutPriority priority) {
        [self.view setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisHorizontal];
        return self;
    };
}
- (id  _Nonnull (^)(UILayoutPriority))verHuggingPriority {
    return ^id (UILayoutPriority priority) {
        [self.view setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisVertical];
        return self;
    };
}
- (id  _Nonnull (^)(UILayoutPriority))horHuggingPriority {
    return ^id (UILayoutPriority priority) {
        [self.view setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisHorizontal];
        return self;
    };
}
- (instancetype (^)(id ))backgroundColor {
    return  ^ZLBaseConfigure*(UIColor *color){
        self.view.backgroundColor = __UIColorFromObj(color);
        return self;
    };
}
- (id  _Nonnull (^)(void (^ _Nonnull)(__kindof UIView * _Nonnull)))applyStyleBK {
    return ^id (void(^block)(__kindof UIView *view)) {
        if (block) block(self.view);
        return self;
    };
}
- (instancetype)whiteBgColor {
    return self.backgroundColor(UIColor.whiteColor);
}
- (instancetype)blackBgColor {
    return self.backgroundColor(UIColor.blackColor);
}
- (instancetype)clearBgColor {
    return self.backgroundColor(UIColor.clearColor);
}
- (id  _Nonnull (^)(UIViewContentMode))contentMode {
    return ^id (UIViewContentMode mode) {
        self.view.contentMode = mode;
        return self;
    };
}
- (instancetype (^)(CGFloat ))cornerRadius {
    return  ^ZLBaseConfigure*(CGFloat cornerRadius){
        self.view.layer.cornerRadius = cornerRadius;
        self.view.layer.masksToBounds = YES;
        return self;
    };
}
- (void (^)(void))Void {
    return ^{};
}
- (instancetype)roundCorner{
    if (!self.isObservedBounds) {
        self.view.layer.masksToBounds = YES;
        self.view.layer.cornerRadius = MIN(self.view.bounds.size.width, self.view.bounds.size.height) / 2.0;
        [self.view addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
        self.isObservedBounds = YES;
    }
    return self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"bounds"] && [object isEqual:self.view]) {
        self.view.layer.cornerRadius = MIN(self.view.bounds.size.width, self.view.bounds.size.height) / 2.0;
    }
}

- (instancetype (^)(id ))borderColor {
    return  ^ZLBaseConfigure*(id color){
        self.view.layer.borderColor = __UIColorFromObj(color).CGColor;
        return self;
    };
}
- (instancetype (^)(CGFloat ))borderWidth {
    return  ^ZLBaseConfigure*(CGFloat width){
        self.view.layer.borderWidth = width;
        return self;
    };
}


#pragma mark - 子类配置
- (id (^)(CGFloat ))spacing {
    return ^ZLBaseConfigure* (CGFloat spacing) {
        self.layoutInStackView.spacing(spacing);
        return self;
    };
}
- (id (^)(CGFloat ))frontSpacing {
    return ^ZLBaseConfigure* (CGFloat spacing) {
        self.layoutInStackView.frontSpaceing(spacing);
        return self;
    };
}
- (id )startAlignment {
    [self.layoutInStackView startAlignment];
    return self;
}
- (id )endAlignment {
    [self.layoutInStackView endAlignment];
    return self;
}
- (id )centerAlignment {
    [self.layoutInStackView centerAlignment];
    return self;
}
- (instancetype)fillAlignment {
    [self.layoutInStackView fillAlignment];
    return self;
}
- (id  (^)(CGFloat marge))startAlign {
    return ^ZLBaseConfigure* (CGFloat marge) {
        self.layoutInStackView.startAlign(marge);
        return self;
    };
}
- (id  (^)(CGFloat marge))endAlign {
    return ^ZLBaseConfigure* (CGFloat marge) {
        self.layoutInStackView.endAlign(marge);
        return self;
    };
}
- (id  (^)(CGFloat offsetY))centerAlign {
    return ^ZLBaseConfigure* (CGFloat offsetY) {
        self.layoutInStackView.centerAlign(offsetY);
        return self;
    };
}
- (id (^)(ZLCrossAxisAlignment ))align {
    return ^ZLBaseConfigure* (ZLCrossAxisAlignment alignment) {
        self.layoutInStackView.align(alignment);
        return self;
    };
}
- (ZLCrossAxisAlignment)alignment {
    return self.layoutInStackView.alignment;
}
- (CGFloat)alignmentMarge {
    return self.layoutInStackView.alignmentMarge;
}

#pragma mark 线条
- (ZLSeparatorView *)_gm_createSepView {
    ZLSeparatorView *sepView = ZLSeparatorView.new;
    sepView.view = self.view;
    return sepView;
}
- (ZLSeparatorView *)topSeparator {
    ZLSeparatorView *view = [self.view viewWithTag:kTopSeparatorTag];
    if ([view isKindOfClass:ZLSeparatorView.class] && [view.superview isEqual:self.view]) return view;
    return [self _gm_createSepView].top;
}
- (instancetype)addTopSeparator {
    [self topSeparator];
    return self;
}
- (ZLSeparatorView *)bottomSeparator {
    ZLSeparatorView *view = [self.view viewWithTag:kBottomSeparatorTag];
    if ([view isKindOfClass:ZLSeparatorView.class] && [view.superview isEqual:self.view]) return view;
    return [self _gm_createSepView].bottom;
}
- (instancetype)addBottomSeparator {
    [self bottomSeparator];
    return self;
}
- (ZLSeparatorView *)leadingSeparator {
    ZLSeparatorView *view = [self.view viewWithTag:kLeadingSeparatorTag];
    if ([view isKindOfClass:ZLSeparatorView.class] && [view.superview isEqual:self.view]) return view;
    return [self _gm_createSepView].leading;
}
- (instancetype)addLeadingSeparator {
    [self leadingSeparator];
    return self;
}
- (ZLSeparatorView *)trailingSeparator {
    ZLSeparatorView *view = [self.view viewWithTag:kTrailingSeparatorTag];
    if ([view isKindOfClass:ZLSeparatorView.class] && [view.superview isEqual:self.view]) return view;
    return [self _gm_createSepView].trailing;
}
- (instancetype)addTrailingSeparator {
    [self trailingSeparator];
    return self;
}
- (void)dealloc
{
    if (self.observer) [NSNotificationCenter.defaultCenter removeObserver:self.observer];
    if (self.isObservedBounds) [self.view removeObserver:self forKeyPath:@"bounds"];
#ifdef DEBUG
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
#else
#endif
}
@end

@implementation ZLUIViewConfigure
@end


@implementation ZLUILabelConfigure
@dynamic enableConfigBK;
@dynamic disableConfigBK;
@dynamic updateViewModelBK;
@dynamic applyStyleBK;
- (ZLUILabelConfigure* (^)(UIFont *))font {
    return  ^ZLUILabelConfigure*(UIFont *font){
        self.view.font = font;
        return self;
    };
}
- (ZLUILabelConfigure* (^)(CGFloat))systemFontSize {
    return  ^ZLUILabelConfigure*(CGFloat fontSize){
        self.view.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}
- (ZLUILabelConfigure* (^)(CGFloat))systemFontSizeMedium {
    return  ^ZLUILabelConfigure*(CGFloat fontSize){
        self.view.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium];
        return self;
    };
}

- (ZLUILabelConfigure* (^)(id))textColor {
    return  ^ZLUILabelConfigure*(id color){
        self.view.textColor = __UIColorFromObj(color);
        return self;
    };
}

- (ZLUILabelConfigure* (^)(NSString *))text {
    return  ^ZLUILabelConfigure*(NSString *title){
        self.view.text = title;
        return self;
    };
}
- (ZLUILabelConfigure* (^)(NSTextAlignment ))textAlignment {
    return  ^ZLUILabelConfigure*(NSTextAlignment alignment){
        self.view.textAlignment = alignment;
        return self;
    };
}
- (instancetype)textAlignmentCenter {
    self.view.textAlignment = NSTextAlignmentCenter;
    return self;
}
- (instancetype)textAlignmentLeft {
    self.view.textAlignment = NSTextAlignmentLeft;
    return self;
}
- (instancetype)textAlignmentRight {
    self.view.textAlignment = NSTextAlignmentRight;
    return self;
}
- (ZLUILabelConfigure* (^)(NSAttributedString *))attributedText {
    return  ^ZLUILabelConfigure*(NSAttributedString *attr){
        self.view.attributedText = attr;
        return self;
    };
}
- (ZLUILabelConfigure* (^)(NSInteger ))numberOfLines{
    return  ^ZLUILabelConfigure*(NSInteger numberOfLines){
        self.view.numberOfLines = numberOfLines;
        return self;
    };
}

- (ZLUILabelConfigure* (^)(CGFloat ))preferredMaxLayoutWidth{
    return  ^ZLUILabelConfigure*(CGFloat maxWidth){
        self.view.preferredMaxLayoutWidth = maxWidth;
        return self;
    };
}
- (instancetype)multipleLines {
    self.view.numberOfLines = 0;
    return self;
}
- (instancetype)singleLine {
    self.view.numberOfLines = 1;
    return self;
}
- (instancetype)twoLines {
    self.view.numberOfLines = 2;
    return self;
}
- (instancetype)blackTextColor {
    self.view.textColor = UIColor.blackColor;
    return self;
}
- (instancetype)whiteTextColor {
    self.view.textColor = UIColor.whiteColor;
    return self;
}
- (instancetype)redTextColor {
    self.view.textColor = UIColor.redColor;
    return self;
}
@end

@interface ZLUITextFieldConfigure()

@end

@implementation ZLUITextFieldConfigure
@dynamic enableConfigBK;
@dynamic disableConfigBK;
@dynamic updateViewModelBK;
@dynamic applyStyleBK;

- (ZLUITextFieldConfigure* (^)(UIFont *))font{
    return  ^ZLUITextFieldConfigure*(UIFont *font){
        self.view.font = font;
        return self;
    };
}
- (ZLUITextFieldConfigure* (^)(CGFloat))systemFontSize {
    return  ^ZLUITextFieldConfigure*(CGFloat fontSize){
        self.view.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}
- (ZLUITextFieldConfigure* (^)(CGFloat))systemFontSizeMedium {
    return  ^ZLUITextFieldConfigure*(CGFloat fontSize){
        self.view.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium];
        return self;
    };
}
- (ZLUITextFieldConfigure* (^)(id ))textColor {
    return  ^ZLUITextFieldConfigure*(id color){
        self.view.textColor = __UIColorFromObj(color);
        return self;
    };
}
- (ZLUITextFieldConfigure* (^)(NSString *))text {
    return  ^ZLUITextFieldConfigure*(NSString *title){
        self.view.text = title;
        return self;
    };
}
- (ZLUITextFieldConfigure* (^)(NSTextAlignment ))textAlignment {
    return  ^ZLUITextFieldConfigure*(NSTextAlignment alignment){
        self.view.textAlignment = alignment;
        return self;
    };
}
- (instancetype)textAlignmentCenter {
    self.view.textAlignment = NSTextAlignmentCenter;
    return self;
}
- (instancetype)textAlignmentLeft {
    self.view.textAlignment = NSTextAlignmentLeft;
    return self;
}
- (instancetype)textAlignmentRight {
    self.view.textAlignment = NSTextAlignmentRight;
    return self;
}
- (ZLUITextFieldConfigure* (^)(NSString *))placeholder {
    return  ^ZLUITextFieldConfigure*(NSString* placeholder){
        self.view.placeholder = placeholder;
        return self;
    };
}
- (ZLUITextFieldConfigure * _Nonnull (^)(UITextFieldViewMode))clearButtonMode {
    return ^ZLUITextFieldConfigure* (UITextFieldViewMode mode) {
        self.view.clearButtonMode = mode;
        return self;
    };
}
- (ZLUITextFieldConfigure * _Nonnull (^)(UIKeyboardType))keyboardType {
    return ^ZLUITextFieldConfigure* (UIKeyboardType type) {
        self.view.keyboardType = type;
        return self;
    };
}
- (ZLUITextFieldConfigure * _Nonnull (^)(UIReturnKeyType))returnKeyType {
    return ^ZLUITextFieldConfigure* (UIReturnKeyType type) {
        self.view.returnKeyType = type;
        return self;
    };
}
- (ZLUITextFieldConfigure * _Nonnull (^)(CGFloat))leftPadding {
    return ^ZLUITextFieldConfigure* (CGFloat padding) {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(padding, 0), 1)];
        self.view.leftView = leftView;
        self.view.leftViewMode = UITextFieldViewModeAlways;
        return self;
    };
}
@end




@implementation ZLUITextViewConfigure
@dynamic enableConfigBK;
@dynamic disableConfigBK;
@dynamic updateViewModelBK;
@dynamic applyStyleBK;

@end

@interface ZLUIButtonConfigure()

@end
@implementation ZLUIButtonConfigure
@dynamic enableConfigBK;
@dynamic disableConfigBK;
@dynamic updateViewModelBK;
@dynamic applyStyleBK;

- (ZLUIButtonConfigure* (^)(UIFont *))titleFont {
    return  ^ZLUIButtonConfigure*(UIFont *font){
        self.view.titleLabel.font = font;
        return self;
    };
}
- (ZLUIButtonConfigure* (^)(CGFloat))titleSystemFontSize {
    return  ^ZLUIButtonConfigure*(CGFloat fontSize){
        self.view.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}
- (ZLUIButtonConfigure* (^)(CGFloat))titleSystemFontSizeMedium {
    return  ^ZLUIButtonConfigure*(CGFloat fontSize){
        self.view.titleLabel.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium];
        return self;
    };
}
- (ZLUIButtonConfigure* (^)(id ))titleColor {
    return  ^ZLUIButtonConfigure*(id color){
        [self.view setTitleColor:__UIColorFromObj(color) forState:UIControlStateNormal];
        return self;
    };
}
- (ZLUIButtonConfigure* (^)(id ,UIControlState))titleColorForState {
    return  ^ZLUIButtonConfigure*(id color,UIControlState state){
        [self.view setTitleColor:__UIColorFromObj(color) forState:state];
        return self;
    };
}
- (ZLUIButtonConfigure* (^)(BOOL ))selected {
    return  ^ZLUIButtonConfigure*(BOOL selected){
        self.view.selected = selected;
        return self;
    };
}
- (ZLUIButtonConfigure* (^)(NSString *))title {
    return  ^ZLUIButtonConfigure*(NSString *title){
        [self.view setTitle:title forState:UIControlStateNormal];
        return self;
    };
}
- (ZLUIButtonConfigure* (^)(NSString *,UIControlState))titleForState {
    return  ^ZLUIButtonConfigure*(NSString *title,UIControlState state){
        [self.view setTitle:title forState:state];
        return self;
    };
}
- (ZLUIButtonConfigure* (^)(NSTextAlignment ))titleAlignment {
    return  ^ZLUIButtonConfigure*(NSTextAlignment alignment){
        self.view.titleLabel.textAlignment = alignment;
        return self;
    };
}
- (instancetype)titleAlignmentCenter {
    self.view.titleLabel.textAlignment = NSTextAlignmentCenter;
    return self;
}
- (instancetype)titleAlignmentLeft {
    self.view.titleLabel.textAlignment = NSTextAlignmentLeft;
    return self;
}
- (instancetype)titleAlignmentRight {
    self.view.titleLabel.textAlignment = NSTextAlignmentRight;
    return self;
}
- (ZLUIButtonConfigure* (^)(id))highlightBgColor {
    return  ^ZLUIButtonConfigure*(id color){
        UIColor *bgColor = __UIColorFromObj(color);
        if (!bgColor) return self;
        [self.view setBackgroundImage:bgColor.image forState:UIControlStateHighlighted];
        return self;
    };
}
- (instancetype)defaultHighlightBgColor {
    UIColor *color;
    if (@available(iOS 13.0, *)) {
        color = [UIColor systemGray6Color];
    } else {
        color = [UIColor colorWithWhite:0.97 alpha:1.0f];
    }
    return self.highlightBgColor(color);
}
- (ZLUIButtonConfigure* (^)(id  ,UIControlState state))imageForState {
    return  ^ZLUIButtonConfigure*(id image,UIControlState state){
        UIImage *img = nil;
        if ([image isKindOfClass:UIImage.class]) {
            img = image;
        }else if ([image isKindOfClass:NSString.class]) {
            img = [UIImage imageNamed:(NSString *)image];
        }
        [self.view setImage:img forState:state];
        return self;
    };
}
- (ZLUIButtonConfigure * _Nonnull (^)(id _Nonnull))image {
    return ^ZLUIButtonConfigure* (id image) {
        return self.imageForState(image, UIControlStateNormal);
    };
}
- (ZLUIButtonConfigure * _Nonnull (^)(id _Nonnull))imageForSelected {
    return ^ZLUIButtonConfigure* (id image) {
        return self.imageForState(image, UIControlStateSelected);
    };
}
- (ZLUIButtonConfigure* )touchUpAction:(void(^)(UIButton *button))block add:(BOOL)isAdd{
    if (isAdd) {
        [self.touchUpActionObj addBlock:block];
    }else {
        self.touchUpActionObj.block = block;
    }
    [self.view addTarget:self.touchUpActionObj action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}
- (ZLUIButtonConfigure * _Nonnull (^)(void (^ _Nonnull)(UIButton * _Nonnull)))touchUpAction {
    return ^ZLUIButtonConfigure* (void(^block)(UIButton *button)) {
        return [self touchUpAction:block add:NO];
    };
}
- (ZLUIButtonConfigure * _Nonnull (^)(void (^ _Nonnull)(UIButton * _Nonnull)))addTouchUpAction {
    return ^ZLUIButtonConfigure* (void(^block)(UIButton *button)) {
        return [self touchUpAction:block add:YES];
    };
}

- (instancetype)blackTitleColor {
    [self.view setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    return self;
}
- (instancetype)whiteTitleColor {
    [self.view setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    return self;
}
@end


@implementation ZLUIImageViewConfigure
@dynamic applyStyleBK;

- (ZLUIImageViewConfigure * (^)(id ))image {
    return  ^ZLUIImageViewConfigure *(id image){
        UIImage *img = nil;
        if ([image isKindOfClass:UIImage.class]) {
            img = image;
        }else if ([image isKindOfClass:UIColor.class]){
            img = ((UIColor *)image).image;
        }else if ([image isKindOfClass:NSString.class]) {
            img = [UIImage imageNamed:(NSString *)image];
            if (!img) {
                UIColor *color = __UIColorFromObj(image);
                img = color.image;
            }
        }
        self.view.image = img;
        return self;
    };
}
@end
@interface ZLUISwitchConfigure()
@property (nonatomic,copy)void(^valueChangedBlock)(UISwitch *sw);
@end
@implementation ZLUISwitchConfigure
@dynamic applyStyleBK;

- (ZLUISwitchConfigure * _Nonnull (^)(BOOL))on {
    return ^ZLUISwitchConfigure* (BOOL isOn) {
        self.view.on = isOn;
        return self;
    };
}
- (ZLUISwitchConfigure * _Nonnull (^)(void (^ _Nonnull)(UISwitch * _Nonnull)))valueChanged {
    return ^ZLUISwitchConfigure* (void(^block)(UISwitch *sw)) {
        [self.view addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.valueChangedBlock = block;
        return self;
    };
}
- (void)switchValueChanged:(UISwitch *)sw {
    if (self.valueChangedBlock) {
        self.valueChangedBlock(sw);
    }
}
@end

@implementation ZLUISliderConfigure
@dynamic applyStyleBK;

@end

@implementation ZLUIStackViewConfigure
@dynamic applyStyleBK;

@end

@implementation ZLUIScrollViewConfigure
@dynamic applyStyleBK;

@end

