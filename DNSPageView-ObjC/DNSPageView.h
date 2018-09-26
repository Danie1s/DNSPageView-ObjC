//
//  DNSPageView.h
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

#import <UIKit/UIKit.h>
#import "DNSPageStyle.h"

@class DNSPageTitleView, DNSPageContentView;
NS_ASSUME_NONNULL_BEGIN


/**
 通过这个类创建的pageView，默认titleView和contentView连在一起，效果类似于网易新闻
 只能用代码创建，不能在xib或者storyboard里面使用
 */
@interface DNSPageView : UIView

@property (nonatomic, strong, readonly) DNSPageStyle *style;

@property (nonatomic, strong, readonly) NSArray<NSString *> *titles;

@property (nonatomic, strong, readonly) NSArray<UIViewController *> *childViewControllers;

@property (nonatomic, assign, readonly) NSInteger startIndex;

@property (nonatomic, strong, readonly) DNSPageTitleView *titleView;

@property (nonatomic, strong, readonly) DNSPageContentView *contentView;

- (instancetype)initWithFrame:(CGRect)frame style:(DNSPageStyle *)style titles:(NSArray<NSString *> *)titles childViewControllers:(NSArray<UIViewController *> *)childViewControllers startIndex:(NSInteger)startIndex;

@end

NS_ASSUME_NONNULL_END
