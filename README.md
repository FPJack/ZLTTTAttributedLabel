# ZLTTTAttributedLabel

[![CI Status](https://img.shields.io/travis/fanpeng/ZLTTTAttributedLabel.svg?style=flat)](https://travis-ci.org/fanpeng/ZLTTTAttributedLabel)
[![Version](https://img.shields.io/cocoapods/v/ZLTTTAttributedLabel.svg?style=flat)](https://cocoapods.org/pods/ZLTTTAttributedLabel)
[![License](https://img.shields.io/cocoapods/l/ZLTTTAttributedLabel.svg?style=flat)](https://cocoapods.org/pods/ZLTTTAttributedLabel)
[![Platform](https://img.shields.io/cocoapods/p/ZLTTTAttributedLabel.svg?style=flat)](https://cocoapods.org/pods/ZLTTTAttributedLabel)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ZLTTTAttributedLabel is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZLTTTAttributedLabel'
```

<img src="https://github.com/FPJack/ZLTTTAttributedLabel/blob/master/picture1.PNG" width="30%" height="30%">   <img src="https://github.com/FPJack/ZLTTTAttributedLabel/blob/master/picture2.PNG" width="30%" height="30%">   <img src="https://github.com/FPJack/ZLTTTAttributedLabel/blob/master/picture3.PNG" width="30%" height="30%">



```ruby
        ZLTTTAttributedLabel *label = [[ZLTTTAttributedLabel alloc] initWithText:input attributes:^(NSMutableAttributedString * _Nonnull mutableAttributedString) {
            //设置文本默认属性
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineBreakMode = NSLineBreakByWordWrapping;
            style.alignment = NSTextAlignmentRight;
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
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:item.text
                                                                           message:item.tagId
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
```
        

## Author

fanpeng, peng.fan@ukelink.com

## License

ZLTTTAttributedLabel is available under the MIT license. See the LICENSE file for more info.
