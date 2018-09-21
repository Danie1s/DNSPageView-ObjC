//
//  DNSPageTitleView.m
//  DNSPageView-ObjC
//
//  Created by Daniels Lau on 2018/9/21.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import "DNSPageTitleView.h"

@interface DNSPageTitleView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) NSArray<UILabel *> *titleLabels;
@end


@implementation DNSPageTitleView



- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
    }
    return _scrollView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = _style.bottomLineColor;
    }
    return _bottomLine;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = _style.coverViewBackgroundColor;
        _coverView.alpha = _style.coverViewAlpha;
    }
    return _coverView;
}

- (instancetype)initWithFrame:(CGRect)frame style:(DNSPageStyle *)style titles:(NSArray<NSString *> *)titles currentIndex:(NSInteger)currentIndex {
    if ([super initWithFrame:frame]) {
        _style = style;
        _titles = titles;
        _currentIndex = currentIndex;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.style = [[DNSPageStyle alloc] init];
    self.titles = [NSArray array];
}

//- (void)initProperties {
//    _currentIndex = 0;
//
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    
}

- (void)setupUI {
    [self addSubview:self.scrollView];
    
    self.scrollView.backgroundColor = self.style.titleViewBackgroundColor;
}

- (void)setupTitleLabels {
    NSMutableArray *array = [NSMutableArray array];
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] init];
        label.tag = idx;
        label.text = obj;
        label.textColor = idx == self.currentIndex ? self.style.titleSelectedColor : self.style.titleColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = self.style.titleFont;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
        [label addGestureRecognizer:tapGesture];
        label.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:label];
        [array addObject:label];
        
    }];
}


- (void)setupBottomLine {
    if (self.style.isShowBottomLine) {
        [self.scrollView addSubview:self.bottomLine];
    }
}

- (void)setupCoverView {
    if (self.style.isShowCoverView) {
        [self.scrollView insertSubview:self.coverView atIndex:0];
        self.coverView.layer.cornerRadius = self.style.coverViewRadius;
        self.coverView.layer.masksToBounds = YES;
    }
}


- (void)setupLabelsLayout {
    __block CGFloat x = 0;
    __block CGFloat y = 0;
    __block CGFloat width = 0;
    __block CGFloat height = self.frame.size.height;
    
    NSInteger count = self.titles.count;
    [self.titleLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.style.isTitleScrollEnabled) {
            width = [self.titles[idx] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: obj.font} context:nil].size.width;
            x = idx == 0 ? self.style.titleMargin * 0.5 : (CGRectGetMaxX(self.titleLabels[idx - 1].frame) + self.style.titleMargin);
        } else {
            width = self.bounds.size.width / (CGFloat)count;
            x = width * (CGFloat)idx;
        }
        obj.frame = CGRectMake(x, y, width, height);
    }];
    
    if (self.style.isScaleEnabled) {
        [self.titleLabels firstObject].transform = CGAffineTransformMakeScale(self.style.maximumScaleFactor, self.style.maximumScaleFactor);
    }
    
    if (self.style.isTitleScrollEnabled) {
        UILabel *label = [self.titleLabels lastObject];
        if (label) {
            CGSize size = self.scrollView.contentSize;
            size.width = CGRectGetMaxX(label.frame) + self.style.titleMargin * 0.5;
            self.scrollView.contentSize = size;
        }
    }
}

- (void)setupCoverViewLayout {
    if (self.currentIndex > self.titleLabels.count - 1) {
        return;
    }
    UILabel *label = self.titleLabels[self.currentIndex];
    CGFloat width = label.bounds.size.width;
    CGFloat height = self.style.coverViewHeight;
    CGFloat x = label.frame.origin.x;
    CGFloat y = (label.frame.size.height - height) * 0.5;
    if (self.style.isTitleScrollEnabled) {
        x -= self.style.coverMargin;
        width += self.style.coverMargin * 2;
    }
    self.coverView.frame = CGRectMake(x, y, width, height);
}

- (void)setupBottomLineLayout {
    if (self.currentIndex > self.titleLabels.count - 1) {
        return;
    }
    UILabel *label = self.titleLabels[self.currentIndex];
    CGRect frame = self.bottomLine.frame;
    frame.origin.x = label.frame.origin.x;
    frame.origin.y = self.bounds.size.height - self.style.bottomLineHeight;
    frame.size.width = label.frame.size.width;
    frame.size.height = self.style.bottomLineHeight;
}

- (void)titleLabelClick:(UITapGestureRecognizer *)tap {
    UILabel *targetLabel = (UILabel *)tap.view;
    self.clickHandler(self, targetLabel.tag);
    
    if (targetLabel.tag == self.currentIndex) {
        // 重复点击事件
        return;
    }
    
    UILabel *sourceLabel = self.titleLabels[self.currentIndex];
    
    sourceLabel.textColor = self.style.titleColor;
    targetLabel.textColor = self.style.titleSelectedColor;
    
    self.currentIndex = targetLabel.tag;
    
    [self adjustLabelPosition:targetLabel];
    
    if ([self.delegate respondsToSelector:@selector(titleView:currentIndex:)]) {
        [self.delegate titleView:self currentIndex:self.currentIndex];
    }
    
    if (self.style.isScaleEnabled) {
        [UIView animateWithDuration:0.25 animations:^{
            sourceLabel.transform = CGAffineTransformIdentity;
            targetLabel.transform = CGAffineTransformMakeScale(self.style.maximumScaleFactor, self.style.maximumScaleFactor);
        }];
    }
    
    if (self.style.isShowBottomLine) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.bottomLine.frame;
            frame.origin.x = targetLabel.frame.origin.x;
            frame.size.width = targetLabel.frame.size.width;
            self.bottomLine.frame = frame;
        }];
    }
    
    if (self.style.isShowCoverView) {
        CGFloat x = self.style.isTitleScrollEnabled ? (targetLabel.frame.origin.x - self.style.coverMargin) : targetLabel.frame.origin.x;
        CGFloat width = self.style.isTitleScrollEnabled ? (targetLabel.frame.size.width + self.style.coverMargin * 2) : targetLabel.frame.size.width;
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.coverView.frame;
            frame.origin.x = x;
            frame.size.width = width;
            self.coverView.frame = frame;
        }];
    }
}

- (void)adjustLabelPosition:(UILabel *)targetLabel {
    if (self.style.isTitleScrollEnabled) {
        CGFloat offsetX = targetLabel.center.x - self.bounds.size.width * 0.5;
        if (offsetX < 0) {
            offsetX = 0;
        }
        if (offsetX > self.scrollView.contentSize.width - self.scrollView.bounds.size.width) {
            offsetX = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
        }
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}


#pragma mark - DNSPageContentViewDelegate


@end
