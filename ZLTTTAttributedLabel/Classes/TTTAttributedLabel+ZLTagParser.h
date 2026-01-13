//
//  TTTAttributedLabel+ZLTagParser.h
//  ZLTTTAttributedLabel
//
//  Created by admin on 2025/12/31.
//

#import <TTTAttributedLabel/TTTAttributedLabel.h>
#define H_TAG_START @"<h>"
#define H_TAG_END   @"<h/>"
#define H_TAG_SEPARATOR_START @"["
#define H_TAG_SEPARATOR_End @"]"
/*
 这里有<h>这是高亮内容1[1]<h/>，还有<h>这是高亮内容2<h/> 标签内da容还有<h>这是高亮内容3<h/>标签内容
 */
NS_ASSUME_NONNULL_BEGIN

@interface ZLTagMatch : NSObject
///  range 标签在字符串中的位置
@property (nonatomic,assign,readonly)NSRange range;
///  text 标签内的文本内容
@property (nonatomic,copy,readonly)NSString *text;
///  tagId 标签id标识
@property (nonatomic,copy,readonly)NSString *tagId;
///  index 标识第几个匹配
@property (nonatomic,assign,readonly)NSInteger index;
/// 添加属性
- (void)addAttributes:(NSDictionary *)attributes;
/// 添加高亮属性
- (void)addActiveAttributes:(NSDictionary *)attributes;
@end

@interface ZLTagParserResult : NSObject
@property (nonatomic,strong)NSArray<ZLTagMatch *> *results;
@property (nonatomic,copy)NSString * relString;
@property (nonatomic,copy)NSString * orgString;
+ (instancetype)matchResultsWithStr:(NSString *)str;
@end



@interface TTTAttributedLabel (ZLTagParser)
- (instancetype)initWithText:(NSString *)text
               numberOfLines:(NSInteger)numberOfLines
                  attributes:(NSDictionary * _Nullable)attributes
         highlightAttributes:(NSDictionary * _Nullable)highlightAttributes
                 tapActionBK:(void (^ _Nullable)(ZLTagMatch *item))tapAction;

- (instancetype)initWithText:(NSString *)text
               numberOfLines:(NSInteger)numberOfLines
                  attributes:(NSDictionary * _Nullable)attributes
       highlightAttributesBK:(void(^ _Nullable)(NSArray<ZLTagMatch *>  *items))highlightBlock
                 tapActionBK:(void (^ _Nullable)(ZLTagMatch *item))tapAction;
@end

NS_ASSUME_NONNULL_END
