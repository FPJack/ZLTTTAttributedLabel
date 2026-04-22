//
//  TTTAttributedLabel+ZLTagParser.m
//  ZLTTTAttributedLabel
//
//  Created by admin on 2025/12/31.
//

#import "TTTAttributedLabel+ZLTagParser.h"
#import <CoreText/CoreText.h>
@interface ZLTagMatch()
@property (nonatomic,assign)NSRange orgRange;
@property (nonatomic, assign,readonly) NSInteger lengthToSubtract;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, strong) NSDictionary *activeAttributes;
@property (nonatomic,assign,readwrite)NSRange range;
///  text 标签内的文本内容
@property (nonatomic,copy,readwrite,nullable)NSString *text;
///  tagId 标签id标识
@property (nonatomic,copy,readwrite,nullable)NSString *tagId;
///  index 标识第几个匹配
@property (nonatomic,assign,readwrite)NSInteger index;
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
- (void)addActiveAttributes:(NSDictionary *)attributes {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithDictionary:attributes];
    UIColor *color = [attributes valueForKey:NSForegroundColorAttributeName];
    if (color) {
        [attrs removeObjectForKey:NSForegroundColorAttributeName];
        attrs[(id)kCTForegroundColorAttributeName] = (id)color;
    }
    self.activeAttributes = attributes;
}
@end

@implementation ZLTagParserResult
+ (instancetype)matchResultsWithStr:(NSString *)input{
    if (!input) return nil;
    NSString* pattern = [NSString stringWithFormat:@"%@(.*?)%@", H_TAG_START, H_TAG_END];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSMutableArray<ZLTagMatch *> *mArr = [NSMutableArray array];
    NSMutableString *output = [input mutableCopy];
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:output options:0 range:NSMakeRange(0, output.length)];
    [matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult * _Nonnull match, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange totalRange = match.range;        // 整个标签范围
        NSRange contentRange = [match rangeAtIndex:1]; // 标签里面文字
        NSString *content = [output substringWithRange:contentRange];
        NSString *idPattern =
        [NSString stringWithFormat:@"(\\%@[\\s\\S]*\\%@)$",
         H_TAG_SEPARATOR_START,
         H_TAG_SEPARATOR_End];
        NSRegularExpression *regex =
        [NSRegularExpression regularExpressionWithPattern:idPattern
                                                  options:0
                                                    error:nil];
        NSTextCheckingResult *result =
        [regex firstMatchInString:content
                          options:0
                            range:NSMakeRange(0, content.length)];
        ZLTagMatch *res = [ZLTagMatch new];
        res.index = idx;
        if (result.numberOfRanges > 1) {
            NSString *match =
            [content substringWithRange:[result rangeAtIndex:1]];
            res.text = [content substringToIndex:result.range.location];
            res.tagId = [content substringWithRange:NSMakeRange(res.text.length + H_TAG_SEPARATOR_START.length, match.length - H_TAG_SEPARATOR_START.length - H_TAG_SEPARATOR_End.length)];
            res.orgRange = NSMakeRange(contentRange.location,contentRange.length - result.range.length);
            if (content.length == res.text.length + H_TAG_SEPARATOR_START.length + H_TAG_SEPARATOR_End.length + res.tagId.length) {//添加容错判断
                [output replaceCharactersInRange:totalRange withString:res.text];
                [mArr addObject:res];
            }
        }else {
            res.text = content;
            res.orgRange = NSMakeRange(contentRange.location,contentRange.length );
            [output replaceCharactersInRange:totalRange withString:res.text];
            [mArr addObject:res];
        }
        #if DEBUG
            NSLog(@"解析到的内容:%@  id:%@  index:%ld",res.text,res.tagId,res.index);
        #endif
    }];
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
@interface ZLAttrBuilder()
@property (nonatomic, strong) NSMutableDictionary *attrs;

@end
@implementation ZLAttrBuilder
- (instancetype)init {
    if (self = [super init]) {
        _attrs = [NSMutableDictionary dictionary];
    }
    return self;
}
#pragma mark - 链式

