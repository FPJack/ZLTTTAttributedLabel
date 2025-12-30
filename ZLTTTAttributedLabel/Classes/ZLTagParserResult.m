//
//  ZLTagMatch.m
//  ZLTTTAttributedLabel
//
//  Created by admin on 2025/12/5.
//

#import "ZLTagParserResult.h"
#import <CoreText/CoreText.h>
@interface ZLTagMatch()
@property (nonatomic,assign)NSInteger idx;
@property (nonatomic,assign)NSRange orgRange;
@property (nonatomic, assign,readonly) NSInteger lengthToSubtract;
@property (nonatomic, strong,readwrite) NSDictionary *attributes;
@end
@implementation ZLTagMatch
- (NSInteger)lengthToSubtract {
    return H_TAG_START.length + H_TAG_END.length + (self.tagId ? self.tagId.length + H_TAG_SEPARATOR_START.length + H_TAG_SEPARATOR_End.length : 0);
}
- (NSTextCheckingResult *)result {
    NSString *text = self.text ?: @"";
    NSString *tagId = self.tagId ?: @"";
    NSString *encodedText = [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSString *encodedTag = [tagId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"action://tap?text=%@&tagId=%@", encodedText, encodedTag]];
    NSTextCheckingResult *result = [NSTextCheckingResult linkCheckingResultWithRange:self.range URL:url];
    return result;
}
- (void)addAttributes:(NSDictionary *)attributes{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithDictionary:attributes];
    UIColor *color = [attributes valueForKey:NSForegroundColorAttributeName];
    if (color) {
        [attrs removeObjectForKey:NSForegroundColorAttributeName];
        attrs[(id)kCTForegroundColorAttributeName] = (id)color;
    }
    self.attributes = attributes;
}
@end

@implementation ZLTagParserResult
+ (instancetype)matchResultsWithStr:(NSString *)input{
    if (!input) return nil;
    NSString* pattern = [NSString stringWithFormat:@"%@(.*?)%@", H_TAG_START, H_TAG_END];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSMutableArray<ZLTagMatch *> *mArr = [NSMutableArray array];
    NSMutableString *output = [input mutableCopy];
    NSArray *matches = [regex matchesInString:output options:0 range:NSMakeRange(0, output.length)];
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        NSRange totalRange = match.range;        // 整个标签范围
        NSRange contentRange = [match rangeAtIndex:1]; // 标签里面文字
        NSString *content = [output substringWithRange:contentRange];
        NSArray<NSString *> *arr = [content componentsSeparatedByString:H_TAG_SEPARATOR_START];
        ZLTagMatch *res = [ZLTagMatch new];
        res.text = arr.firstObject;
        if (arr.count > 1) res.tagId = [arr.lastObject stringByReplacingOccurrencesOfString:H_TAG_SEPARATOR_End withString:@""];
        res.orgRange = NSMakeRange(contentRange.location,contentRange.length - (res.tagId ? res.tagId.length + H_TAG_SEPARATOR_START.length + H_TAG_SEPARATOR_End.length : 0));
        res.idx = mArr.count;
        [mArr addObject:res];
        [output replaceCharactersInRange:totalRange withString:res.text];
    }
    __block NSInteger lengthToSubtract = 0;
    
    NSArray *reverseArr = mArr.reverseObjectEnumerator.allObjects;
    [reverseArr enumerateObjectsUsingBlock:^(ZLTagMatch * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange orgRange = obj.orgRange;
        if (idx == 0) {
            obj.range = NSMakeRange(orgRange.location - H_TAG_START.length, orgRange.length);
        }else {
            obj.range = NSMakeRange(orgRange.location - H_TAG_START.length - lengthToSubtract, orgRange.length);
        }
        lengthToSubtract += obj.lengthToSubtract;
    }];
    
    [mArr enumerateObjectsUsingBlock:^(ZLTagMatch * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
#if DEBUG
        NSLog(@"输出高亮的内容:%@ \n id:%@",[output substringWithRange:obj.range],obj.tagId);
#endif
    }];
    
    ZLTagParserResult *reg = ZLTagParserResult.new;
    reg.results = reverseArr;
    reg.relString = output;
    reg.orgString = input;
#if DEBUG
    NSLog(@"最终输出内容---%@",output);
#endif

    return reg;
}

@end
