//
//  ViewController2.m
//  Demo
//
//  Created by Daniels Lau on 2018/9/25.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import "ViewController2.h"
#import <DNSPageView_ObjC/DNSPageView_ObjC.h>

@interface ViewController2 ()

@property (weak, nonatomic) IBOutlet DNSPageTitleView *titleView;

@property (weak, nonatomic) IBOutlet DNSPageContentView *contentView;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    DNSPageStyle *style = [[DNSPageStyle alloc] init];
    style.titleViewBackgroundColor = [UIColor redColor];
    style.showCoverView = YES;
    
    NSArray <NSString *>*titles = @[@"头条", @"视频", @"娱乐", @"要问", @"体育"];
    
    NSInteger startIndex = 2;
    
    self.titleView.titles = titles;
    self.titleView.style = style;
    self.titleView.currentIndex = startIndex;
    
    [self.titleView setupUI];
    
    NSMutableArray *childViewControllers = [NSMutableArray array];
    for (NSString *title in titles) {
        UIViewController *controller = [[UIViewController alloc] init];
        controller.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
        [childViewControllers addObject:controller];
    }
    
    self.contentView.childViewControllers = childViewControllers;
    self.contentView.startIndex = startIndex;
    self.contentView.style = style;
    
    [self.contentView setupUI];
    
    self.titleView.delegate = self.contentView;
    self.contentView.delegate = self.titleView;
}


@end
