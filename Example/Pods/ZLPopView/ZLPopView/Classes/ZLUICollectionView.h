//
//  GMCollectionViewBuilder.h
//  GMPopView
//
//  Created by admin on 2025/8/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//UICollectionViewCompositionalLayout iOS 13.0+
//https://cloud.tencent.com/developer/article/1645580
NS_ASSUME_NONNULL_BEGIN
@class ZLUICollectionView;
typedef UICollectionReusableView* _Nullable (^RCSIndexPathBlock)(ZLUICollectionView *collectionView,NSString* kind, NSIndexPath *indexPath);
typedef UICollectionViewCell* _Nullable (^CCIndexPathBlock)(ZLUICollectionView *collectionView,  NSIndexPath *indexPath);
typedef NSInteger(^ICIntegerBlock)(ZLUICollectionView *collectionView, NSInteger section);
typedef NSInteger(^ICBlock)(ZLUICollectionView *collectionView);
typedef void(^VCBlock)(ZLUICollectionView *collectionView);
typedef CGSize (^SCIndexPathBlock)(ZLUICollectionView *collectionView, NSIndexPath *indexPath);
typedef CGSize (^SCIntegerBlock)(ZLUICollectionView *collectionView, NSInteger section);
typedef UIEdgeInsets (^ECIntegerBlock)(ZLUICollectionView *collectionView, NSInteger section);
typedef CGFloat (^FCIntegerBlock)(ZLUICollectionView *collectionView, NSInteger section);
typedef void(^VCIndexPathBlock)(ZLUICollectionView *collectionView, NSIndexPath *indexPath);

typedef void(^VCCIndexPathBlock)(ZLUICollectionView *collectionView,UICollectionViewCell *cell, NSIndexPath *indexPath);
typedef void(^VCRIndexPathBlock)(ZLUICollectionView *collectionView,UICollectionReusableView *reusableView, NSIndexPath *indexPath);

@interface ZLSubViewObj<__covariant ObjectType>: NSObject

@property (nonatomic,strong,readonly)UIStackView *stackView;
@property (nonatomic,strong,readonly)UIView *backgroundView;
@property (nonatomic,strong,readonly)UIView *accessoryView;
@property (nonatomic,strong,readonly)UIView *customView;
@property (nonatomic,strong,readonly)UILabel *textLabel;
@property (nonatomic,strong,readonly)UILabel *detailTextLabel;
@property (nonatomic,strong,readonly)UILabel *customLabel;
@property (nonatomic,strong,readonly)UIButton *textButton;
@property (nonatomic,strong,readonly)UIButton *imageButton;
@property (nonatomic,strong,readonly)UIButton *accessoryButton;
@property (nonatomic,strong,readonly)UIButton *customButton;
@property (nonatomic,strong,readonly)UIImageView *imageView;
@property (nonatomic,strong,readonly)UIImageView *backgroundImageView;
@property (nonatomic,strong,readonly)UIImageView *customImageView;
@property (nonatomic,strong,readonly)UITextField *textField;
@property (nonatomic,strong,readonly)UITextView *textView;
@property (nonatomic,strong,readonly)UISwitch *switchView;

///是否已经调用过 layoutSubviews 方法对应是否调用onceLayoutSubviewsBK
@property (nonatomic,assign,readonly)BOOL layouted;
///渐变层
@property (nonatomic,strong,readonly)CAGradientLayer *gradLayer;

@property(nonatomic,readonly)ZLSubViewObj* (^initBK)(void(^block)(__kindof UIView* view));
@property(nonatomic,readonly)ZLSubViewObj* (^layoutSubviewsBK)(void(^block)(__kindof UIView* view));
@property(nonatomic,readonly)ZLSubViewObj* (^onceLayoutSubviewsBK)(void(^block)(__kindof UIView* view));
@property(nonatomic,readonly)ZLSubViewObj* (^deallocBK)(void(^block)(__kindof UIView* view));
/// 可以在里面做一次性初始化布局
- (void)initBK:(void(^)(ObjectType view))block;
/// View layoutSubviews布局回调
- (void)layoutSubviewsBK:(void(^)(ObjectType view))block;
/// View layoutSubviews布局回调，只调用一次
- (void)onceLayoutSubviewsBK:(void(^)(ObjectType view))block;
/// View dealloc回调
- (void)deallocBK:(void(^)(ObjectType view))block;

@end
@interface ZLUIView : UIView
@property (nonatomic,strong,readonly)ZLSubViewObj<ZLUIView *> *sv;
@end
@interface ZLUICollectionReusableView : UICollectionReusableView
@property (nonatomic,strong,readonly)ZLSubViewObj<ZLUICollectionReusableView *> *sv;
@end
@interface ZLUICollectionViewCell : UICollectionViewCell
@property (nonatomic,strong,readonly)ZLSubViewObj<ZLUICollectionViewCell *> *sv;
///自动计算高度的时候调用
- (void)preferredLayoutAttributesFittingAttributesBK:(UICollectionViewLayoutAttributes *(^)(ZLUICollectionViewCell *cell,UICollectionViewLayoutAttributes *layoutAttributes))block;
///自动计算高度的时候返回这个值
- (UICollectionViewLayoutAttributes *)sizeForCellWithLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes estimatedItemSize:(CGSize)size;
@end
@interface ZLUITableViewCell : UITableViewCell
@property (nonatomic,strong,readonly)ZLSubViewObj<ZLUITableViewCell *> *sv;
@end
@interface ZLUITableViewHeaderFooterView : UITableViewHeaderFooterView
@property (nonatomic,strong,readonly)ZLSubViewObj<ZLUITableViewHeaderFooterView *> *sv;
@end



