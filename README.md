# ZLTTTAttributedLabel

### 基于TTTAttributedLabel的封装，对一行文字高亮部分加标签，自动解析出高亮文字，并加点击事件回调，解决多语言文本翻译替换语序的问题


## 安装


```ruby
pod 'ZLTTTAttributedLabel'
```
文本内容：
```ruby
NSString *text = @"登录或注册账号即视为同意<h>《用户协议》[1]<h/>和<h>《隐私政策》[2]<h/>";
```


展示效果：

<img src="https://github.com/FPJack/ZLTTTAttributedLabel/blob/master/picture1.png" width="30%" height="30%">   <img src="https://github.com/FPJack/ZLTTTAttributedLabel/blob/master/picture2.png" width="30%" height="30%">   <img src="https://github.com/FPJack/ZLTTTAttributedLabel/blob/master/picture3.png" width="30%" height="30%">



```ruby

        NSString *input = @"登录或注册账号即视为同意<h>《用户协议》[1]<h/>和<h>《隐私政策》[2]<h/>";
        NSDictionary *attrs = @{
            NSFontAttributeName: [UIFont systemFontOfSize:18],
            NSForegroundColorAttributeName : [UIColor blackColor],
        };
        NSDictionary *highlightAttrs = @{
            NSFontAttributeName: [UIFont systemFontOfSize:18],
            NSForegroundColorAttributeName : [UIColor redColor],
        };
        UILabel *label = [[ZLTTTAttributedLabel alloc] initWithText:input numberOfLines:0 attributes:attrs highlightAttributes:highlightAttrs tapActionBK:^(ZLLinkItem * _Nonnull item) {
            kPopViewColumnBuilder
                .title(item.text)
                .message(item.tagId)
                .addConfirmViewStyleActionText(@"确定", nil)
                .showAlert();
        }];
```

如果需要对不同标签设置不同的高亮属性，可以使用下面的方法：
```ruby
        NSString *input = @"登录或注册账号即视为同意<h>《用户协议》[1]<h/>和<h>《隐私政策》[2]<h/>";
        NSDictionary *attrs = @{
            NSFontAttributeName: [UIFont systemFontOfSize:18],
            NSForegroundColorAttributeName : [UIColor blackColor],
        };
        UILabel *label = [[ZLTTTAttributedLabel alloc] initWithText:input numberOfLines:0 attributes:attrs highlightAttributesBK:^(NSArray<ZLTagMatch *> * _Nonnull items) {
            [items enumerateObjectsUsingBlock:^(ZLTagMatch * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.tagId isEqualToString:@"1"]) {
                    [obj addAttributes:@{
                        NSForegroundColorAttributeName : [UIColor redColor],
                        NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                    }];
                }else if ([obj.tagId isEqualToString:@"2"]) {
                    [obj addAttributes:@{
                        NSForegroundColorAttributeName : [UIColor greenColor],
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
```
        

## Author

fanpeng, 2551412939@qq.com

## License

ZLTTTAttributedLabel is available under the MIT license. See the LICENSE file for more info.
