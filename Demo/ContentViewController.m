//
//  ContentViewController.m
//  Demo
//
//  Created by Daniels Lau on 2018/9/26.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import "ContentViewController.h"
#import <DNSPageView_ObjC/DNSPageView_ObjC.h>

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@interface ContentViewController () <DNSPageEventHandlerDelegate>

@property (nonatomic, strong) UIButton *button;

@end

@implementation ContentViewController

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        [_button setTitle:@"点击我进行push" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor whiteColor];
    }
    return _button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.button];
    [self.button makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

// 出现的时候马上调用
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSLog(@"viewDidAppear，index: %ld", self.index);
}

// pop或者cell复用的时候调用
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    NSLog(@"viewDidDisappear，index: %ld", self.index);
}


- (void)push {
    UIViewController *controller = [[UIViewController alloc] init];
    controller.view.backgroundColor = [UIColor whiteColor];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)titleViewDidSelectSameTitle {
    NSLog(@"重复点击了标题，index: %ld", self.index);

}

- (void)contentViewDidEndScroll {
    NSLog(@"contentView滑动结束，index: %ld", self.index);
}

- (void)contentViewDidDisappear {
    NSLog(@"我消失了，index: %ld", self.index);
}

@end
