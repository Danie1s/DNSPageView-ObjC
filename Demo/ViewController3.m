//
//  ViewController3.m
//  Demo
//
//  Created by Daniels Lau on 2018/9/25.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import "ViewController3.h"
#import <DNSPageView_ObjC/DNSPageView_ObjC.h>

@interface ViewController3 ()

@property (nonatomic, strong) DNSPageViewManager *pageViewManager;

@end

@implementation ViewController3

- (DNSPageViewManager *)pageViewManager {
    if (!_pageViewManager) {
        DNSPageStyle *style = [[DNSPageStyle alloc] init];
        style.showBottomLine = YES;
        style.titleViewScrollEnabled = YES;
        style.titleViewBackgroundColor = [UIColor clearColor];
        
        NSArray <NSString *>*titles = @[@"头条", @"视频", @"娱乐", @"要问", @"体育"];
        
        NSMutableArray *childViewControllers = [NSMutableArray array];
        for (NSString *title in titles) {
            UIViewController *controller = [[UIViewController alloc] init];
            controller.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
            [childViewControllers addObject:controller];
        }
        _pageViewManager = [[DNSPageViewManager alloc] initWithStyle:style titles:titles childViewControllers:childViewControllers];
    }
    return _pageViewManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

}


@end
