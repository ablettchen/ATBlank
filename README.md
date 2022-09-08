# ATBlank

[![CI Status](https://img.shields.io/travis/ablett/ATBlank.svg?style=flat)](https://travis-ci.org/ablett/ATBlank)
[![Version](https://img.shields.io/cocoapods/v/ATBlank.svg?style=flat)](https://cocoapods.org/pods/ATBlank)
[![License](https://img.shields.io/cocoapods/l/ATBlank.svg?style=flat)](https://cocoapods.org/pods/ATBlank)
[![Platform](https://img.shields.io/cocoapods/p/ATBlank.svg?style=flat)](https://cocoapods.org/pods/ATBlank)

## Example

```objectiveC

#import <ATBlank/ATBlank.h>

    __weak typeof(self) wSelf = self;
    
    // 更新空白样式配置：可选，如不配置，则取默认配置
    self.view.zhUpdateBlankConf(^(ATBlankConf * _Nonnull conf) {
        conf.backgroundColor = UIColor.blackColor;
        conf.titleFont = [UIFont boldSystemFontOfSize:16];
        conf.titleColor = UIColor.whiteColor;
        conf.verticalOffset = -100;
    });
    
    
    // 创建空白对象
    ATBlank *blank = ATBlank.failureBlank;
    blank.title = @"哎呀，加载失败了";
    blank.action = ^{
        // 重置样式设置
        [wSelf.view atResetBlankConf];
    };
    
    // 关联空白对象
    self.view.ATBlank = blank;
    
    // 刷新显示
    [self.view atReloadBlank];
    
```

## Requirements

## Installation

ATBlank is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ATBlank'
```

## Author

ablett, ablettchen@gmail.com

## License

ATBlank is available under the MIT license. See the LICENSE file for more info.