- (ZLAttrBuilder *(^)(UIFont *))font {
    return ^(UIFont *font) {
        self.attrs[(id)kCTFontAttributeName] = font;
        return self;
    };
}
- (ZLAttrBuilder * _Nonnull (^)(CGFloat))sysFont {
    return ^(CGFloat fontSize) {
        return self.font([UIFont systemFontOfSize:fontSize]);
    };
}
- (ZLAttrBuilder * _Nonnull (^)(CGFloat, id _Nonnull))sysFontColor {
    return ^(CGFloat fontSize, id color) {
        return self.sysFont(fontSize).textColor(color);
    };
}
- (ZLAttrBuilder * _Nonnull (^)(CGFloat))medFont {
    return ^(CGFloat fontSize) {
        return self.font([UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium]);
    };
}
- (ZLAttrBuilder * _Nonnull (^)(CGFloat, id _Nonnull))medFontColor {
    return ^(CGFloat fontSize, id color) {
        return self.font([UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium]).textColor(color);
    };
}
- (ZLAttrBuilder *(^)(UIColor *))textColor {
    return ^(UIColor *color) {
        self.attrs[(id)kCTForegroundColorAttributeName] = color;
        return self;
    };
}
- (ZLAttrBuilder *(^)(UIColor *))bgColor {
    return ^(UIColor *color) {
        self.attrs[(id)kCTBackgroundColorAttributeName] =  (id)(color.CGColor);
        return self;
    };
}

- (ZLAttrBuilder *(^)(NSUnderlineStyle))underline {
    return ^(NSUnderlineStyle style) {
        self.attrs[(id)kCTUnderlineStyleAttributeName] = @(style);
        return self;
    };
}
- (ZLAttrBuilder * _Nonnull (^)(id _Nonnull))underlineColor {
    return ^(UIColor* color) {
        self.attrs[(id)kCTUnderlineColorAttributeName] = (id)(color.CGColor);
        return self;
    };
}

#pragma mark - build
- (NSDictionary *)buildAttrs {
    return [self.attrs copy];
}
@end

@implementation TTTAttributedLabel (ZLTagParser)
- (instancetype)initWithTagParserResult:(ZLTagParserResult *)parserResult
                             attributes:(void (^ _Nullable)(NSMutableAttributedString *mutableAttributedString))block
                    highlightAttributes:(void(^ _Nullable)(NSArray<ZLTagMatch *>  *items))highlightBlock
                              tapAction:(void (^ _Nullable)(ZLTagMatch *item))tapAction{
    self = [super initWithFrame:CGRectZero];
    self.userInteractionEnabled = YES;
    if (self) {
        [self setText:parserResult.relString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            if (block) {
                block(mutableAttributedString);
            }
            return  mutableAttributedString;
        }];
        __weak typeof(self) weakSelf = self;
        if (highlightBlock) {
            highlightBlock(parserResult.results);
        }
        [parserResult.results enumerateObjectsUsingBlock:^(ZLTagMatch * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TTTAttributedLabelLink *link = [[TTTAttributedLabelLink alloc] initWithAttributes:obj.attributes activeAttributes:obj.activeAttributes ?: obj.attributes inactiveAttributes:nil textCheckingResult:obj.result];
            link.linkTapBlock = ^(TTTAttributedLabel * label,  TTTAttributedLabelLink *link) {
                if (tapAction) tapAction(obj);
            };
            [weakSelf addLink:link];
        }];
    }
    return self;
}
- (instancetype)initWithText:(NSString *)text
                    attributes:(void (^ _Nullable)(NSMutableAttributedString *mutableAttributedString))block
           highlightAttributes:(void(^ _Nullable)(NSArray<ZLTagMatch *>  *items))highlightBlock
                     tapAction:(void (^ _Nullable)(ZLTagMatch *item))tapAction {
    return [self initWithTagParserResult:[ZLTagParserResult matchResultsWithStr:text] attributes:block highlightAttributes:highlightBlock tapAction:tapAction];
}
- (instancetype)initWithText:(NSString *)text
                    attributesBK:(void (^ _Nullable)(NSMutableAttributedString *mutableAttributedString))block
           highlightAttributesBK:(void(^ _Nullable)(NSArray<ZLTagMatch *>  *items))highlightBlock
                 tapActionBK:(void (^ _Nullable)(ZLTagMatch *item))tapAction {
    return [self initWithTagParserResult:[ZLTagParserResult matchResultsWithStr:text] attributes:block highlightAttributes:highlightBlock tapAction:tapAction];
}

