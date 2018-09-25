//
//  DNSPageViewManager.m
//  DNSPageView-ObjC
//
//  Created by Daniels Lau on 2018/9/25.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import "DNSPageViewManager.h"
#import "DNSPageTitleView.h"
#import "DNSPageContentView.h"

@interface DNSPageViewManager ()

@property (nonatomic, strong) DNSPageStyle *style;

@property (nonatomic, strong) NSArray<NSString *> *titles;

@property (nonatomic, strong) NSArray<UIViewController *> *childViewControllers;

@property (nonatomic, strong) DNSPageTitleView *titleView;

@property (nonatomic, strong) DNSPageContentView *contentView;

@end

@implementation DNSPageViewManager

- (DNSPageTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[DNSPageTitleView alloc] initWithFrame:CGRectZero style:self.style titles:self.titles currentIndex:0];
    }
    return _titleView;
}

- (DNSPageContentView *)contentView {
    if (!_contentView) {
        _contentView = [[DNSPageContentView alloc] initWithFrame:CGRectZero style:self.style childViewControllers:self.childViewControllers startIndex:0];
    }
    return _contentView;
}

- (instancetype)initWithStyle:(DNSPageStyle *)style titles:(NSArray<NSString *> *)titles childViewControllers:(NSArray<UIViewController *> *)childViewControllers {
    self = [super init];
    if (self) {
        self.style = style;
        self.titles = titles;
        self.childViewControllers = childViewControllers;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.titleView.delegate = self.contentView;
    self.contentView.delegate = self.titleView;
}

@end
