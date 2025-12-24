# ZLTTTAttributedLabel

### 基于TTTAttributedLabel的封装，对一行文字高亮部分加标签，自动解析出高亮文字，并加点击事件回调，解决多语言文本翻译替换语序的问题


## 安装


```ruby
pod 'ZLTTTAttributedLabel'
```
文本内容：
NSString *text = @"登录或注册账号即视为同意<h>《用户协议》[@1]<h/>和<h>《隐私政策》[@2]<h/>";

展示效果：

<img src="https://github.com/FPJack/ZLTTTAttributedLabel/blob/master/picture1.png" width="30%" height="30%">   <img src="https://github.com/FPJack/ZLTTTAttributedLabel/blob/master/picture2.png" width="30%" height="30%">   <img src="https://github.com/FPJack/ZLTTTAttributedLabel/blob/master/picture3.png" width="30%" height="30%">



```ruby

        NSString *text = @"登录或注册账号即视为同意<h>《用户协议》[@1]<h/>和<h>《隐私政策》[@2]<h/>";

        ZLTTTAttributedLabel *label = [[ZLTTTAttributedLabel alloc] initWithText:text attributes:^(NSMutableAttributedString * _Nonnull mutableAttributedString) {
            //设置文本默认属性
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineBreakMode = NSLineBreakByWordWrapping;
            [mutableAttributedString addAttributes:@{
                        NSFontAttributeName: [UIFont systemFontOfSize:18],
                        NSParagraphStyleAttributeName: style,
                        (id)kCTForegroundColorAttributeName : (id)[UIColor blackColor].CGColor,

            } range:NSMakeRange(0, mutableAttributedString.length)];
        } highlightAttributes:^(NSArray<ZLTagMatch *> * _Nonnull items) {
            //设置高亮文本属性
            [items makeObjectsPerformSelector:@selector(addAttributes:) withObject:@{
                (id)kCTForegroundColorAttributeName : (id)[UIColor redColor].CGColor,
                NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
            }];
        } tapAction:^(ZLURLItem * _Nonnull item) {
            //点击事件回调
            kPopViewColumnBuilder
                .alertWidth270
                .title(item.text)
                .message(item.tagId)
                .addConfirmViewStyleActionText(@"确定", nil)
                .showCenterPopView();
        }];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
```
        

## Author

fanpeng, 2551412939@qq.com

## License

ZLTTTAttributedLabel is available under the MIT license. See the LICENSE file for more info.
