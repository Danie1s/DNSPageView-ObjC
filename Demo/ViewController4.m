//
//  ViewController4.m
//  Demo
//
//  Created by Daniels Lau on 2018/9/25.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import "ViewController4.h"
#import <DNSPageView_ObjC/DNSPageView_ObjC.h>
#import "ContentViewController.h"
#import "UIColor+Random.h"

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@interface ViewController4 ()

@property (nonatomic, strong) NSArray<NSString *> *titles;

@property (nonatomic, strong) DNSPageViewManager *pageViewManager;


@end

@implementation ViewController4


- (DNSPageViewManager *)pageViewManager {
    if (!_pageViewManager) {
        // 创建DNSPageStyle，设置样式
        DNSPageStyle *style = [[DNSPageStyle alloc] init];
        style.showBottomLine = YES;
        style.titleViewScrollEnabled = YES;
        style.titleViewBackgroundColor = [UIColor clearColor];
        if (@available(iOS 13.0, *)) {
            style.titleSelectedColor = [UIColor dns_dynamicColorWithLightColor:[UIColor redColor] darkColor:[UIColor blueColor]];
            style.titleColor = [UIColor dns_dynamicColorWithLightColor:[UIColor greenColor] darkColor:[UIColor orangeColor]];
        } else {
            style.titleSelectedColor = [UIColor blackColor];
            style.titleColor = [UIColor grayColor];
        }
        style.bottomLineColor = [UIColor colorWithRed:0 / 255.0 green:143 / 255.0 blue:223 / 255.0 alpha:1.0];
        style.bottomLineWidth = 20;

        // 设置标题内容
        NSArray <NSString *>*titles = @[@"微信支付", @"支付宝"];

        // 创建每一页对应的controller
        for (int i = 0; i < titles.count; i++) {
            ContentViewController *controller = [[ContentViewController alloc] init];
            controller.view.backgroundColor = [UIColor randomColor];
            controller.index = i;
            [self addChildViewController:controller];
        }
        _pageViewManager = [[DNSPageViewManager alloc] initWithStyle:style titles:titles childViewControllers:self.childViewControllers startIndex:0];
    }
    return _pageViewManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11, *)) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    DNSPageTitleView *titleView = self.pageViewManager.titleView;
    [self.view addSubview:titleView];
    
    
    // 单独设置titleView的大小和位置，可以使用autolayout或者frame
    [titleView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(44);
    }];
    
    // 单独设置contentView的大小和位置，可以使用autolayout或者frame
    DNSPageContentView *contentView = self.pageViewManager.contentView;
    [self.view addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}


@end
