//
//  DNSPageTitleView.m
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

#import "DNSPageTitleView.h"
#import "DNSPageContentView.h"
#import "UIColor+RGB.h"



@interface DNSPageTitleView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) NSArray<UILabel *> *titleLabels;

@end


@implementation DNSPageTitleView

- (RGBColorSpace)normalRGB {
    return [self.style.titleColor getRGBColorSpace];
}

- (RGBColorSpace)selectRGB {
    return [self.style.titleSelectedColor getRGBColorSpace];
}

- (RGBColorSpace)deltaRGB {
    RGBColorSpace rgb;
    rgb.red = self.selectRGB.red - self.normalRGB.red;
    rgb.green = self.selectRGB.green - self.normalRGB.green;
    rgb.blue = self.selectRGB.blue - self.normalRGB.blue;
    return rgb;
}

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
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;
        _titles = titles;
        _currentIndex = currentIndex;
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.style = [[DNSPageStyle alloc] init];
    self.titles = [NSArray array];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    
    [self setupLabelsLayout];
    [self setupBottomLineLayout];
    [self setupCoverViewLayout];
    
}

- (void)setupUI {
    [self addSubview:self.scrollView];
    
    self.scrollView.backgroundColor = self.style.titleViewBackgroundColor;
    
    [self setupTitleLabels];
    
    [self setupBottomLine];
    
    [self setupCoverView];
}

- (void)setupTitleLabels {
    NSMutableArray *titleLabels = [NSMutableArray array];
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] init];
        label.tag = idx;
        label.text = obj;
        label.textColor = idx == self.currentIndex ? self.style.titleSelectedColor : self.style.titleColor;
        label.backgroundColor = idx == self.currentIndex ? self.style.titleViewSelectedColor : [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = self.style.titleFont;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedTitleLabel:)];
        [label addGestureRecognizer:tapGesture];
        label.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:label];
        [titleLabels addObject:label];
        
    }];
    self.titleLabels = titleLabels;
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
    CGFloat y = 0;
    __block CGFloat width = 0;
    CGFloat height = self.frame.size.height;
    
    NSInteger count = self.titles.count;
    [self.titleLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.style.isTitleViewScrollEnabled) {
            width = [self.titles[idx] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: obj.font} context:nil].size.width;
            x = idx == 0 ? self.style.titleMargin * 0.5 : (CGRectGetMaxX(self.titleLabels[idx - 1].frame) + self.style.titleMargin);
        } else {
            width = self.bounds.size.width / (CGFloat)count;
            x = width * (CGFloat)idx;
        }
        obj.frame = CGRectMake(x, y, width, height);
    }];
    
    if (self.style.isTitleScaleEnabled) {
        self.titleLabels[self.currentIndex].transform = CGAffineTransformMakeScale(self.style.titleMaximumScaleFactor, self.style.titleMaximumScaleFactor);
    }
    
    if (self.style.isTitleViewScrollEnabled) {
        UILabel *label = [self.titleLabels lastObject];
        if (label) {
            CGSize size = self.scrollView.contentSize;
            size.width = CGRectGetMaxX(label.frame) + self.style.titleMargin * 0.5;
            self.scrollView.contentSize = size;
        }
    }
}

- (void)setupCoverViewLayout {
    if (self.currentIndex >= self.titleLabels.count) {
        return;
    }
    UILabel *label = self.titleLabels[self.currentIndex];
    CGFloat width = label.bounds.size.width;
    CGFloat height = self.style.coverViewHeight;
    CGFloat x = label.frame.origin.x;
    CGFloat y = (label.frame.size.height - height) * 0.5;
    if (self.style.isTitleViewScrollEnabled) {
        x -= self.style.coverMargin;
        width += self.style.coverMargin * 2;
    }
    self.coverView.frame = CGRectMake(x, y, width, height);
}

- (void)setupBottomLineLayout {
    if (self.currentIndex >= self.titleLabels.count) {
        return;
    }
    UILabel *label = self.titleLabels[self.currentIndex];
    CGRect frame = self.bottomLine.frame;
    frame.origin.x = label.frame.origin.x;
    frame.origin.y = self.bounds.size.height - self.style.bottomLineHeight;
    frame.size.width = label.frame.size.width;
    frame.size.height = self.style.bottomLineHeight;
    self.bottomLine.frame = frame;
}


- (void)selectedTitleAtIndex:(NSInteger)index {
    if (self.clickHandler) {
        self.clickHandler(self, index);
    }

    if (index == self.currentIndex) {

        if ([self.delegate respondsToSelector:@selector(titleViewDidSelectSameTitle)]) {
            [self.delegate titleViewDidSelectSameTitle];
        }
        return;
    }

    UILabel *sourceLabel = self.titleLabels[self.currentIndex];
    UILabel *targetLabel = self.titleLabels[index];


    sourceLabel.textColor = self.style.titleColor;
    targetLabel.textColor = self.style.titleSelectedColor;

    self.currentIndex = index;

    [self adjustLabelPosition:targetLabel];

    if ([self.delegate respondsToSelector:@selector(titleView:didSelectAt:)]) {
        [self.delegate titleView:self didSelectAt:self.currentIndex];
    }

    if (self.style.isTitleScaleEnabled) {
        [UIView animateWithDuration:0.25 animations:^{
            sourceLabel.transform = CGAffineTransformIdentity;
            targetLabel.transform = CGAffineTransformMakeScale(self.style.titleMaximumScaleFactor, self.style.titleMaximumScaleFactor);
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
        CGFloat x = self.style.isTitleViewScrollEnabled ? (targetLabel.frame.origin.x - self.style.coverMargin) : targetLabel.frame.origin.x;
        CGFloat width = self.style.isTitleViewScrollEnabled ? (targetLabel.frame.size.width + self.style.coverMargin * 2) : targetLabel.frame.size.width;
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.coverView.frame;
            frame.origin.x = x;
            frame.size.width = width;
            self.coverView.frame = frame;
        }];
    }

    sourceLabel.backgroundColor = [UIColor clearColor];
    targetLabel.backgroundColor = self.style.titleViewSelectedColor;
}


