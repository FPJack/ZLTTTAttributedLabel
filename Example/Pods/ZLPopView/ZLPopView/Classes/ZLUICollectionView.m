//
//  GMCollectionViewBuilder.m
//  GMPopView
//
//  Created by admin on 2025/8/28.
//

#import "ZLUICollectionView.h"
#import "ZLStackViewBuilder.h"
#import <objc/runtime.h>
#define kPropertyGetterImplementation(type, propertyName) \
- (type *)propertyName { \
    NSString *key = NSStringFromSelector(_cmd); \
    type *view = [self.propertyObjs objectForKey:key]; \
    if (!view) { \
        view = [[type alloc] init]; \
        if (self.superView) { \
            [self.superView addSubview:view]; \
        } \
        [self.propertyObjs setObject:view forKey:key]; \
    } \
    return view; \
}

@interface ZLSubViewObj()
@property (nonatomic,weak)UIView *view;
@property (nonatomic,strong)NSMutableDictionary *propertyObjs;
@end
@implementation ZLSubViewObj
- (void)setDidSetup:(BOOL)didSetup {
    self.propertyObjs[@"didSetup"] = @(didSetup);
}
- (BOOL)didSetup {
    NSNumber *num = self.propertyObjs[@"didSetup"];
    return num.boolValue;
}

- (void)setLayoutSubviewsBlock:(void (^)(id))layoutSubviewsBlock {
    if (layoutSubviewsBlock) {
        self.propertyObjs[@"layoutSubviewsBlock"] = layoutSubviewsBlock;
    }else {
        [self.propertyObjs removeObjectForKey:@"layoutSubviewsBlock"];
    }
}
- (void (^)(id))layoutSubviewsBlock {
    return self.propertyObjs[@"layoutSubviewsBlock"];
}

- (void)setOnceLayoutSubviewsBlock:(void (^)(id))onceLayoutSubviewsBlock {
    if (onceLayoutSubviewsBlock) {
        self.propertyObjs[@"onceLayoutSubviewsBlock"] = onceLayoutSubviewsBlock;
    }else {
        [self.propertyObjs removeObjectForKey:@"onceLayoutSubviewsBlock"];
    }
}
- (void (^)(id))onceLayoutSubviewsBlock {
    return self.propertyObjs[@"onceLayoutSubviewsBlock"];
}

- (void (^)(id))deallocBlock {
    return self.propertyObjs[@"deallocBlock"];
}
- (void)setDeallocBlock:(void (^)(id))deallocBlock {
    if (deallocBlock) {
        self.propertyObjs[@"deallocBlock"] = deallocBlock;
    }else {
        [self.propertyObjs removeObjectForKey:@"deallocBlock"];
    }
}

- (BOOL)layouted {
    NSNumber *num = self.propertyObjs[@"layouted"];
    return num.boolValue;
}
- (void)setLayouted:(BOOL)layouted {
    if(!self.layouted && self.onceLayoutSubviewsBlock){
        self.onceLayoutSubviewsBlock(self.view);
        self.onceLayoutSubviewsBlock = nil;
    }
    self.propertyObjs[@"layouted"] = @(layouted);
}


- (NSMutableDictionary *)propertyObjs {
    if (!_propertyObjs) {
        _propertyObjs = NSMutableDictionary.dictionary;
    }
    return _propertyObjs;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        typeof(self) __weak weakSelf = self;
        self.layoutSubviewsBlock = ^(id view) {
            [weakSelf insertGradLayer];
        };
    }
    return self;
}
- (void)insertGradLayer {
    CALayer *gradLayer = self.propertyObjs[@"gradLayer"];
    if (gradLayer) {
        [self.view.layer insertSublayer:gradLayer atIndex:0];
        gradLayer.frame = self.view.bounds;
    }
}
- (UIView *)superView {
    if ([self.view isKindOfClass:ZLUITableViewCell.class]) {
        return ((ZLUITableViewCell *)self.view).contentView;
    } else if ([self.view isKindOfClass:ZLUITableViewHeaderFooterView.class]) {
        return ((ZLUITableViewHeaderFooterView *)self.view).contentView;
    }else if ([self.view isKindOfClass:ZLUICollectionViewCell.class]) {
        return ((ZLUICollectionViewCell *)self.view).contentView;
    }else {
        return self.view;
    }
}
- (void)initBK:(void (^)(id _Nonnull))block {
    if (block && !self.didSetup) {
        self.didSetup = YES;
        block(self.view);
    }
}
- (ZLSubViewObj * _Nonnull (^)(void (^ _Nonnull)(__kindof UIView * _Nonnull)))initBK {
    return ^ZLSubViewObj *(void (^block)(id view)){
        [self initBK:block];
        return self;
    };
}

