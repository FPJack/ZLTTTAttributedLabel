//
//  ZLTTTAttributedLabel.h
//  ZLTTTAttributedLabel
//
//  Created by admin on 2025/12/5.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "ZLTagParserResult.h"
NS_ASSUME_NONNULL_BEGIN
@interface ZLURLItem : NSObject
@property (nonatomic,copy)NSString *urlString;
@property (nonatomic,copy)NSString *tagId;
@property (nonatomic,copy)NSString *text;
@property (nonatomic,copy)NSString *host;
@property (nonatomic,copy)NSString *scheme;
@property (nonatomic,copy)NSString *path;
@end
@interface ZLTTTAttributedLabel : TTTAttributedLabel

- (instancetype)initWithTagParserResult:(ZLTagParserResult *)parserResult
                             attributes:(void (^ _Nullable)(NSMutableAttributedString *mutableAttributedString))block
                    highlightAttributes:(void(^ _Nullable)(NSArray<ZLTagMatch *>  *items))highlightBlock
                              tapAction:(void (^ _Nullable)(ZLURLItem *item))tapAction;

- (instancetype)initWithText:(NSString *)text
                  numberOfLines:(NSInteger)numberOfLines
                  attributes:(NSDictionary *)attributes
         highlightAttributes:(NSDictionary *)highlightAttributes
                    tapActionBK:(void (^ _Nullable)(ZLURLItem *item))tapAction;

- (instancetype)initWithText:(NSString *)text
                numberOfLines:(NSInteger)numberOfLines
                  attributes:(NSDictionary *)attributes
       highlightAttributesBK:(void(^ _Nullable)(NSArray<ZLTagMatch *>  *items))highlightBlock
                    tapActionBK:(void (^ _Nullable)(ZLURLItem *item))tapAction;

- (instancetype)initWithText:(NSString *)text
                    attributesBK:(void (^ _Nullable)(NSMutableAttributedString *mutableAttributedString))block
           highlightAttributesBK:(void(^ _Nullable)(NSArray<ZLTagMatch *>  *items))highlightBlock
                    tapActionBK:(void (^ _Nullable)(ZLURLItem *item))tapAction;
@end

NS_ASSUME_NONNULL_END
