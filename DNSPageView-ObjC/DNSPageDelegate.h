//
//  DNSPageDelegate.h
//  DNSPageView-ObjC
//
//  Created by Daniels Lau on 2018/9/26.
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

NS_ASSUME_NONNULL_BEGIN

@class DNSPageTitleView, DNSPageContentView;

@protocol DNSPageTitleViewDelegate <NSObject>

- (void)titleView:(DNSPageTitleView *)titleView currentIndex:(NSInteger)currentIndex;

- (void)titleViewDidSelectedSameTitle;

@end


@protocol DNSPageContentViewDelegate <NSObject>

- (void)contentView:(DNSPageContentView *)contentView inIndex:(NSInteger)inIndex;

- (void)contentView:(DNSPageContentView *)contentView sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex progress:(CGFloat)progress;

@end


/**
 如果contentView中的view需要实现某些刷新的方法，请让对应的childViewController遵守这个协议
 */
@protocol DNSPageReloaderDelegate <NSObject>
@optional


/**
 如果需要双击标题刷新或者作其他处理，请实现这个方法
 */
- (void)titleViewDidSelectedSameTitle;


/**
 如果pageContentView滚动到下一页停下来需要刷新或者作其他处理，请实现这个方法
 */
- (void)contentViewDidEndScroll;

@end



NS_ASSUME_NONNULL_END
