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

@property (nonatomic, strong) DNSPageViewManager *pageViewManager;

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
    NSInteger currentIndex = 2;
    
    
    // 创建每一页对应的 controller
    for (int i = 0; i < titles.count; i++) {
        ContentViewController *controller = [[ContentViewController alloc] init];
        controller.view.backgroundColor = [UIColor randomColor];
        controller.index = i;
        [self addChildViewController:controller];
    }
    
    self.pageViewManager = [[DNSPageViewManager alloc] initWithStyle:style
                                                         titles:titles
                                           childViewControllers:self.childViewControllers
                                                   currentIndex:currentIndex
                                                      titleView:self.titleView
                                                    contentView:self.contentView];
}


@end
