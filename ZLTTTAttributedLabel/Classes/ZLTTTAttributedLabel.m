//
//  ZLTTTAttributedLabel.m
//  ZLTTTAttributedLabel
//
//  Created by admin on 2025/12/5.
//

#import "ZLTTTAttributedLabel.h"
#import "ZLTagParserResult.h"

@implementation  ZLLinkItem
@end
@interface ZLTTTProxy : NSProxy<TTTAttributedLabelDelegate>
@property (nonatomic, weak) id<TTTAttributedLabelDelegate> impl;
@property (nonatomic, copy) void (^linkTapHandler)(NSURL *url);
@end
@implementation ZLTTTProxy
+ (instancetype)proxyWithImpl:(id<TTTAttributedLabelDelegate>)impl{
    ZLTTTProxy *proxy = [ZLTTTProxy alloc];
    proxy.impl = impl;
    return proxy;
}
- (BOOL)respondsToSelector:(SEL)aSelector {
    return YES;
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [(NSObject *)self.impl methodSignatureForSelector:selector];
}
- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = invocation.selector;
    if (sel == @selector(attributedLabel:didSelectLinkWithURL:)) {
        if (self.linkTapHandler) {
            __unsafe_unretained NSURL *url = nil;
            [invocation getArgument:&url atIndex:3];
            self.linkTapHandler(url);
        }
    }
    if (![self.impl respondsToSelector:sel]) {
        return;
    }
    [invocation invokeWithTarget:self.impl];
}
@end
@interface ZLTTTAttributedLabel ()<TTTAttributedLabelDelegate>
@property (nonatomic, strong) ZLTTTProxy *proxy;
@property (nonatomic,copy)void (^tagTapAction)(ZLLinkItem *item);

@end
@implementation ZLTTTAttributedLabel
- (ZLTTTProxy *)proxy {
    if (!_proxy) {
        _proxy = [ZLTTTProxy proxyWithImpl:nil];
    }
    return _proxy;
}
- (void)setDelegate:(id<TTTAttributedLabelDelegate>)delegate {
    ZLTTTProxy *proxy = [ZLTTTProxy proxyWithImpl:delegate];
    proxy.linkTapHandler = ^(NSURL *url) {
        NSURLComponents *components = [NSURLComponents componentsWithString:url.absoluteString];
        NSArray<NSURLQueryItem *> *items = components.queryItems;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        for (NSURLQueryItem *item in items) {
            params[item.name] = item.value ?: @"";
        }
        ZLLinkItem *item = [ZLLinkItem new];
        item.text = params[@"text"];
        item.tagId = params[@"tagId"];
        item.urlString = url.absoluteString;
        item.host = url.host;
        item.scheme = url.scheme;
        item.path = url.path;
        if (self.tagTapAction) {
            self.tagTapAction(item);
        }
    };
    self.proxy = proxy;
    [super setDelegate:self.proxy];
}


- (instancetype)initWithTagParserResult:(ZLTagParserResult *)parserResult
                             attributes:(void (^ _Nullable)(NSMutableAttributedString *mutableAttributedString))block
                    highlightAttributes:(void(^ _Nullable)(NSArray<ZLTagMatch *>  *items))highlightBlock
                              tapAction:(void (^ _Nullable)(ZLLinkItem *item))tapAction{
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
            [weakSelf addLink:[[TTTAttributedLabelLink alloc] initWithAttributes:obj.attributes activeAttributes:obj.activeAttributes inactiveAttributes:nil textCheckingResult:obj.result]];
        }];
        self.delegate = self;
    }
    return self;
}
- (instancetype)initWithText:(NSString *)text
                    attributes:(void (^ _Nullable)(NSMutableAttributedString *mutableAttributedString))block
           highlightAttributes:(void(^ _Nullable)(NSArray<ZLTagMatch *>  *items))highlightBlock
                     tapAction:(void (^ _Nullable)(ZLLinkItem *item))tapAction {
    return [self initWithTagParserResult:[ZLTagParserResult matchResultsWithStr:text] attributes:block highlightAttributes:highlightBlock tapAction:tapAction];
}
- (instancetype)initWithText:(NSString *)text
                    attributesBK:(void (^ _Nullable)(NSMutableAttributedString *mutableAttributedString))block
           highlightAttributesBK:(void(^ _Nullable)(NSArray<ZLTagMatch *>  *items))highlightBlock
                 tapActionBK:(void (^ _Nullable)(ZLLinkItem *item))tapAction {
    return [self initWithTagParserResult:[ZLTagParserResult matchResultsWithStr:text] attributes:block highlightAttributes:highlightBlock tapAction:tapAction];
}

- (instancetype)initWithText:(NSString *)text
               numberOfLines:(NSInteger)numberOfLines
                  attributes:(NSDictionary *)attributes
         highlightAttributes:(NSDictionary *)highlightAttributes
                 tapActionBK:(void (^ _Nullable)(ZLLinkItem *item))tapAction {
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
                 tapActionBK:(void (^ _Nullable)(ZLLinkItem *item))tapAction {
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
