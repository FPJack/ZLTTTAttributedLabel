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
    
//    input = @"يسجل الدخول أو إنشاء حساب يعني موافقتك على <h>\"اتفاقية المستخدم\" [1]<h/> و<h>\"سياسة الخصوصية\" [2]<h/>";
//    input = @"يسجل الدخول أو إنشاء حساب يعني موافقتك على <h>\"اتفاقية المستخدم\" [1]<h/> و<h>\"سياسة الخصوصية\" [2]<h/>";

    {
        self.label = [[ZLTTTAttributedLabel alloc] initWithText:input attributes:^(NSMutableAttributedString * _Nonnull mutableAttributedString) {
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineBreakMode = NSLineBreakByWordWrapping;
            [mutableAttributedString addAttributes:@{
                        NSFontAttributeName: [UIFont systemFontOfSize:18],
                        NSParagraphStyleAttributeName: style,
                        (id)kCTForegroundColorAttributeName : (id)[UIColor blackColor].CGColor,

            } range:NSMakeRange(0, mutableAttributedString.length)];
        } highlightAttributes:^(NSArray<ZLTagMatch *> * _Nonnull items) {
            [items makeObjectsPerformSelector:@selector(addAttributes:) withObject:@{
                (id)kCTForegroundColorAttributeName : (id)[UIColor redColor].CGColor,
                NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
            }];
        } tapAction:^(ZLURLItem * _Nonnull item) {
            kPopViewColumnBuilder
                .title(item.text)
                .message(item.tagId)
                .addConfirmViewStyleActionText(@"确定", nil)
                .showAlert();
           
        }];
        self.label.textAlignment = NSTextAlignmentCenter;
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
        self.label = [[ZLTTTAttributedLabel alloc] initWithText:input attributes:^(NSMutableAttributedString * _Nonnull mutableAttributedString) {
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineBreakMode = NSLineBreakByWordWrapping;
            [mutableAttributedString addAttributes:@{
                        NSFontAttributeName: [UIFont systemFontOfSize:18],
                        NSParagraphStyleAttributeName: style,
                        (id)kCTForegroundColorAttributeName : (id)[UIColor blackColor].CGColor,

            } range:NSMakeRange(0, mutableAttributedString.length)];
        } highlightAttributes:^(NSArray<ZLTagMatch *> * _Nonnull items) {
            [items makeObjectsPerformSelector:@selector(addAttributes:) withObject:@{
                (id)kCTForegroundColorAttributeName : (id)[UIColor redColor].CGColor,
            }];
        } tapAction:^(ZLURLItem * _Nonnull item) {
            kPopViewColumnBuilder
                .title(item.text)
                .message(item.tagId)
                .addConfirmViewStyleActionText(@"确定", nil)
                .showAlert();
        }];
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
//        input = @"أوافق على <h>اتفاقية المستخدم[@1]<h/> و<h>سياسة الخصوصية[@2]<h/>";
        input = @"يسجل الدخول أو إنشاء حساب يعني موافقتك على <h>\"اتفاقية المستخدم\" [1]<h/> و<h>\"سياسة الخصوصية\" [2]<h/>";

        self.label = [[ZLTTTAttributedLabel alloc] initWithText:input attributes:^(NSMutableAttributedString * _Nonnull mutableAttributedString) {
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineBreakMode = NSLineBreakByWordWrapping;
            [mutableAttributedString addAttributes:@{
                        NSFontAttributeName: [UIFont systemFontOfSize:18],
                        NSParagraphStyleAttributeName: style,
                        (id)kCTForegroundColorAttributeName : (id)[UIColor blackColor].CGColor,

            } range:NSMakeRange(0, mutableAttributedString.length)];
        } highlightAttributes:^(NSArray<ZLTagMatch *> * _Nonnull items) {
            [items makeObjectsPerformSelector:@selector(addAttributes:) withObject:@{
                (id)kCTForegroundColorAttributeName : (id)[UIColor redColor].CGColor,
                NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                (id)kCTBackgroundColorAttributeName : (id)(UIColor.orangeColor.CGColor),
                (id)kCTUnderlineColorAttributeName: (id)[UIColor blueColor].CGColor,
                (id)kCTUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),

            }];
        } tapAction:^(ZLURLItem * _Nonnull item) {
            kPopViewColumnBuilder
                .title(item.text)
                .message(item.tagId)
                .addConfirmViewStyleActionText(@"确定", nil)
                .showAlert();
        }];
        self.label.textAlignment = NSTextAlignmentRight;
        self.label.numberOfLines = 0;
        
        [self.view addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-100);
            make.leading.mas_equalTo(self.view).offset(20);
            make.trailing.mas_equalTo(self.view).offset(-20);
        }];
        
    }


    
}


@end