- (void)layoutSubviewsBK:(void (^)(id _Nonnull))block{
    typeof(self) __weak weakSelf = self;
    self.layoutSubviewsBlock = ^(id view) {
        [weakSelf insertGradLayer];
        if (block) block(view);
    };
}
- (ZLSubViewObj * _Nonnull (^)(void (^ _Nonnull)(__kindof UIView * _Nonnull)))layoutSubviewsBK {
    return ^ZLSubViewObj *(void (^block)(id view)){
        [self layoutSubviewsBK:block];
        return self;
    };
}
- (void)onceLayoutSubviewsBK:(void(^)(id _Nonnull))block {
    if (!self.layouted) self.onceLayoutSubviewsBlock = block;
}
- (ZLSubViewObj * _Nonnull (^)(void (^ _Nonnull)(__kindof UIView * _Nonnull)))onceLayoutSubviewsBK {
    return ^ZLSubViewObj *(void (^block)(id view)){
        [self onceLayoutSubviewsBK:block];
        return self;
    };
}


kPropertyGetterImplementation(UIStackView, stackView)
kPropertyGetterImplementation(UILabel, textLabel)
kPropertyGetterImplementation(UILabel, detailTextLabel)
kPropertyGetterImplementation(UILabel, customLabel)
kPropertyGetterImplementation(UIButton, textButton)
kPropertyGetterImplementation(UIButton, imageButton)
kPropertyGetterImplementation(UIButton, accessoryButton)
kPropertyGetterImplementation(UIButton, customButton)
kPropertyGetterImplementation(UIImageView, imageView)
kPropertyGetterImplementation(UIImageView, backgroundImageView)
kPropertyGetterImplementation(UIImageView, customImageView)
kPropertyGetterImplementation(UIView, backgroundView)
kPropertyGetterImplementation(UIView, accessoryView)
kPropertyGetterImplementation(UIView, customView)
kPropertyGetterImplementation(UITextField, textField)
kPropertyGetterImplementation(UITextView, textView)
kPropertyGetterImplementation(UISwitch, switchView)


- (void)deallocBK:(nonnull void (^)(id))block {
    self.deallocBlock = block;
}
- (ZLSubViewObj * _Nonnull (^)(void (^ _Nonnull)(__kindof UIView * _Nonnull)))deallocBK {
    return ^ZLSubViewObj *(void (^block)(id view)){
        [self deallocBK:block];
        return self;
    };
}

- (CAGradientLayer *)gradLayer {
    CAGradientLayer *layer = self.propertyObjs[@"gradLayer"];
    if (layer) {
        layer = [CAGradientLayer layer];
        layer.startPoint = CGPointMake(0.5, 0); // 中上
        layer.endPoint = CGPointMake(0.5, 1); // 中上
        [self setGradLayer:layer];
    }
    return layer;
}

- (void)setGradLayer:(CAGradientLayer *)gradLayer {
    if (gradLayer) {
        self.propertyObjs[@"gradLayer"] = gradLayer;
    }else {
        [self.propertyObjs removeObjectForKey:@"gradLayer"];
    }
}
- (void)dealloc
{
    if (self.deallocBlock) self.deallocBlock(self.view);
}

