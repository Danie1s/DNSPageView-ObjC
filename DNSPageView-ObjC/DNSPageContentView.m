//
//  DNSPageContentView.m
//  DNSPageView-ObjC
//
//  Created by Daniels on 2018/9/24.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import "DNSPageContentView.h"
#import "DNSPageCollectionViewFlowLayout.h"
#import "DNSPageTitleView.h"

@interface DNSPageContentView () <UICollectionViewDelegate, UICollectionViewDataSource, DNSPageTitleViewDelegate>

@property (nonatomic, assign) CGFloat startOffsetX;

@property (nonatomic, assign, getter=isForbidDelegate) BOOL forbidDelegate;

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

- (instancetype)initWithFrame:(CGRect)frame style:(DNSPageStyle *)style childViewControllers:(NSArray<UIViewController *> *)childViewControllers startIndex:(NSInteger)startIndex {
    self = [super initWithFrame:frame];
    if (self) {
        self.childViewControllers = childViewControllers;
        self.style = style;
        self.startIndex = startIndex;
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
    layout.offset = self.startIndex * self.bounds.size.width;
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
    NSInteger inIndex = (NSInteger)round(scrollView.contentOffset.x / scrollView.bounds.size.width);
//    UIViewController *childViewController = self.childViewControllers[inIndex];

    if ([self.delegate respondsToSelector:@selector(contentView:inIndex:)]) {
        [self.delegate contentView:self inIndex:inIndex];
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
    if (progress == 0) {
        return;
    }

    NSInteger index = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width);

    if (self.collectionView.contentOffset.x > self.startOffsetX) {
        sourceIndex = index;
        targetIndex = index + 1;
        if (targetIndex > self.childViewControllers.count - 1) {
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
    if ([self.delegate respondsToSelector:@selector(contentView:sourceIndex:targetIndex:progress:)]) {
        [self.delegate contentView:self sourceIndex:sourceIndex targetIndex:targetIndex progress:progress];
    }
}

#pragma mark - DNSPageTitleViewDelegate
- (void)titleView:(DNSPageTitleView *)titleView currentIndex:(NSInteger)currentIndex {
    self.forbidDelegate = YES;

    if (currentIndex > self.childViewControllers.count - 1) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

@end
