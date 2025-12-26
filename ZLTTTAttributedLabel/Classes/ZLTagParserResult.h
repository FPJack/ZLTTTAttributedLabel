//
//  ZLTagMatch.h
//  ZLTTTAttributedLabel
//
//  Created by admin on 2025/12/5.
//

#import <Foundation/Foundation.h>

#define H_TAG_START @"<h>"
#define H_TAG_END   @"<h/>"
#define H_TAG_SEPARATOR_START @"["
#define H_TAG_SEPARATOR_End @"]"
/*
 这里有<h>这是高亮内容1[1]<h/>，还有<h>这是高亮内容2<h/> 标签内da容还有<h>这是高亮内容3<h/>标签内容
 */
NS_ASSUME_NONNULL_BEGIN

@interface ZLTagMatch : NSObject
@property (nonatomic,assign)NSRange range;
@property (nonatomic,copy)NSString *text;
@property (nonatomic,copy)NSString *tagId;
@property (nonatomic,strong)NSTextCheckingResult *result;

@property (nonatomic, strong,readonly) NSDictionary *attributes;
- (void)addAttributes:(NSDictionary *)attributes;
@end

@interface ZLTagParserResult : NSObject
@property (nonatomic,strong)NSArray<ZLTagMatch *> *results;
@property (nonatomic,copy)NSString * relString;
@property (nonatomic,copy)NSString * orgString;
+ (instancetype)matchResultsWithStr:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