@end
@interface ZLUIView()
@property (nonatomic,strong,readwrite)ZLSubViewObj *sv;
@end
@implementation ZLUIView
- (ZLSubViewObj *)sv {
    if (!_sv) {
        _sv = [[ZLSubViewObj alloc] init];
        _sv.view = self;
    }
    return _sv;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.superview || !_sv) return;
    if (self.sv.layoutSubviewsBlock) self.sv.layoutSubviewsBlock(self);
    self.sv.layouted = YES;
}
@end
@interface ZLUICollectionReusableView()
@property (nonatomic,strong,readwrite)ZLSubViewObj *sv;
@end
@implementation ZLUICollectionReusableView
- (ZLSubViewObj *)sv {
    if (!_sv) {
        _sv = [[ZLSubViewObj alloc] init];
        _sv.view = self;
    }
    return _sv;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.superview || !_sv) return;
    if (self.sv.layoutSubviewsBlock) self.sv.layoutSubviewsBlock(self);
    self.sv.layouted = YES;
}
@end
@interface ZLUICollectionViewCell()
@property (nonatomic,strong,readwrite)ZLSubViewObj *sv;
@property (nonatomic,copy)UICollectionViewLayoutAttributes* (^preferredLayoutAttributesFittingAttributesBlock)(ZLUICollectionViewCell *cell,UICollectionViewLayoutAttributes *layoutAttributes);
@end
@implementation ZLUICollectionViewCell
- (ZLSubViewObj *)sv {
    if (!_sv) {
        _sv = [[ZLSubViewObj alloc] init];
        _sv.view = self;
    }
    return _sv;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.superview || !_sv) return;
    if (self.sv.layoutSubviewsBlock) self.sv.layoutSubviewsBlock(self);
    self.sv.layouted = YES;
}
- (void)preferredLayoutAttributesFittingAttributesBK:(UICollectionViewLayoutAttributes *(^)(ZLUICollectionViewCell *cell,UICollectionViewLayoutAttributes *layoutAttributes))block {
    self.preferredLayoutAttributesFittingAttributesBlock = block;
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    if (self.preferredLayoutAttributesFittingAttributesBlock) {
        return self.preferredLayoutAttributesFittingAttributesBlock(self,attributes);
    }
    return attributes;
}
- (UICollectionViewLayoutAttributes *)sizeForCellWithLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes estimatedItemSize:(CGSize)size{
    CGSize newSize = [self.contentView systemLayoutSizeFittingSize:size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.height = newSize.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}
@end

@interface ZLUITableViewCell()
@property (nonatomic,strong,readwrite)ZLSubViewObj<ZLUITableViewCell *> *sv;
@end
@implementation ZLUITableViewCell
- (ZLSubViewObj *)sv {
    if (!_sv) {
        _sv = [[ZLSubViewObj alloc] init];
        _sv.view = self;
    }
    return _sv;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.superview || !_sv) return;
    if (self.sv.layoutSubviewsBlock) self.sv.layoutSubviewsBlock(self);
    self.sv.layouted = YES;
}
@end
@interface ZLUITableViewHeaderFooterView()
@property (nonatomic,strong,readwrite)ZLSubViewObj<ZLUITableViewHeaderFooterView *> *sv;
@end
@implementation ZLUITableViewHeaderFooterView
- (ZLSubViewObj *)sv {
    if (!_sv) {
        _sv = [[ZLSubViewObj alloc] init];
        _sv.view = self;
    }
    return _sv;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.superview || !_sv) return;
    if (self.sv.layoutSubviewsBlock) self.sv.layoutSubviewsBlock(self);
    self.sv.layouted = YES;
}
@end



