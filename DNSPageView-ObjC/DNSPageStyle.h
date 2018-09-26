//
//  DNSPageStyle.h
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

NS_ASSUME_NONNULL_BEGIN

@interface DNSPageStyle : NSObject


/**
 titleView
 */
@property (nonatomic, assign) CGFloat titleViewHeight;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleViewBackgroundColor;
@property (nonatomic, assign) CGFloat titleMargin;
@property (nullable, nonatomic, strong) UIColor *titleViewSelectedColor;

/**
 titleView滑动
 */
@property (nonatomic, assign, getter = isTitleViewScrollEnabled) BOOL titleViewScrollEnabled;

/**
 title下划线
 */
@property (nonatomic, assign, getter = isShowBottomLine) BOOL showBottomLine;
@property (nonatomic, strong) UIColor *bottomLineColor;
@property (nonatomic, assign) CGFloat bottomLineHeight;
@property (nonatomic, assign) CGFloat bottomLineRadius;

/**
 title缩放
 */
@property (nonatomic, assign, getter = isTitleScaleEnabled) BOOL titleScaleEnabled;
@property (nonatomic, assign) CGFloat titleMaximumScaleFactor;

/**
 title遮罩
 */
@property (nonatomic, assign, getter = isShowCoverView) BOOL showCoverView;
@property (nonatomic, strong) UIColor *coverViewBackgroundColor;
@property (nonatomic, assign) CGFloat coverViewAlpha;
@property (nonatomic, assign) CGFloat coverMargin;
@property (nonatomic, assign) CGFloat coverViewHeight;
@property (nonatomic, assign) CGFloat coverViewRadius;

/**
 contentView
 */
@property (nonatomic, assign, getter = isContentScrollEnabled) BOOL contentScrollEnabled;
@property (nonatomic, strong) UIColor *contentViewBackgroundColor;

NS_ASSUME_NONNULL_END

@end


