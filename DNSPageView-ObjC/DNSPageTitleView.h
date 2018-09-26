//
//  DNSPageTitleView.h
//  DNSPageView-ObjC
//
//  Created by Daniels Lau on 2018/9/21.
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

typedef void (^TitleClickHandler)(DNSPageTitleView *titleView, NSInteger currentIndex);


@interface DNSPageTitleView : UIView <DNSPageContentViewDelegate>

@property (nullable, nonatomic, weak) id<DNSPageTitleViewDelegate> delegate;

/**
 点击标题时调用
 */
@property (nullable, nonatomic, copy) TitleClickHandler clickHandler;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong, readonly) NSArray<UILabel *> *titleLabels;

@property (nonatomic, strong) DNSPageStyle *style;

@property (nonatomic, strong) NSArray<NSString *> *titles;

@property (nonatomic, strong, readonly) UIView *coverView;

- (instancetype)initWithFrame:(CGRect)frame style:(DNSPageStyle *)style titles:(NSArray<NSString *> *)titles currentIndex:(NSInteger)currentIndex;

- (void)setupUI;

@end


NS_ASSUME_NONNULL_END
