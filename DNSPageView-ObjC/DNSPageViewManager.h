//
//  DNSPageViewManager.h
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

#import <Foundation/Foundation.h>
#import "DNSPageStyle.h"
#import "DNSPageDelegate.h"

@class DNSPageTitleView, DNSPageContentView;

NS_ASSUME_NONNULL_BEGIN


/// 通过这个类创建的 pageView，titleView 和 contentView 的 frame 是不确定的，适合于 titleView 和 contentView 分开布局的情况
/// 需要给 titleView 和 contentView 布局，可以使用 frame 或者 Autolayout
@interface DNSPageViewManager : NSObject <DNSPageViewContainer>

@property (nonatomic, strong, readonly) DNSPageStyle *style;

@property (nonatomic, strong, readonly) NSArray<NSString *> *titles;

@property (nonatomic, strong, readonly) NSArray<UIViewController *> *childViewControllers;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

@property (nonatomic, strong, readonly) DNSPageTitleView *titleView;

@property (nonatomic, strong, readonly) DNSPageContentView *contentView;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithStyle:(DNSPageStyle *)style
                       titles:(NSArray<NSString *> *)titles
         childViewControllers:(NSArray<UIViewController *> *)childViewControllers
                 currentIndex:(NSInteger)currentIndex
                    titleView:(nullable DNSPageTitleView *)titleView
                  contentView:(nullable DNSPageContentView *)contentView NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithStyle:(DNSPageStyle *)style
                       titles:(NSArray<NSString *> *)titles
         childViewControllers:(NSArray<UIViewController *> *)childViewControllers
                 currentIndex:(NSInteger)currentIndex;

- (instancetype)initWithStyle:(DNSPageStyle *)style
              titles:(NSArray<NSString *> *)titles
         childViewControllers:(NSArray<UIViewController *> *)childViewControllers;

- (void)configureWithTitles:(nullable NSArray<NSString *> *)titles
       childViewControllers:(nullable NSArray<UIViewController *> *)childViewControllers
                      style:(nullable DNSPageStyle *)style;

@end

NS_ASSUME_NONNULL_END
