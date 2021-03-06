//
//  DNSPageContentView.m
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

#import "DNSPageContentView.h"
#import "DNSPageCollectionViewFlowLayout.h"
#import "DNSPageTitleView.h"


@interface DNSPageContentView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) CGFloat startOffsetX;

@property (nonatomic, assign, getter=isForbidDelegate) BOOL forbidDelegate;

@property (nonatomic, strong) DNSPageStyle *style;

@property (nonatomic, strong,) NSArray<UIViewController *> *childViewControllers;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation DNSPageContentView

static NSString *const reuseIdentifier = @"reuseIdentifier";

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        DNSPageCollectionViewFlowLayout *layout = [[DNSPageCollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces = NO;
        if (@available(iOS 10, *)) {
            _collectionView.prefetchingEnabled = NO;
        }
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

- (DNSPageStyle *)style {
    if (!_style) {
        _style = [[DNSPageStyle alloc] init];
    }
    return _style;
}

- (NSArray<UIViewController *> *)childViewControllers {
    if (!_childViewControllers) {
        _childViewControllers = [NSArray array];
    }
    return _childViewControllers;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    if (!self.delegate && [self.container respondsToSelector:@selector(updateCurrentIndex:)]) {
        [self.container updateCurrentIndex:currentIndex];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(DNSPageStyle *)style
         childViewControllers:(NSArray<UIViewController *> *)childViewControllers
                 currentIndex:(NSInteger)currentIndex {
    NSParameterAssert(currentIndex >= 0 && currentIndex < childViewControllers.count);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self configureWithChildViewControllers:childViewControllers style:style currentIndex:currentIndex];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(DNSPageStyle *)style
         childViewControllers:(NSArray<UIViewController *> *)childViewControllers {
    return [self initWithFrame:frame style:style childViewControllers:childViewControllers currentIndex:0];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    DNSPageCollectionViewFlowLayout *layout = (DNSPageCollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = self.frame.size;
    layout.offset = self.currentIndex * self.frame.size.width;
}

- (void)configureWithChildViewControllers:(NSArray<UIViewController *> *)childViewControllers
                                    style:(DNSPageStyle *)style
                             currentIndex:(NSInteger)currentIndex {
    if (childViewControllers) {
        self.childViewControllers = childViewControllers;
    }
    if (style) {
        self.style = style;
    }
    if (currentIndex >= 0) {
        [self.collectionView.collectionViewLayout invalidateLayout];
        self.currentIndex = currentIndex;
    }
    [self configureSubViews];
    [self.collectionView reloadData];
    [self setNeedsLayout];
}

- (void)configureWithChildViewControllers:(NSArray<UIViewController *> *)childViewControllers
                                    style:(DNSPageStyle *)style {
    [self configureWithChildViewControllers:childViewControllers style:style currentIndex:-1];
}

- (void)configureSubViews {
    self.collectionView.backgroundColor = self.style.contentViewBackgroundColor;
    self.collectionView.scrollEnabled = self.style.isContentScrollEnabled;
}


#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    UIViewController *childViewController = self.childViewControllers[indexPath.item];
    if ([childViewController conformsToProtocol:@protocol(DNSPageEventHandlerDelegate)]) {
        self.eventHandler = (UIViewController<DNSPageEventHandlerDelegate> *)childViewController;
    }
    childViewController.view.frame = CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
    [cell.contentView addSubview:childViewController.view];

    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.forbidDelegate = NO;
    self.startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateUI:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self collectionViewDidEndScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self collectionViewDidEndScroll:scrollView];
}


- (void)collectionViewDidEndScroll:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)round(scrollView.contentOffset.x / scrollView.frame.size.width);

    if ([self.delegate respondsToSelector:@selector(contentView:didEndScrollAtIndex:)]) {
        [self.delegate contentView:self didEndScrollAtIndex:index];
    }

    if (index != self.currentIndex) {
        UIViewController *childViewController = self.childViewControllers[self.currentIndex];
        if ([childViewController conformsToProtocol:@protocol(DNSPageEventHandlerDelegate)]) {
            UIViewController<DNSPageEventHandlerDelegate> *eventHandler = (UIViewController<DNSPageEventHandlerDelegate> *)childViewController;
            if ([eventHandler respondsToSelector:@selector(contentViewDidDisappear)]) {
                [eventHandler contentViewDidDisappear];
            }
        }
    }
    
    self.currentIndex = index;
    
    UIViewController *childViewController = self.childViewControllers[index];
    if ([childViewController conformsToProtocol:@protocol(DNSPageEventHandlerDelegate)]) {
        self.eventHandler = (UIViewController<DNSPageEventHandlerDelegate> *)childViewController;
        if ([self.eventHandler respondsToSelector:@selector(contentViewDidEndScroll)]) {
            [self.eventHandler contentViewDidEndScroll];
        }
    }
    

}

- (void)updateUI:(UIScrollView *)scrollView {
    if (self.isForbidDelegate) {
        return;
    }
    CGFloat progress = 0;
    NSInteger targetIndex = 0;
    NSInteger sourceIndex = 0;
    progress = (NSInteger)scrollView.contentOffset.x % (NSInteger)scrollView.frame.size.width / scrollView.frame.size.width;
    if (progress == 0  || isnan(progress)) {
        return;
    }

    NSInteger index = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width);

    if (self.collectionView.contentOffset.x > self.startOffsetX) {
        sourceIndex = index;
        targetIndex = index + 1;
        if (targetIndex >= self.childViewControllers.count) {
            return;
        }
    } else {
        sourceIndex = index + 1;
        targetIndex = index;
        progress = 1 - progress;
        if (targetIndex < 0) {
            return;
        }
    }
    if (progress > 0.998) {
        progress = 1;
    }
    if ([self.delegate respondsToSelector:@selector(contentView:scrollingWithSourceIndex:targetIndex:progress:)]) {
        [self.delegate contentView:self scrollingWithSourceIndex:sourceIndex targetIndex:targetIndex progress:progress];
    }
}

#pragma mark - DNSPageTitleViewDelegate
- (void)titleView:(DNSPageTitleView *)titleView didSelectAtIndex:(NSInteger)index {
    self.forbidDelegate = YES;

    if (index >= self.childViewControllers.count) {
        return;
    }
    self.currentIndex = index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}



@end