@interface ZLUICollectionView : UICollectionView
///默认配置
+ (instancetype)vertical;
+ (instancetype)horizontal;

+ (ZLUICollectionView * (^)(UICollectionViewLayout *layout))collectionViewWithLayout;
///设置layout
@property (nonatomic,readonly) ZLUICollectionView* (^setColumn)(NSInteger);
@property (nonatomic,readonly) ZLUICollectionView* (^setSectionCount)(NSInteger);

@property (nonatomic,readonly) ZLUICollectionView* (^setNumberOfItemsInSection)(NSInteger);

@property (nonatomic,readonly) ZLUICollectionView* (^setCellSize)(CGSize);

@property (nonatomic,readonly) ZLUICollectionView* (^setCellWidth)(CGFloat);

@property (nonatomic,readonly) ZLUICollectionView* (^setCellHeight)(CGFloat);

@property (nonatomic,readonly) ZLUICollectionView* (^setHeaderSize)(CGSize);

@property (nonatomic,readonly) ZLUICollectionView* (^setFooterSize)(CGSize);

@property (nonatomic,readonly) ZLUICollectionView* (^setViewContentInset)(UIEdgeInsets);

@property (nonatomic,readonly) ZLUICollectionView* (^setAlwaysBounceVer)(BOOL);

@property (nonatomic,readonly) ZLUICollectionView* (^setAlwaysBounceHor)(BOOL);

@property (nonatomic,readonly) ZLUICollectionView* (^setSectionInset)(UIEdgeInsets);
@property (nonatomic,readonly) ZLUICollectionView* (^setMinLineSpacing)(CGFloat);

@property (nonatomic,readonly) ZLUICollectionView* (^setMinInterSpacing)(CGFloat);

///自动计算cell高度
@property (nonatomic,readonly) ZLUICollectionView* (^setAutomaticItemSize)(CGSize);

@property (nonatomic,readonly) ZLUICollectionView* (^registerCellClass)(Class cls,NSString* cellID);

@property (nonatomic,readonly) ZLUICollectionView* (^registerHeaderClass)(Class cls,NSString* headerID);

@property (nonatomic,readonly) ZLUICollectionView* (^registerFooterClass)(Class cls,NSString* footerID);

@property (nonatomic,readonly) ZLUICollectionView* (^registerCellNib)(UINib *nib,NSString* cellID);

@property (nonatomic,readonly) ZLUICollectionView* (^registerHeaderNib)(UINib *nib,NSString* headerID);

@property (nonatomic,readonly) ZLUICollectionView* (^registerFooterNib)(UINib *nib,NSString* footerID);

///注册cell和reusableView
- (instancetype)registerCellOrResableViewBK:(VCBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^registerCellOrResableViewBK)(VCBlock block);
///列数
- (instancetype)columnForSectionBK:(ICIntegerBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^columnForSectionBK)(ICIntegerBlock block);
///header
- (instancetype)headerForSectionBK:(RCSIndexPathBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^headerForSectionBK)(RCSIndexPathBlock block);
- (instancetype)configureReusableHeaderBK:(VCRIndexPathBlock)block;
///footer
- (instancetype)footerForSectionBK:(RCSIndexPathBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^footerForSectionBK)(RCSIndexPathBlock block);
- (instancetype)configureReusableFooterBK:(VCRIndexPathBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^configureReusableFooterBK)(VCRIndexPathBlock block);
/// cellForItemAtIndexPath
- (instancetype)cellForItemAtIndexPathBK:(CCIndexPathBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^cellForItemAtIndexPathBK)(CCIndexPathBlock block);

- (instancetype)configureReusableCellBK:(VCCIndexPathBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^configureReusableCellBK)(VCCIndexPathBlock block);
///numberOfItemsInSection
- (instancetype)numberOfItemsInSectionBK:(ICIntegerBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^numberOfItemsInSectionBK)(ICIntegerBlock block);
///numberOfSectionsInCollectionView
- (instancetype)numberOfSectionsBK:(ICBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^numberOfSectionsBK)(ICBlock block);
///itemSize
- (instancetype)itemSizeBK:(SCIndexPathBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^itemSizeBK)(SCIndexPathBlock block);
///headerSize
- (instancetype)headerSizeBK:(SCIntegerBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^headerSizeBK)(SCIntegerBlock block);
///footerSize
- (instancetype)footerSizeBK:(SCIntegerBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^footerSizeBK)(SCIntegerBlock block);
///insetForSectionAtIndex
- (instancetype)insetForSectionAtIndexBK:(ECIntegerBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^insetForSectionAtIndexBK)(ECIntegerBlock block);
///minimumLineSpacingForSectionAtIndex
- (instancetype)minimumLineSpacingForSectionAtIndexBK:(FCIntegerBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^minimumLineSpacingForSectionAtIndexBK)(FCIntegerBlock block);
///minimumInteritemSpacingForSectionAtIndex
- (instancetype)minimumInteritemSpacingForSectionAtIndexBK:(FCIntegerBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^minimumInteritemSpacingForSectionAtIndexBK)(FCIntegerBlock block);
///didSelectItemAtIndexPath
- (instancetype)didSelectItemAtIndexPathBK:(VCIndexPathBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^didSelectItemAtIndexPathBK)(VCIndexPathBlock block);
///layoutSubviews
- (instancetype)layoutSubviewsBK:(VCBlock)block;
@property (nonatomic,readonly) ZLUICollectionView* (^layoutSubviewsBK)(VCBlock block);
@end


NS_ASSUME_NONNULL_END
