//
//  ATViewController.m
//  ATBlank
//  https://github.com/ablettchen/ATBlank.git
//
//  Created by ablett on 2018/11/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATViewController.h"
#import "UIScrollView+ATBlank.h"
#import "UIView+ATBlank.h"

@interface ATViewController ()
@end

@implementation ATViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    ATBlank *blank = defaultBlank(ATBlankTypeFailure);
    blank.desc = [[NSAttributedString alloc] initWithString:@"10001"];
    blank.tapBlock = ^{
        [self.view blankConfReset];
    };
    [self.view setBlank:blank];
    [self.view reloadBlank];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view.updateBlankConf(^(ATBlankConf * _Nonnull conf) {
            conf.backgroundColor = [UIColor blackColor];
            conf.titleFont = [UIFont boldSystemFontOfSize:14];
            conf.titleColor = [UIColor whiteColor];
            conf.descFont = [UIFont boldSystemFontOfSize:14];
            conf.descColor = [UIColor whiteColor];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