@interface ZLUICollectionViewFlowLayout : UICollectionViewFlowLayout
@end
@implementation ZLUICollectionViewFlowLayout
- (BOOL)flipsHorizontallyInOppositeLayoutDirection {
    return  [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UIView.appearance.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft;
}
@end
@interface ZLUICollectionView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,copy)RCSIndexPathBlock headerForSectionBlock;
@property (nonatomic,copy)RCSIndexPathBlock footerForSectionBlock;
@property (nonatomic,copy)CCIndexPathBlock cellForItemAtIndexPathBlock;
@property (nonatomic,copy)ICIntegerBlock numberOfItemsInSectionBlock;
@property (nonatomic,copy)ICBlock numberOfSectionsInCollectionViewBlock;
@property (nonatomic,copy)SCIndexPathBlock itemSizeBlock;
@property (nonatomic,copy)SCIntegerBlock headerSizeBlock;
@property (nonatomic,copy)SCIntegerBlock footerSizeBlock;
@property (nonatomic,copy)ECIntegerBlock insetForSectionAtIndexBlock;
@property (nonatomic,copy)FCIntegerBlock minimumLineSpacingForSectionAtIndexBlock;
@property (nonatomic,copy)FCIntegerBlock minimumInteritemSpacingForSectionAtIndexBlock;
@property (nonatomic,copy)VCIndexPathBlock didSelectItemAtIndexPathBlock;
@property (nonatomic,copy)ICIntegerBlock columnForSectionBlock;
@property (nonatomic,copy)VCBlock layoutSubviewsBlock;
@property (nonatomic,copy)VCCIndexPathBlock didDequeueReusableCellBlock;
@property (nonatomic,copy)VCRIndexPathBlock didDequeueReusableHeaderBlock;
@property (nonatomic,copy)VCRIndexPathBlock didDequeueReusableFooterBlock;
@property (nonatomic,assign) CGSize itemSize;
@end
@implementation ZLUICollectionView
- (UIUserInterfaceLayoutDirection)effectiveUserInterfaceLayoutDirection {
    return  [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UIView.appearance.semanticContentAttribute];
}
+ (ZLUICollectionViewFlowLayout *)layout:(UICollectionViewScrollDirection)direction {
    ZLUICollectionViewFlowLayout *layout = [[ZLUICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = direction;
    return layout;
}
+ (instancetype)vertical {
    return  [[ZLUICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self layout:UICollectionViewScrollDirectionVertical]];
}
+ (instancetype)horizontal {
    return [[ZLUICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[self layout:UICollectionViewScrollDirectionHorizontal]];
}
+ (ZLUICollectionView * (^)(UICollectionViewLayout *layout))collectionViewWithLayout {
    return ^ZLUICollectionView *(UICollectionViewLayout *layout){
        ZLUICollectionView *collectionView = [[ZLUICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        return collectionView;
    };
}
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:ZLUICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(ZLUICollectionViewCell.class)];
       [self registerClass:ZLUICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(ZLUICollectionReusableView.class)];
        [self registerClass:ZLUICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(ZLUICollectionReusableView.class)];
    }
    return self;
}
- (instancetype)registerCellOrResableViewBK:(VCBlock)block {
    if (block) block(self);
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(VCBlock _Nonnull))registerCellOrResableViewBK {
    return ^ZLUICollectionView *(VCBlock block){
        return [self registerCellOrResableViewBK:block];
    };
}

- (ZLUICollectionView *(^)(NSInteger))setColumn {
    return ^(NSInteger column){
        self.columnForSectionBlock = ^NSInteger(ZLUICollectionView *collectionView, NSInteger section) {
            return column;
        };
        return self;
    };
}
- (ZLUICollectionView *(^)(NSInteger))setSectionCount {
    return ^(NSInteger count){
        self.numberOfSectionsInCollectionViewBlock = ^NSInteger(ZLUICollectionView *collectionView) {
            return count;
        };
        return self;
    };
}
- (ZLUICollectionView *(^)(NSInteger))setNumberOfItemsInSection {
    return ^(NSInteger count){
        self.numberOfItemsInSectionBlock = ^NSInteger(ZLUICollectionView *collectionView, NSInteger section) {
            return count;
        };
        return self;
    };
}
- (ZLUICollectionView *(^)(CGSize))setCellSize {
    __weak typeof(self) weakSelf = self;
    return ^(CGSize size){
        weakSelf.itemSize = size;
        self.itemSizeBlock = ^CGSize(ZLUICollectionView *collectionView, NSIndexPath *indexPath) {
            return weakSelf.itemSize;
        };
        return self;
    };
}
- (ZLUICollectionView *(^)(CGFloat))setCellWidth {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat width){
        weakSelf.itemSize = CGSizeMake(width, weakSelf.itemSize.height);
        self.itemSizeBlock = ^CGSize(ZLUICollectionView *collectionView, NSIndexPath *indexPath) {
            return weakSelf.itemSize;
        };
        return self;
    };
}
- (ZLUICollectionView *(^)(CGFloat))setCellHeight {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat height){
        weakSelf.itemSize = CGSizeMake(weakSelf.itemSize.width,height);
        self.itemSizeBlock = ^CGSize(ZLUICollectionView *collectionView, NSIndexPath *indexPath) {
            return weakSelf.itemSize;
        };
        return self;
    };
}
- (ZLUICollectionView *(^)(CGSize))setHeaderSize {
    return ^(CGSize size){
        self.headerSizeBlock = ^CGSize(ZLUICollectionView *collectionView, NSInteger section) {
            return size;
        };
        return self;
    };
}
- (ZLUICollectionView *(^)(CGSize))setFooterSize {
    return ^(CGSize size){
        self.footerSizeBlock = ^CGSize(ZLUICollectionView *collectionView, NSInteger section) {
            return size;
        };
        return self;
    };
}
- (ZLUICollectionView *(^)(UIEdgeInsets))setViewContentInset {
    return ^(UIEdgeInsets inset){
        self.contentInset = inset;
        return self;
    };
}
- (ZLUICollectionView *(^)(BOOL ))setAlwaysBounceVer {
    return ^(BOOL bounce){
        self.alwaysBounceVertical = bounce;
        return self;
    };
}
- (ZLUICollectionView *(^)(BOOL ))setAlwaysBounceHor {
    return ^(BOOL bounce){
        self.alwaysBounceHorizontal = bounce;
        return self;
    };
}
- (ZLUICollectionView *(^)(UIEdgeInsets))setSectionInset {
    return ^(UIEdgeInsets inset){
        self.insetForSectionAtIndexBlock = ^UIEdgeInsets(ZLUICollectionView *collectionView, NSInteger section) {
            return inset;
        };
        return self;
    };
}
- (ZLUICollectionView *(^)(CGFloat))setMinLineSpacing {
    return ^(CGFloat spacing){
        self.minimumLineSpacingForSectionAtIndexBlock = ^CGFloat(ZLUICollectionView *collectionView, NSInteger section) {
            return spacing;
        };
        return self;
    };
}
- (ZLUICollectionView *(^)(CGFloat))setMinInterSpacing {
    return ^(CGFloat spacing){
        self.minimumInteritemSpacingForSectionAtIndexBlock = ^CGFloat(ZLUICollectionView *collectionView, NSInteger section) {
            return spacing;
        };
        return self;
    };
}
- (ZLUICollectionView *(^)(CGSize))setAutomaticItemSize {
    return ^(CGSize size){
        if ([self.collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
            UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
            flowLayout.estimatedItemSize = size;
        }
        return self;
    };
}
- (ZLUICollectionView *(^)(Class cls,NSString* cellID))registerCellClass {
    return ^(Class cls, NSString *cellID){
        [self registerClass:cls forCellWithReuseIdentifier:cellID];
        return self;
    };
}
- (ZLUICollectionView *(^)(Class cls,NSString* headerID))registerHeaderClass {
    return ^(Class cls, NSString *headerID){
        [self registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
        return self;
    };
}
- (ZLUICollectionView *(^)(Class cls,NSString* footerID))registerFooterClass {
    return ^(Class cls, NSString *footerID){
        [self registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerID];
        return self;
    };
}
- (ZLUICollectionView *(^)(UINib * nib,NSString* cellID))registerCellNib {
    return ^(UINib *nib, NSString *cellID){
        [self registerNib:nib forCellWithReuseIdentifier:cellID];
        return self;
    };
}
- (ZLUICollectionView *(^)(UINib *nib,NSString* headerID))registerHeaderNib {
    return ^(UINib *nib, NSString *headerID){
        [self registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
        return self;
    };
}
- (ZLUICollectionView *(^)(UINib *nib,NSString* footerID))registerFooterNib {
    return ^(UINib *nib, NSString *footerID){
        [self registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerID];
        return self;
    };
}
- (instancetype)columnForSectionBK:(ICIntegerBlock)block {
    self.columnForSectionBlock = block;
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(ICIntegerBlock _Nonnull))columnForSectionBK {
    return ^ZLUICollectionView *(ICIntegerBlock block){
        return [self columnForSectionBK:block];
    };
}
///header
- (instancetype)headerForSectionBK:(RCSIndexPathBlock)block {
    self.headerForSectionBlock = block;
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(RCSIndexPathBlock _Nonnull))headerForSectionBK {
    return ^ZLUICollectionView *(RCSIndexPathBlock block){
        return [self headerForSectionBK:block];
    };
}
- (instancetype)configureReusableHeaderBK:(VCRIndexPathBlock)block {
    self.didDequeueReusableHeaderBlock = block;
    return self;
}
///footer
- (instancetype)footerForSectionBK:(RCSIndexPathBlock)block{
    self.footerForSectionBlock = block;
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(RCSIndexPathBlock _Nonnull))footerForSectionBK {
    return ^ZLUICollectionView *(RCSIndexPathBlock block){
        return [self footerForSectionBK:block];
    };
}
- (instancetype)configureReusableFooterBK:(VCRIndexPathBlock)block {
    self.didDequeueReusableFooterBlock = block;
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(VCRIndexPathBlock _Nonnull))configureReusableFooterBK {
    return ^ZLUICollectionView *(VCRIndexPathBlock block){
        return [self configureReusableFooterBK:block];
    };
}
/// cellForItemAtIndexPath
- (instancetype)cellForItemAtIndexPathBK:(CCIndexPathBlock)block {
    self.cellForItemAtIndexPathBlock = block;
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(CCIndexPathBlock _Nonnull))cellForItemAtIndexPathBK {
    return ^ZLUICollectionView *(CCIndexPathBlock block){
        return [self cellForItemAtIndexPathBK:block];
    };
}
- (instancetype)configureReusableCellBK:(VCCIndexPathBlock)block {
    self.didDequeueReusableCellBlock = block;
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(VCCIndexPathBlock _Nonnull))configureReusableCellBK {
    return ^ZLUICollectionView *(VCCIndexPathBlock block){
        return [self configureReusableCellBK:block];
    };
}
///numberOfItemsInSection
- (instancetype)numberOfItemsInSectionBK:(ICIntegerBlock)block {
    self.numberOfItemsInSectionBlock = block;
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(ICIntegerBlock _Nonnull))numberOfItemsInSectionBK {
    return ^ZLUICollectionView *(ICIntegerBlock block){
        return [self numberOfItemsInSectionBK:block];
    };
}
///numberOfSectionsInCollectionView
- (instancetype)numberOfSectionsBK:(ICBlock)block {
    self.numberOfSectionsInCollectionViewBlock = block;
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(ICBlock _Nonnull))numberOfSectionsBK {
    return ^ZLUICollectionView *(ICBlock block){
        return [self numberOfSectionsBK:block];
    };
}
///itemSize
- (instancetype)itemSizeBK:(SCIndexPathBlock)block {
    self.itemSizeBlock = block;
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(SCIndexPathBlock _Nonnull))itemSizeBK {
    return ^ZLUICollectionView *(SCIndexPathBlock block){
        return [self itemSizeBK:block];
    };
}
///headerSize
- (instancetype)headerSizeBK:(SCIntegerBlock)block {
    self.headerSizeBlock = block;
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(SCIntegerBlock _Nonnull))headerSizeBK {
    return ^ZLUICollectionView *(SCIntegerBlock block){
        return [self headerSizeBK:block];
    };
}
///footerSize
- (instancetype)footerSizeBK:(SCIntegerBlock)block {
    self.footerSizeBlock = block;
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(SCIntegerBlock _Nonnull))footerSizeBK {
    return ^ZLUICollectionView *(SCIntegerBlock block){
        return [self footerSizeBK:block];
    };
}
///insetForSectionAtIndex
- (instancetype)insetForSectionAtIndexBK:(ECIntegerBlock)block {
    self.insetForSectionAtIndexBlock = block;
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(ECIntegerBlock _Nonnull))insetForSectionAtIndexBK{
    return ^ZLUICollectionView *(ECIntegerBlock block){
        return [self insetForSectionAtIndexBK:block];
    };
}
///minimumLineSpacingForSectionAtIndex
- (instancetype)minimumLineSpacingForSectionAtIndexBK:(FCIntegerBlock)block {
    self.minimumLineSpacingForSectionAtIndexBlock = block;
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(FCIntegerBlock _Nonnull))minimumLineSpacingForSectionAtIndexBK {
    return ^ZLUICollectionView *(FCIntegerBlock block){
        return [self minimumLineSpacingForSectionAtIndexBK:block];
    };
}
///minimumInteritemSpacingForSectionAtIndex
- (instancetype)minimumInteritemSpacingForSectionAtIndexBK:(FCIntegerBlock)block {
    self.minimumInteritemSpacingForSectionAtIndexBlock = block;
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(FCIntegerBlock _Nonnull))minimumInteritemSpacingForSectionAtIndexBK {
    return ^ZLUICollectionView *(FCIntegerBlock block){
        return [self minimumInteritemSpacingForSectionAtIndexBK:block];
    };
}
///didSelectItemAtIndexPath
- (instancetype)didSelectItemAtIndexPathBK:(VCIndexPathBlock)block {
    self.didSelectItemAtIndexPathBlock = block;
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(VCIndexPathBlock _Nonnull))didSelectItemAtIndexPathBK {
    return ^ZLUICollectionView *(VCIndexPathBlock block){
        return [self didSelectItemAtIndexPathBK:block];
    };
}
- (instancetype)layoutSubviewsBK:(VCBlock)block {
    self.layoutSubviewsBlock = block;
    return self;
}
- (ZLUICollectionView * _Nonnull (^)(VCBlock _Nonnull))layoutSubviewsBK{
    return ^ZLUICollectionView *(VCBlock block){
        return [self layoutSubviewsBK:block];
    };
}
#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.numberOfSectionsInCollectionViewBlock) return self.numberOfSectionsInCollectionViewBlock(self);
    return 1;
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.numberOfItemsInSectionBlock) return self.numberOfItemsInSectionBlock(self,section);
    return 0;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view;
        if (self.headerForSectionBlock) {
            view = self.headerForSectionBlock(self,kind,indexPath);
        }else {
            view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(ZLUICollectionReusableView.class) forIndexPath:indexPath];
        }
        if (self.didDequeueReusableHeaderBlock) self.didDequeueReusableHeaderBlock(self,view,indexPath);
        return view;
    }else {
        UICollectionReusableView *view;
        if (self.footerForSectionBlock) {
            view = self.footerForSectionBlock(self,kind,indexPath);
        }else {
            view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(ZLUICollectionReusableView.class) forIndexPath:indexPath];
        }
        if (self.didDequeueReusableFooterBlock) self.didDequeueReusableFooterBlock(self,view,indexPath);
        return view;
    }
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if (self.cellForItemAtIndexPathBlock) {
        cell = self.cellForItemAtIndexPathBlock(self,indexPath);
    }else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ZLUICollectionViewCell.class) forIndexPath:indexPath];
    }
    if (self.didDequeueReusableCellBlock) self.didDequeueReusableCellBlock(self,cell,indexPath);
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectItemAtIndexPathBlock) self.didSelectItemAtIndexPathBlock(self,indexPath);
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.columnForSectionBlock) {
        NSInteger column = self.columnForSectionBlock(self,indexPath.section);
        if (column > 0) {
            CGFloat totalSpacing = 0;
            if ([collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
                CGFloat minimumInteritemSpacing;
                if ([collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
                    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
                    if (flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                        minimumInteritemSpacing = [self collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:indexPath.section];
                    }else {
                        minimumInteritemSpacing = [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:indexPath.section];
                    }
                }else {
                    minimumInteritemSpacing = [self collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:indexPath.section];
                }
                totalSpacing += minimumInteritemSpacing * (column - 1);
                UIEdgeInsets sectionInset = [self collectionView:self layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
                totalSpacing += sectionInset.left + sectionInset.right;
                totalSpacing += self.contentInset.left + self.contentInset.right;
            }
            CGFloat itemWidth = (collectionView.bounds.size.width - totalSpacing) / column;
            return CGSizeMake(floor(itemWidth), self.itemSize.height > 0 ? self.itemSize.height : itemWidth);
        }
    }
    CGSize size = self.itemSizeBlock ? self.itemSizeBlock(self,indexPath) : CGSizeZero;
    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.insetForSectionAtIndexBlock ? self.insetForSectionAtIndexBlock(self,section) : UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.minimumLineSpacingForSectionAtIndexBlock ? self.minimumLineSpacingForSectionAtIndexBlock(self,section) : 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.minimumInteritemSpacingForSectionAtIndexBlock ? self.minimumInteritemSpacingForSectionAtIndexBlock(self,section) : 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return self.headerSizeBlock ? self.headerSizeBlock(self,section) : CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return self.footerSizeBlock ? self.footerSizeBlock(self,section) : CGSizeZero;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.layoutSubviewsBlock) self.layoutSubviewsBlock(self);
}
@end

