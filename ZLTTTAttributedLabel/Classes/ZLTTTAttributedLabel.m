//
//  ZLTTTAttributedLabel.m
//  ZLTTTAttributedLabel
//
//  Created by admin on 2025/12/5.
//

#import "ZLTTTAttributedLabel.h"
#import "ZLTagParserResult.h"



@interface ZLTTTAttributedLabel ()<TTTAttributedLabelDelegate>
@property (nonatomic,copy)void (^tagTapAction)(ZLTagMatch *item);

@end
@implementation ZLTTTAttributedLabel




- (instancetype)initWithTagParserResult:(ZLTagParserResult *)parserResult
                             attributes:(void (^ _Nullable)(NSMutableAttributedString *mutableAttributedString))block
                    highlightAttributes:(void(^ _Nullable)(NSArray<ZLTagMatch *>  *items))highlightBlock
                              tapAction:(void (^ _Nullable)(ZLTagMatch *item))tapAction{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.tagTapAction = tapAction;
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
        self.delegate = self;
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
    ZLTTTAttributedLabel *label = [self initWithText:text attributesBK:^(NSMutableAttributedString * _Nonnull mutableAttributedString) {
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
    ZLTTTAttributedLabel *label = [self initWithText:text attributesBK:^(NSMutableAttributedString * _Nonnull mutableAttributedString) {
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
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
}
@end