- (instancetype)initWithText:(NSString *)text
               numberOfLines:(NSInteger)numberOfLines
                  attributes:(NSDictionary *)attributes
         highlightAttributes:(NSDictionary *)highlightAttributes
                 tapActionBK:(void (^ _Nullable)(ZLTagMatch *item))tapAction {
TTTAttributedLabel *label = [self initWithText:text attributesBK:^(NSMutableAttributedString * _Nonnull mutableAttributedString) {
        NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithDictionary:attributes];
        NSMutableParagraphStyle *style = [attributes valueForKey:NSParagraphStyleAttributeName];
        if (!style && numberOfLines == 0) {
            style = [[NSMutableParagraphStyle alloc] init];
            style.lineBreakMode = NSLineBreakByWordWrapping;
            attrs[NSParagraphStyleAttributeName] = style;
        }
        UIColor *color = [attributes valueForKey:NSForegroundColorAttributeName];
        if (color) {
            [attrs removeObjectForKey:NSForegroundColorAttributeName];
            attrs[(id)kCTForegroundColorAttributeName] = (id)color;
        }
        [mutableAttributedString addAttributes:attrs range:NSMakeRange(0, mutableAttributedString.length)];
    } highlightAttributesBK:^(NSArray<ZLTagMatch *> * _Nonnull items) {
        NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithDictionary:highlightAttributes];
        NSMutableParagraphStyle *style = [highlightAttributes valueForKey:NSParagraphStyleAttributeName];
        if (!style && numberOfLines == 0) {
            style = [[NSMutableParagraphStyle alloc] init];
            style.lineBreakMode = NSLineBreakByWordWrapping;
            attrs[NSParagraphStyleAttributeName] = style;
        }
        [items makeObjectsPerformSelector:@selector(addAttributes:) withObject:attrs];
    } tapActionBK:tapAction];
    label.numberOfLines = numberOfLines;
    return label;
}
- (instancetype)initWithText:(NSString *)text
                numberOfLines:(NSInteger)numberOfLines
                  attributes:(NSDictionary *)attributes
       highlightAttributesBK:(void(^ _Nullable)(NSArray<ZLTagMatch *>  *items))highlightBlock
                 tapActionBK:(void (^ _Nullable)(ZLTagMatch *item))tapAction {
    TTTAttributedLabel *label = [self initWithText:text attributesBK:^(NSMutableAttributedString * _Nonnull mutableAttributedString) {
        NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithDictionary:attributes];
        NSMutableParagraphStyle *style = [attributes valueForKey:NSParagraphStyleAttributeName];
        if (!style && numberOfLines == 0) {
            style = [[NSMutableParagraphStyle alloc] init];
            style.lineBreakMode = NSLineBreakByWordWrapping;
            attrs[NSParagraphStyleAttributeName] = style;
        }
        UIColor *color = [attributes valueForKey:NSForegroundColorAttributeName];
        if (color) {
            [attrs removeObjectForKey:NSForegroundColorAttributeName];
            attrs[(id)kCTForegroundColorAttributeName] = (id)color;
        }
        [mutableAttributedString addAttributes:attrs range:NSMakeRange(0, mutableAttributedString.length)];
    } highlightAttributesBK:highlightBlock tapActionBK:tapAction];
    label.numberOfLines = numberOfLines;
    return label;
}
@end
