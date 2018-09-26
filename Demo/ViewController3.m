//
//  ViewController3.m
//  Demo
//
//  Created by Daniels Lau on 2018/9/25.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import "ViewController3.h"
#import <DNSPageView_ObjC/DNSPageView_ObjC.h>
#import "ContentViewController.h"
#import "UIColor+Random.h"

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@interface ViewController3 ()

@property (nonatomic, strong) DNSPageViewManager *pageViewManager;

@end

@implementation ViewController3

- (DNSPageViewManager *)pageViewManager {
    if (!_pageViewManager) {
        // 创建DNSPageStyle，设置样式
        DNSPageStyle *style = [[DNSPageStyle alloc] init];
        style.showBottomLine = YES;
        style.titleViewScrollEnabled = YES;
        style.titleViewBackgroundColor = [UIColor clearColor];
        
        // 设置标题内容
        NSArray <NSString *>*titles = @[@"头条", @"视频", @"娱乐", @"要问", @"体育"];
        
        // 创建每一页对应的controller
        NSMutableArray *childViewControllers = [NSMutableArray array];
        for (NSString *title in titles) {
            ContentViewController *controller = [[ContentViewController alloc] init];
            controller.view.backgroundColor = [UIColor randomColor];
            [childViewControllers addObject:controller];
        }
        _pageViewManager = [[DNSPageViewManager alloc] initWithStyle:style titles:titles childViewControllers:childViewControllers startIndex:0];
    }
    return _pageViewManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 单独设置titleView的frame
    self.navigationItem.titleView = self.pageViewManager.titleView;
    self.pageViewManager.titleView.frame = CGRectMake(0, 0, 180, 44);
    
    // 单独设置contentView的大小和位置，可以使用autolayout或者frame
    DNSPageContentView *contentView = self.pageViewManager.contentView;
    [self.view addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


@end
