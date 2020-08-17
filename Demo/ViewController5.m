//
//  ViewController5.m
//  Demo
//
//  Created by Daniels on 2020/8/16.
//  Copyright © 2020 Daniels. All rights reserved.
//

#import "ViewController5.h"
#import <DNSPageView_ObjC/DNSPageView_ObjC.h>
#import "ContentViewController.h"
#import "UIColor+Random.h"

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@interface ViewController5 ()

@property (nonatomic, assign, getter=isChanged) BOOL changed;

@property (nonatomic, strong) NSArray<NSString *> *titles;

@property (nonatomic, strong) DNSPageViewManager *pageViewManager;


@end

@implementation ViewController5


- (DNSPageViewManager *)pageViewManager {
    if (!_pageViewManager) {
        // 创建 DNSPageStyle，设置样式
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
        NSArray <NSString *>*titles = @[@"NBA", @"CBA", @"英雄联盟", @"王者荣耀", @"中国足球", @"国际足球"];

        // 创建每一页对应的 controller
        for (int i = 0; i < titles.count; i++) {
            ContentViewController *controller = [[ContentViewController alloc] init];
            controller.view.backgroundColor = [UIColor randomColor];
            controller.index = i;
            [self addChildViewController:controller];
        }
        _pageViewManager = [[DNSPageViewManager alloc] initWithStyle:style
                                                              titles:titles
                                                childViewControllers:self.childViewControllers
                                                        currentIndex:3];
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
    
    
    // 单独设置 titleView 的大小和位置，可以使用 autolayout 或者 frame
    [titleView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(44);
    }];
    
    // 单独设置 contentView 的大小和位置，可以使用 autolayout 或者 frame
    DNSPageContentView *contentView = self.pageViewManager.contentView;
    [self.view addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"改变"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(changeStyle)];

}

- (void)changeStyle {
    [self changeTitle];
    
//    [self changeTitles];
    
//    [self changeAll];
}

- (void)changeTitle {
    if (!self.isChanged) {
        [self.pageViewManager.titleView updateTitle:@"JavaScript" atIndex:3];
    } else {
        [self.pageViewManager.titleView updateTitle:@"王者荣耀" atIndex:3];
    }
    self.changed = !self.isChanged;
}

- (void)changeTitles {
    if (!self.isChanged) {
        NSArray <NSString *>*titles = @[@"Swift", @"Objective-C", @"JavaScript", @"Python", @"C++", @"Go"];
        [self.pageViewManager configureWithTitles:titles childViewControllers:nil style:nil];
    } else {
        NSArray <NSString *>*titles = @[@"NBA", @"CBA", @"英雄联盟", @"王者荣耀", @"中国足球", @"国际足球"];
        [self.pageViewManager configureWithTitles:titles childViewControllers:nil style:nil];
    }
    self.changed = !self.isChanged;
}

- (void)changeAll {
    if (!self.isChanged) {
        
        DNSPageStyle *style = [[DNSPageStyle alloc] init];
        style.titleViewBackgroundColor = [UIColor redColor];
        style.showCoverView = YES;
        style.titleViewScrollEnabled = YES;

        NSArray <NSString *>*titles = @[@"头条", @"视频", @"娱乐", @"要问", @"体育", @"科技", @"汽车", @"时尚", @"图片", @"游戏", @"房产"];

        [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [obj removeFromParentViewController];
         }];
        // 创建每一页对应的controller
        for (int i = 0; i < titles.count; i++) {
            ContentViewController *controller = [[ContentViewController alloc] init];
            controller.view.backgroundColor = [UIColor randomColor];
            controller.index = i;
            [self addChildViewController:controller];
        }
        [self.pageViewManager configureWithTitles:titles
                             childViewControllers:self.childViewControllers
                                            style:style];
    } else {
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
        NSArray <NSString *>*titles = @[@"NBA", @"CBA", @"英雄联盟", @"王者荣耀", @"中国足球", @"国际足球"];

        [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromParentViewController];
        }];
        // 创建每一页对应的 controller
        for (int i = 0; i < titles.count; i++) {
            ContentViewController *controller = [[ContentViewController alloc] init];
            controller.view.backgroundColor = [UIColor randomColor];
            controller.index = i;
            [self addChildViewController:controller];
        }
        [self.pageViewManager configureWithTitles:titles
                             childViewControllers:self.childViewControllers
                                            style:style];

    }
    self.changed = !self.isChanged;
}

@end
