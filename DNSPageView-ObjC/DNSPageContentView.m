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

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nullable, nonatomic, weak) id<DNSPageReloaderDelegate> reloader;

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

- (instancetype)initWithFrame:(CGRect)frame style:(DNSPageStyle *)style childViewControllers:(NSArray<UIViewController *> *)childViewControllers currentIndex:(NSInteger)currentIndex {
    self = [super initWithFrame:frame];
    if (self) {
        self.childViewControllers = childViewControllers;
        self.style = style;
        self.currentIndex = currentIndex;
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.childViewControllers = [NSArray array];
    self.style = [[DNSPageStyle alloc] init];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    DNSPageCollectionViewFlowLayout *layout = (DNSPageCollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = self.bounds.size;
    layout.offset = self.currentIndex * self.bounds.size.width;
}

- (void)setupUI {
    [self addSubview:self.collectionView];

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
    if ([childViewController conformsToProtocol:@protocol(DNSPageReloaderDelegate)]) {
        self.reloader = (UIViewController<DNSPageReloaderDelegate> *)childViewController;
    }
    childViewController.view.frame = cell.contentView.bounds;
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
    NSInteger index = (NSInteger)round(scrollView.contentOffset.x / scrollView.bounds.size.width);
    
    self.currentIndex = index;
    
    UIViewController *childViewController = self.childViewControllers[index];
    if ([childViewController conformsToProtocol:@protocol(DNSPageReloaderDelegate)]) {
        self.reloader = (UIViewController<DNSPageReloaderDelegate> *)childViewController;
        if ([self.reloader respondsToSelector:@selector(contentViewDidEndScroll)]) {
            [self.reloader contentViewDidEndScroll];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(contentView:didEndScrollAtIndex:)]) {
        [self.delegate contentView:self didEndScrollAtIndex:index];
    }
}

- (void)updateUI:(UIScrollView *)scrollView {
    if (self.isForbidDelegate) {
        return;
    }
    CGFloat progress = 0;
    NSInteger targetIndex = 0;
    NSInteger sourceIndex = 0;
    progress = (NSInteger)scrollView.contentOffset.x % (NSInteger)scrollView.bounds.size.width / scrollView.bounds.size.width;
    if (progress == 0  || isnan(progress)) {
        return;
    }

    NSInteger index = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width);

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
- (void)titleView:(DNSPageTitleView *)titleView didSelectAt:(NSInteger)index {
    self.forbidDelegate = YES;

    if (index >= self.childViewControllers.count) {
        return;
    }
    self.currentIndex = index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)titleViewDidSelectSameTitle {
    if ([self.reloader respondsToSelector:@selector(titleViewDidSelectSameTitle)]) {
        [self.reloader titleViewDidSelectSameTitle];
    }
}


@end
