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

- (NSArray<NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"头条", @"视频"];
    }
    return _titles;
}

- (DNSPageViewManager *)pageViewManager {
    if (!_pageViewManager) {
        // 创建DNSPageStyle，设置样式
        DNSPageStyle *style = [[DNSPageStyle alloc] init];
        style.showBottomLine = YES;
        style.titleViewScrollEnabled = YES;
        style.titleViewBackgroundColor = [UIColor clearColor];
        style.titleColor = [UIColor grayColor];
        style.titleSelectedColor = [UIColor blackColor];
        style.bottomLineColor = [UIColor colorWithRed:0 / 255.0 green:143 / 255.0 blue:223 / 255.0 alpha:1.0];
        
        // 创建每一页对应的controller
        NSMutableArray *childViewControllers = [NSMutableArray array];
        for (NSString *title in self.titles) {
            ContentViewController *controller = [[ContentViewController alloc] init];
            controller.view.backgroundColor = [UIColor randomColor];
            [childViewControllers addObject:controller];
            [self addChildViewController:controller];
        }
        _pageViewManager = [[DNSPageViewManager alloc] initWithStyle:style titles:self.titles childViewControllers:childViewControllers startIndex:0];
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
    
    CGFloat margin = self.pageViewManager.style.titleMargin;
    
    // 计算titleView需要的宽度
    // 如果style.isTitleScrollEnable = false，则不需要计算宽度，但是titleView的下划线会平分titleView的宽度
    CGFloat width = 0;
    for (NSString *title in self.titles) {
        width += [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.pageViewManager.style.titleFont} context:nil].size.width + margin;
    }
    
    // 单独设置titleView的大小和位置，可以使用autolayout或者frame
    [titleView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
        make.leading.equalTo(self.view);
        make.width.equalTo(width);
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
