//
//  DNSPageView.m
//  DNSPageView-ObjC
//
//  Created by Daniels Lau on 2018/9/25.
//  Copyright © 2018年 Daniels. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "DNSPageView.h"
#import "DNSPageTitleView.h"
#import "DNSPageContentView.h"



@interface DNSPageView ()

@property (nonatomic, strong) DNSPageStyle *style;

@property (nonatomic, strong) NSArray<NSString *> *titles;

@property (nonatomic, strong) NSArray<UIViewController *> *childViewControllers;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) DNSPageTitleView *titleView;

@property (nonatomic, strong) DNSPageContentView *contentView;

@end

@implementation DNSPageView


- (instancetype)initWithFrame:(CGRect)frame
                        style:(DNSPageStyle *)style
                       titles:(NSArray<NSString *> *)titles
         childViewControllers:(NSArray<UIViewController *> *)childViewControllers
                 currentIndex:(NSInteger)currentIndex {
    NSParameterAssert(titles.count == childViewControllers.count);
    NSParameterAssert(currentIndex >= 0 && currentIndex < titles.count);
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        self.titles = titles;
        self.childViewControllers = childViewControllers;
        self.currentIndex = currentIndex;
        self.titleView = [[DNSPageTitleView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, style.titleViewHeight)
                                                           style:self.style
                                                          titles:self.titles
                                                    currentIndex:self.currentIndex];
        self.contentView = [[DNSPageContentView alloc] initWithFrame:CGRectMake(0, style.titleViewHeight, frame.size.width, frame.size.height - style.titleViewHeight)
                                                               style:self.style
                                                childViewControllers:self.childViewControllers
                                                        currentIndex:self.currentIndex];
        [self addSubview:self.titleView];
        [self addSubview:self.contentView];
        self.titleView.container = self;
        self.contentView.container = self;
        self.titleView.delegate = self.contentView;
        self.contentView.delegate = self.titleView;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(DNSPageStyle *)style
                       titles:(NSArray<NSString *> *)titles
         childViewControllers:(NSArray<UIViewController *> *)childViewControllers {
    return [self initWithFrame:frame style:style titles:titles childViewControllers:childViewControllers currentIndex:0];
}

- (void)configureWithTitles:(NSArray<NSString *> *)titles
       childViewControllers:(NSArray<UIViewController *> *)childViewControllers
                      style:(DNSPageStyle *)style {
    if (titles) {
        self.titles = titles;
    }
    if (childViewControllers) {
        self.childViewControllers = childViewControllers;
    }
    if (style) {
        self.style = style;
    }
    NSParameterAssert(self.titles.count == self.childViewControllers.count);
    NSParameterAssert(self.currentIndex >= 0 && self.currentIndex < self.titles.count);
    [self.titleView configureWithTitles:titles style:style];
    [self.contentView configureWithChildViewControllers:childViewControllers style:style];
}

- (void)updateCurrentIndex:(NSInteger)index {
    self.currentIndex = index;
}

@end
