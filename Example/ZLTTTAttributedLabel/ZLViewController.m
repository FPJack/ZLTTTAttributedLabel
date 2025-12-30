//
//  ZLViewController.m
//  ZLTTTAttributedLabel
//
//  Created by fanpeng on 12/05/2025.
//  Copyright (c) 2025 fanpeng. All rights reserved.
//

#import "ZLViewController.h"
#import <ZLTTTAttributedLabel/ZLTTTAttributedLabel.h>
#import "TTTAttributedLabel.h"
#import <Masonry/Masonry.h>
#import <ZLPopView/ZLPopView.h>
@interface ZLViewController () <TTTAttributedLabelDelegate>
@property (nonatomic, strong) ZLTTTAttributedLabel *label;
@end

@implementation ZLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *input = @"登录或注册账号即视为同意<h>《用户协议》[1]<h/>和<h>《隐私政策》[2]<h/>";
    {
        self.label = [[ZLTTTAttributedLabel alloc] initWithText:input numberOfLines:0 attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:18],
            NSForegroundColorAttributeName : [UIColor blackColor],
        } highlightAttributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:18],
            NSForegroundColorAttributeName : [UIColor redColor],
        } tapActionBK:^(ZLLinkItem * _Nonnull item) {
            kPopViewColumnBuilder
                .title(item.text)
                .message(item.tagId)
                .addConfirmViewStyleActionText(@"确定", nil)
                .showAlert();
        }];
        
        self.label.numberOfLines = 0;
        [self.view addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(100);
            make.leading.mas_equalTo(self.view).offset(20);
            make.trailing.mas_equalTo(self.view).offset(-20);
        }];
    }
    
    {
        input = @"By logging in or registering an account, you agree to the <h>User Agreement[1]<h/> and <h>Privacy Policy[2]<h/>.";
        NSDictionary *attrs = @{
            NSFontAttributeName: [UIFont systemFontOfSize:18],
            NSForegroundColorAttributeName : [UIColor blackColor],
        };
        self.label = [[ZLTTTAttributedLabel alloc] initWithText:input numberOfLines:0 attributes:attrs highlightAttributesBK:^(NSArray<ZLTagMatch *> * _Nonnull items) {
            [items enumerateObjectsUsingBlock:^(ZLTagMatch * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.tagId isEqualToString:@"1"]) {
                    [obj addAttributes:@{
                        NSForegroundColorAttributeName : [UIColor redColor],
                        NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                    }];
                    
                    [obj addActiveAttributes:@{
                        NSForegroundColorAttributeName : [UIColor orangeColor],
                        NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                    }];
                }else if ([obj.tagId isEqualToString:@"2"]) {
                    [obj addAttributes:@{
                        NSForegroundColorAttributeName : [UIColor greenColor],
                        NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                    }];
                    [obj addActiveAttributes:@{
                        NSForegroundColorAttributeName : [UIColor orangeColor],
                        NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                    }];
                }
            }];
        } tapActionBK:^(ZLLinkItem * _Nonnull item) {
            kPopViewColumnBuilder
                .title(item.text)
                .message(item.tagId)
                .addConfirmViewStyleActionText(@"确定", nil)
                .showAlert();
        }];
        // 点击高亮时
        
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.numberOfLines = 0;
        [self.view addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view);
            make.leading.mas_equalTo(self.view).offset(20);
            make.trailing.mas_equalTo(self.view).offset(-20);
        }];
        
    }
    
    
    {
        input = @"يسجل الدخول أو إنشاء حساب يعني موافقتك على <h>\"اتفاقية المستخدم\" [1]<h/> و<h>\"سياسة الخصوصية\" [2]<h/>";

        
        self.label = [[ZLTTTAttributedLabel alloc] initWithText:input numberOfLines:0 attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:18],
            NSForegroundColorAttributeName : [UIColor blackColor],
        } highlightAttributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:18],
            NSForegroundColorAttributeName : [UIColor redColor],
            (id)kCTBackgroundColorAttributeName : (id)(UIColor.orangeColor.CGColor),
            (id)kCTUnderlineColorAttributeName: (id)[UIColor blueColor].CGColor,
            (id)kCTUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
        } tapActionBK:^(ZLLinkItem * _Nonnull item) {
            kPopViewColumnBuilder
                .title(item.text)
                .message(item.tagId)
                .addConfirmViewStyleActionText(@"确定", nil)
                .showAlert();
        }];
        
        
        self.label.textAlignment = NSTextAlignmentLeft;
        
        [self.view addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-100);
            make.leading.mas_equalTo(self.view).offset(20);
            make.trailing.mas_equalTo(self.view).offset(-20);
        }];
        
    }


    
}


@end
