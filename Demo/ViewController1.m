//
//  ViewController1.m
//  Demo
//
//  Created by Daniels Lau on 2018/9/21.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import "ViewController1.h"
#import <DNSPageView_ObjC/DNSPageView_ObjC.h>

@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    DNSPageStyle *style = [[DNSPageStyle alloc] init];
    style.titleViewScrollEnabled = YES;
    style.titleScaleEnabled = YES;
    
    NSArray <NSString *>*titles = @[@"头条", @"视频", @"娱乐", @"要问", @"体育" , @"科技" , @"汽车" , @"时尚" , @"图片" , @"游戏" , @"房产"];
    
    NSMutableArray *childViewControllers = [NSMutableArray array];
    for (NSString *title in titles) {
        UIViewController *controller = [[UIViewController alloc] init];
        controller.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
        [childViewControllers addObject:controller];
    }
    
    CGFloat y = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    DNSPageView *pageView = [[DNSPageView alloc] initWithFrame:CGRectMake(0, y, size.width, size.height) style:style titles:titles childViewControllers:childViewControllers];
    [self.view addSubview:pageView];
}


@end
