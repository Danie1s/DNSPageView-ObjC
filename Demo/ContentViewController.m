//
//  ContentViewController.m
//  Demo
//
//  Created by Daniels Lau on 2018/9/26.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import "ContentViewController.h"
#import <DNSPageView_ObjC/DNSPageView_ObjC.h>

@interface ContentViewController () <DNSPageReloaderDelegate>

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)titleViewDidSelectedSameTitle {
    NSLog(@"重复点击了标题");

}

- (void)contentViewDidEndScroll {
    NSLog(@"contentView滑动结束");

}

@end
