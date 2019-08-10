//
//  ViewController2.m
//  Demo
//
//  Created by Daniels Lau on 2018/9/25.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import "ViewController2.h"
#import <DNSPageView_ObjC/DNSPageView_ObjC.h>
#import "ContentViewController.h"
#import "UIColor+Random.h"

@interface ViewController2 ()

@property (weak, nonatomic) IBOutlet DNSPageTitleView *titleView;

@property (weak, nonatomic) IBOutlet DNSPageContentView *contentView;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11, *)) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    // 创建DNSPageStyle，设置样式
    DNSPageStyle *style = [[DNSPageStyle alloc] init];
    style.titleViewBackgroundColor = [UIColor redColor];
    style.showCoverView = YES;

    // 设置标题内容
    NSArray <NSString *>*titles = @[@"头条", @"视频", @"娱乐", @"要问", @"体育"];
    
    // 设置默认的起始位置
    NSInteger startIndex = 2;
    
    // 对titleView进行设置
    self.titleView.titles = titles;
    self.titleView.style = style;
    self.titleView.currentIndex = startIndex;
    
    // 最后要调用setupUI方法
    [self.titleView setupUI];
    
    // 创建每一页对应的controller
    for (int i = 0; i < titles.count; i++) {
        ContentViewController *controller = [[ContentViewController alloc] init];
        controller.view.backgroundColor = [UIColor randomColor];
        controller.index = i;
        [self addChildViewController:controller];
    }
    
    // 对contentView进行设置
    self.contentView.childViewControllers = self.childViewControllers;
    self.contentView.currentIndex = startIndex;
    self.contentView.style = style;
    
    // 最后要调用setupUI方法
    [self.contentView setupUI];
    
    // 让titleView和contentView进行联系起来
    self.titleView.delegate = self.contentView;
    self.contentView.delegate = self.titleView;
}


@end