- (void)tapedTitleLabel:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    [self selectedTitleAtIndex:index];
}

- (void)adjustLabelPosition:(UILabel *)targetLabel {
    if (self.style.isTitleViewScrollEnabled) {
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
- (void)contentView:(DNSPageContentView *)contentView didEndScrollAtIndex:(NSInteger)index {
    UILabel *sourceLabel = self.titleLabels[self.currentIndex];
    UILabel *targetLabel = self.titleLabels[index];
    
    sourceLabel.backgroundColor = [UIColor clearColor];
    targetLabel.backgroundColor = self.style.titleViewSelectedColor;
    
    self.currentIndex = index;
    
    [self adjustLabelPosition:targetLabel];
    
    [self fixUI:targetLabel];
}


- (void)contentView:(DNSPageContentView *)contentView scrollingWithSourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex progress:(CGFloat)progress {
    if (sourceIndex >= self.titleLabels.count || sourceIndex < 0) {
        return;
    }
    if (targetIndex >= self.titleLabels.count || targetIndex < 0) {
        return;
    }
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    sourceLabel.textColor = [UIColor colorWithRed:(self.selectRGB.red - progress * self.deltaRGB.red) / 255.0 green:(self.selectRGB.green - progress * self.deltaRGB.green) / 255.0 blue:(self.selectRGB.blue - progress * self.deltaRGB.blue) / 255.0 alpha:1.0];
    targetLabel.textColor = [UIColor colorWithRed:(self.normalRGB.red + progress * self.deltaRGB.red) / 255.0 green:(self.normalRGB.green + progress * self.deltaRGB.green) / 255.0 blue:(self.normalRGB.blue + progress * self.deltaRGB.blue) / 255.0 alpha:1.0];
    
    if (self.style.isTitleScaleEnabled) {
        CGFloat deltaScale = self.style.titleMaximumScaleFactor - 1.0;
        sourceLabel.transform = CGAffineTransformMakeScale(self.style.titleMaximumScaleFactor - progress * deltaScale, self.style.titleMaximumScaleFactor - progress * deltaScale);
        targetLabel.transform = CGAffineTransformMakeScale(1.0 + progress * deltaScale, 1.0 + progress * deltaScale);
    }
    
    if (self.style.isShowBottomLine) {
        CGFloat deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
        CGFloat deltaW = targetLabel.frame.size.width - sourceLabel.frame.size.width;
        CGRect frame = self.bottomLine.frame;
        frame.origin.x = sourceLabel.frame.origin.x + progress * deltaX;
        frame.size.width = sourceLabel.frame.size.width + progress * deltaW;
        self.bottomLine.frame = frame;
    }
    
    if (self.style.isShowCoverView) {
        CGFloat deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
        CGFloat deltaW = targetLabel.frame.size.width - sourceLabel.frame.size.width;
        CGRect frame = self.coverView.frame;
        frame.size.width = self.style.isTitleViewScrollEnabled ? (sourceLabel.frame.size.width + 2 * self.style.coverMargin + deltaW * progress) : (sourceLabel.frame.size.width + deltaW * progress);
        frame.origin.x = self.style.isTitleViewScrollEnabled ? (sourceLabel.frame.origin.x - self.style.coverMargin + deltaX * progress) : (sourceLabel.frame.origin.x + deltaX * progress);
        self.coverView.frame = frame;
    }
}


- (void)fixUI:(UILabel *)targetLabel {
    [UIView animateWithDuration:0.05 animations:^{
        targetLabel.textColor = self.style.titleSelectedColor;
        
        if (self.style.isTitleScaleEnabled) {
            targetLabel.transform = CGAffineTransformMakeScale(self.style.titleMaximumScaleFactor, self.style.titleMaximumScaleFactor);
        }
        if (self.style.isShowBottomLine) {
            CGRect frame = self.bottomLine.frame;
            frame.origin.x = targetLabel.frame.origin.x;
            frame.size.width = targetLabel.frame.size.width;
            self.bottomLine.frame = frame;
        }
        
        if (self.style.isShowCoverView) {
            CGRect frame = self.coverView.frame;
            frame.size.width = self.style.isTitleViewScrollEnabled ? (targetLabel.frame.size.width + 2 * self.style.coverMargin) : targetLabel.frame.size.width;
            frame.origin.x = self.style.isTitleViewScrollEnabled ? (targetLabel.frame.origin.x - self.style.coverMargin) : targetLabel.frame.origin.x;
            self.coverView.frame = frame;
        }
    }];
}

@end
