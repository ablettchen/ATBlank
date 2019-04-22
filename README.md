# ATBlank

[![CI Status](https://img.shields.io/travis/ablett/ATBlank.svg?style=flat)](https://travis-ci.org/ablett/ATBlank)
[![Version](https://img.shields.io/cocoapods/v/ATBlank.svg?style=flat)](https://cocoapods.org/pods/ATBlank)
[![License](https://img.shields.io/cocoapods/l/ATBlank.svg?style=flat)](https://cocoapods.org/pods/ATBlank)
[![Platform](https://img.shields.io/cocoapods/p/ATBlank.svg?style=flat)](https://cocoapods.org/pods/ATBlank)

## Example

```objectiveC

    #import "UIScrollView+ATBlank.h"

    UIScrollView *scrollView = ({
        UIScrollView *view = [UIScrollView new];
        [self.view addSubview:view];
        view.frame = self.view.bounds;
        view;
    });
    
    ATBlank *blank = failureBlank();
    blank.desc = [[NSAttributedString alloc] initWithString:@"10001"];
    blank.tapBlock = ^{
        NSLog(@"tap action");
        [scrollView setBlank:nil];
        [scrollView reloadBlankData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"no data");
            [scrollView setBlank:noDataBlank()];
            [scrollView reloadBlankData];
        });
    };
    [scrollView setBlank:blank];
    [scrollView reloadBlankData];
    
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