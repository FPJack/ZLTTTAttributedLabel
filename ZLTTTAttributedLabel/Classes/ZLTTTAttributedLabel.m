//
//  ZLTTTAttributedLabel.m
//  ZLTTTAttributedLabel
//
//  Created by admin on 2025/12/5.
//

#import "ZLTTTAttributedLabel.h"
#import "ZLTagParserResult.h"

@implementation  ZLURLItem
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
    [self.impl respondsToSelector:@selector(attributedLabel:didSelectLinkWithURL:)];
    [invocation invokeWithTarget:self.impl];
}
@end
@interface ZLTTTAttributedLabel ()<TTTAttributedLabelDelegate>
@property (nonatomic, strong) ZLTTTProxy *proxy;
@property (nonatomic,copy)void (^tagTapAction)(ZLURLItem *item);

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
        ZLURLItem *item = [ZLURLItem new];
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
                              tapAction:(void (^ _Nullable)(ZLURLItem *item))tapAction{
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
            [weakSelf addLinkWithTextCheckingResult:obj.result attributes:obj.attributes];
        }];
        self.delegate = self;
    }
    return self;
}
- (instancetype)initWithText:(NSString *)text
                    attributes:(void (^ _Nullable)(NSMutableAttributedString *mutableAttributedString))block
           highlightAttributes:(void(^ _Nullable)(NSArray<ZLTagMatch *>  *items))highlightBlock
                     tapAction:(void (^ _Nullable)(ZLURLItem *item))tapAction {
    return [self initWithTagParserResult:[ZLTagParserResult matchResultsWithStr:text] attributes:block highlightAttributes:highlightBlock tapAction:tapAction];
}
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
}
@end
