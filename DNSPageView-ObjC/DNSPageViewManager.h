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

@class DNSPageTitleView, DNSPageContentView;

NS_ASSUME_NONNULL_BEGIN


/**
 通过这个类创建的pageView，titleView和contentView的frame是不确定的，适合于titleView和contentView分开布局的情况
 需要给titleView和contentView布局，可以用frame或者Autolayout布局
 */
@interface DNSPageViewManager : NSObject

@property (nonatomic, strong, readonly) DNSPageStyle *style;

@property (nonatomic, strong, readonly) NSArray<NSString *> *titles;

@property (nonatomic, strong, readonly) NSArray<UIViewController *> *childViewControllers;

@property (nonatomic, assign, readonly) NSInteger startIndex;

@property (nonatomic, strong, readonly) DNSPageTitleView *titleView;

@property (nonatomic, strong, readonly) DNSPageContentView *contentView;

- (instancetype)initWithStyle:(DNSPageStyle *)style titles:(NSArray<NSString *> *)titles childViewControllers:(NSArray<UIViewController *> *)childViewControllers startIndex:(NSInteger)startIndex;

@end

NS_ASSUME_NONNULL_END
