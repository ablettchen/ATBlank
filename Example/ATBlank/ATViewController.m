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

@interface ATViewController ()

@end

@implementation ATViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
