//
//  DNSPageContentView.h
//  DNSPageView-ObjC
//
//  Created by Daniels on 2018/9/24.
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
#import "DNSPageDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface DNSPageContentView : UIView<DNSPageTitleViewDelegate>

@property (nullable, nonatomic, weak) id<DNSPageContentViewDelegate> delegate;

@property (nullable, nonatomic, weak) id<DNSPageViewContainer> container;

@property (nullable, nonatomic, weak) id<DNSPageEventHandlerDelegate> eventHandler;

@property (nonatomic, strong, readonly) DNSPageStyle *style;

@property (nonatomic, strong, readonly) NSArray<UIViewController *> *childViewControllers;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFrame:(CGRect)frame
                        style:(DNSPageStyle *)style
         childViewControllers:(NSArray<UIViewController *> *)childViewControllers
                 currentIndex:(NSInteger)currentIndex NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFrame:(CGRect)frame
                        style:(DNSPageStyle *)style
         childViewControllers:(NSArray<UIViewController *> *)childViewControllers;

- (void)configureWithChildViewControllers:(nullable NSArray<UIViewController *> *)childViewControllers
                                    style:(nullable DNSPageStyle *)style
                             currentIndex:(NSInteger)currentIndex;

- (void)configureWithChildViewControllers:(nullable NSArray<UIViewController *> *)childViewControllers
                                    style:(nullable DNSPageStyle *)style;

@end

NS_ASSUME_NONNULL_END
