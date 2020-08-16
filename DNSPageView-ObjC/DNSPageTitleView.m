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
#import "UIColor+DNSRGB.h"



@interface DNSPageTitleView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) NSArray<UILabel *> *titleLabels;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) DNSPageStyle *style;
@property (nonatomic, strong) NSArray<NSString *> *titles;

@property (nonatomic, assign) RGBColorSpace normalRGB;
@property (nonatomic, assign) RGBColorSpace selectRGB;
@property (nonatomic, assign) RGBColorSpace deltaRGB;

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
    }
    return _bottomLine;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
    }
    return _coverView;
}

- (NSArray<NSString *> *)titles {
    if (!_titles) {
        _titles = [NSArray array];
    }
    return _titles;
}

- (DNSPageStyle *)style {
    if (!_style) {
        _style = [[DNSPageStyle alloc] init];
    }
    return _style;
}


- (NSArray<UILabel *> *)titleLabels {
    if (!_titleLabels) {
        _titleLabels = [NSArray array];
    }
    return _titleLabels;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    if ([self.container respondsToSelector:@selector(updateCurrentIndex:)]) {
        [self.container updateCurrentIndex:currentIndex];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(DNSPageStyle *)style
                       titles:(NSArray<NSString *> *)titles
                 currentIndex:(NSInteger)currentIndex {
    NSParameterAssert(currentIndex >= 0 && currentIndex < titles.count);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self configureWithTitles:titles style:style currentIndex:currentIndex];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
                        style:(DNSPageStyle *)style
                       titles:(NSArray<NSString *> *)titles {
    return [self initWithFrame:frame style:style titles: titles currentIndex:0];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self addSubview:self.scrollView];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0,
                                       0,
                                       self.frame.size.width,
                                       self.frame.size.height);
    if (self.titles.count == 0) {
        return;
    }
    [self layoutLabels];
    [self layoutBottomLine];
    [self layoutCoverView];
    
}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self updateColors];
}

- (void)updateColors {
    self.normalRGB = [self.style.titleColor dns_getRGBColorSpace];
    self.selectRGB = [self.style.titleSelectedColor dns_getRGBColorSpace];
    
    RGBColorSpace rgb;
    rgb.red = self.selectRGB.red - self.normalRGB.red;
    rgb.green = self.selectRGB.green - self.normalRGB.green;
    rgb.blue = self.selectRGB.blue - self.normalRGB.blue;
    self.deltaRGB = rgb;
}

- (void)configureWithTitles:(NSArray<NSString *> *)titles
                      style:(DNSPageStyle *)style
               currentIndex:(NSInteger)currentIndex {
    if (titles) {
        self.titles = titles;
    }
    if (style) {
        self.style = style;
        [self updateColors];
    }
    if (currentIndex >= 0) {
        self.currentIndex = currentIndex;
    }
    [self configureSubViews];
    [self setNeedsLayout];
}

- (void)configureWithTitles:(NSArray<NSString *> *)titles style:(DNSPageStyle *)style {
    [self configureWithTitles:titles style:style currentIndex:-1];
}

- (void)configureSubViews {
    self.scrollView.backgroundColor = self.style.titleViewBackgroundColor;
    if (self.titles.count == 0) {
        return;
    }
    [self configureLabels];
    [self configureBottomLine];
    [self configureCoverView];
}



- (void)configureLabels {
    if (self.titles.count == self.titleLabels.count) {
        [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self configureLabelWithLabel:self.titleLabels[idx] idx:idx title:obj];
        }];
    } else {
        [self.titleLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        NSMutableArray *titleLabels = [NSMutableArray array];
        [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *label = [[UILabel alloc] init];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(tapedTitleLabel:)];
            [label addGestureRecognizer:tapGesture];
            label.userInteractionEnabled = YES;
            [self configureLabelWithLabel:label idx:idx title:obj];
            [self.scrollView addSubview:label];
            [titleLabels addObject:label];
        }];
        self.titleLabels = titleLabels;
    }
}

- (void)configureLabelWithLabel:(UILabel *)label idx:(NSInteger)idx title:(NSString *)title {
    label.tag = idx;
    label.text = title;
    label.textColor = idx == self.currentIndex ? self.style.titleSelectedColor : self.style.titleColor;
    label.backgroundColor = idx == self.currentIndex ? self.style.titleViewSelectedColor : [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = self.style.titleFont;
}


- (void)configureBottomLine {
    if (!self.style.isShowBottomLine) {
        [self.bottomLine removeFromSuperview];
        return;
    }
    self.bottomLine.backgroundColor = self.style.bottomLineColor;
    self.bottomLine.layer.cornerRadius = self.style.bottomLineRadius;
    [self.scrollView addSubview:self.bottomLine];
}

- (void)configureCoverView {
    if (!self.style.isShowCoverView) {
        [self.coverView removeFromSuperview];
        return;
    }
    self.coverView.backgroundColor = self.style.coverViewBackgroundColor;
    self.coverView.alpha = self.style.coverViewAlpha;
    self.coverView.layer.cornerRadius = self.style.coverViewRadius;
    self.coverView.layer.masksToBounds = YES;
    [self.scrollView insertSubview:self.coverView atIndex:0];
}


- (void)layoutLabels {
    __block CGFloat x = 0;
    CGFloat y = 0;
    __block CGFloat width = 0;
    CGFloat height = self.frame.size.height;
    
    NSInteger count = self.titles.count;
    [self.titleLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.style.isTitleViewScrollEnabled) {
            width = [self.titles[idx] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName: obj.font}
                                                   context:nil].size.width + self.style.titleInset;
            x = idx == 0 ? self.style.titleMargin * 0.5 : (CGRectGetMaxX(self.titleLabels[idx - 1].frame) + self.style.titleMargin);
        } else {
            width = self.frame.size.width / (CGFloat)count;
            x = width * (CGFloat)idx;
        }
        obj.transform = CGAffineTransformIdentity;
        obj.frame = CGRectMake(x, y, width, height);
    }];
    
    if (self.style.titleSelectedFont) {
        self.titleLabels[self.currentIndex].font = self.style.titleSelectedFont;
    }
    
    if (self.style.isTitleScaleEnabled) {
        self.titleLabels[self.currentIndex].transform = CGAffineTransformMakeScale(self.style.titleMaximumScaleFactor,
                                                                                   self.style.titleMaximumScaleFactor);
    }
    
    if (self.style.isTitleViewScrollEnabled) {
        UILabel *label = [self.titleLabels lastObject];
        if (label) {
            CGSize size = self.scrollView.contentSize;
            size.width = CGRectGetMaxX(label.frame) + self.style.titleMargin * 0.5;
            self.scrollView.contentSize = size;
        }
    }
    [self adjustLabelPosition:self.titleLabels[self.currentIndex] animated:NO];
    [self fixUI:self.titleLabels[self.currentIndex]];
}

- (void)layoutCoverView {
    if (self.currentIndex >= self.titleLabels.count) {
        return;
    }
    UILabel *label = self.titleLabels[self.currentIndex];
    CGFloat width = label.frame.size.width;
    CGFloat height = self.style.coverViewHeight;
    if (self.style.isTitleViewScrollEnabled) {
        width += self.style.coverMargin * 2;
    }
    self.coverView.frame = CGRectMake(0, 0, width, height);
    self.coverView.center = label.center;
}

- (void)layoutBottomLine {
    if (self.currentIndex >= self.titleLabels.count) {
        return;
    }
    UILabel *label = self.titleLabels[self.currentIndex];
    
    CGFloat titleInset = self.style.isTitleViewScrollEnabled ? self.style.titleInset : 0;
    CGRect frame = self.bottomLine.frame;
    frame.size.width = self.style.bottomLineWidth > 0 ? self.style.bottomLineWidth : label.frame.size.width - titleInset;
    frame.size.height = self.style.bottomLineHeight;
    frame.origin.y = self.frame.size.height - frame.size.height;
    self.bottomLine.frame = frame;

    CGPoint center = self.bottomLine.center;
    center.x = label.center.x;
    self.bottomLine.center = center;

}

- (void)selectedTitleAtIndex:(NSInteger)index {
    [self selectedTitleAtIndex:index animated:YES];
}

- (void)selectedTitleAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (index > self.titles.count || index < 0) {
        NSLog(@"DNSPageTitleView -- selectedTitle: 数组越界了, index 的值超出有效范围");
    }

    if (self.clickHandler) {
        self.clickHandler(self, index);
    }

    if (index == self.currentIndex) {
        if ([self.delegate.eventHandler respondsToSelector:@selector(titleViewDidSelectSameTitle)]) {
            [self.delegate.eventHandler titleViewDidSelectSameTitle];
        }
        return;
    }

    UILabel *sourceLabel = self.titleLabels[self.currentIndex];
    UILabel *targetLabel = self.titleLabels[index];


    sourceLabel.textColor = self.style.titleColor;
    targetLabel.textColor = self.style.titleSelectedColor;

    if ([self.delegate.eventHandler respondsToSelector:@selector(contentViewDidDisappear)]) {
        [self.delegate.eventHandler contentViewDidDisappear];
    }

    self.currentIndex = index;

    if ([self.delegate respondsToSelector:@selector(titleView:didSelectAtIndex:)]) {
        [self.delegate titleView:self didSelectAtIndex:self.currentIndex];
    }

    [self adjustLabelPosition:targetLabel animated:animated];
    
    if (self.style.titleSelectedFont) {
        sourceLabel.font = self.style.titleFont;
        targetLabel.font = self.style.titleSelectedFont;
    }

    if (self.style.isTitleScaleEnabled) {
        [UIView animateWithDuration:0.25 animations:^{
            sourceLabel.transform = CGAffineTransformIdentity;
            targetLabel.transform = CGAffineTransformMakeScale(self.style.titleMaximumScaleFactor,
                                                               self.style.titleMaximumScaleFactor);
        }];
    }

    if (self.style.isShowBottomLine) {
        CGFloat titleInset = self.style.isTitleViewScrollEnabled ? self.style.titleInset : 0;
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.bottomLine.frame;
            frame.size.width = self.style.bottomLineWidth > 0 ?
                self.style.bottomLineWidth : targetLabel.frame.size.width - titleInset;
            self.bottomLine.frame = frame;
            
            CGPoint center = self.bottomLine.center;
            center.x = targetLabel.center.x;
            self.bottomLine.center = center;
        }];
    }

    if (self.style.isShowCoverView) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.coverView.frame;
            frame.size.width = self.style.isTitleViewScrollEnabled ?
                (targetLabel.frame.size.width + self.style.coverMargin * 2) : targetLabel.frame.size.width;;
            self.coverView.frame = frame;
            
            CGPoint center = self.coverView.center;
            center.x = targetLabel.center.x;
            self.coverView.center = center;
        }];
    }

    sourceLabel.backgroundColor = [UIColor clearColor];
    targetLabel.backgroundColor = self.style.titleViewSelectedColor;
}


- (void)tapedTitleLabel:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    [self selectedTitleAtIndex:index];
}

- (void)adjustLabelPosition:(UILabel *)targetLabel animated:(BOOL)animated {
    if (self.style.isTitleViewScrollEnabled && self.scrollView.contentSize.width > self.scrollView.frame.size.width) {
        CGFloat offsetX = targetLabel.center.x - self.frame.size.width * 0.5;
        if (offsetX < 0) {
            offsetX = 0;
        }
        if (offsetX > self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
            offsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
        }
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
    }
}


#pragma mark - DNSPageContentViewDelegate
- (void)contentView:(DNSPageContentView *)contentView didEndScrollAtIndex:(NSInteger)index {
    UILabel *sourceLabel = self.titleLabels[self.currentIndex];
    UILabel *targetLabel = self.titleLabels[index];
    
    if (self.style.titleSelectedFont) {
        sourceLabel.font = self.style.titleFont;
        targetLabel.font = self.style.titleSelectedFont;
    }
    
    sourceLabel.textColor = self.style.titleColor;
    sourceLabel.backgroundColor = [UIColor clearColor];
    targetLabel.backgroundColor = self.style.titleViewSelectedColor;
    
    self.currentIndex = index;
    
    [self adjustLabelPosition:targetLabel animated:YES];
    
    [self fixUI:targetLabel];
}


- (void)contentView:(DNSPageContentView *)contentView
scrollingWithSourceIndex:(NSInteger)sourceIndex
        targetIndex:(NSInteger)targetIndex
           progress:(CGFloat)progress {
    if (sourceIndex >= self.titleLabels.count || sourceIndex < 0) {
        return;
    }
    if (targetIndex >= self.titleLabels.count || targetIndex < 0) {
        return;
    }
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    RGBColorSpace rgb1 = {self.selectRGB.red - progress * self.deltaRGB.red,
                          self.selectRGB.green - progress * self.deltaRGB.green,
                          self.selectRGB.blue - progress * self.deltaRGB.blue};
    sourceLabel.textColor = [UIColor dns_colorWithRGBColorSpace:rgb1];
    RGBColorSpace rgb2 = {self.normalRGB.red + progress * self.deltaRGB.red,
                          self.normalRGB.green + progress * self.deltaRGB.green,
                          self.normalRGB.blue + progress * self.deltaRGB.blue};
    targetLabel.textColor = [UIColor dns_colorWithRGBColorSpace:rgb2];
    if (self.style.isTitleScaleEnabled) {
        CGFloat deltaScale = self.style.titleMaximumScaleFactor - 1.0;
        sourceLabel.transform = CGAffineTransformMakeScale(self.style.titleMaximumScaleFactor - progress * deltaScale,
                                                           self.style.titleMaximumScaleFactor - progress * deltaScale);
        targetLabel.transform = CGAffineTransformMakeScale(1.0 + progress * deltaScale, 1.0 + progress * deltaScale);
    }
    
    if (self.style.isShowBottomLine) {
        if (self.style.bottomLineWidth <= 0) {
            CGFloat titleInset = self.style.isTitleViewScrollEnabled ? self.style.titleInset : 0;
            CGFloat deltaWidth = targetLabel.frame.size.width - sourceLabel.frame.size.width;
            CGRect frame = self.bottomLine.frame;
            frame.size.width = sourceLabel.frame.size.width - titleInset + progress * deltaWidth;
            self.bottomLine.frame = frame;
        }
        
        CGFloat deltaCenterX = targetLabel.center.x - sourceLabel.center.x;
        CGPoint center = self.bottomLine.center;
        center.x = sourceLabel.center.x + progress * deltaCenterX;
        self.bottomLine.center = center;
    }
    
    if (self.style.isShowCoverView) {
        CGFloat deltaWidth = targetLabel.frame.size.width - sourceLabel.frame.size.width;
        CGRect frame = self.coverView.frame;
        frame.size.width = self.style.isTitleViewScrollEnabled ?
            (sourceLabel.frame.size.width + 2 * self.style.coverMargin + deltaWidth * progress) :
            (sourceLabel.frame.size.width + deltaWidth * progress);
        self.coverView.frame = frame;
        
        CGFloat deltaCenterX = targetLabel.center.x - sourceLabel.center.x;
        CGPoint center = self.coverView.center;
        center.x = sourceLabel.center.x + progress * deltaCenterX;
        self.coverView.center = center;
    }
}


- (void)fixUI:(UILabel *)targetLabel {
    [UIView animateWithDuration:0.05 animations:^{
        targetLabel.textColor = self.style.titleSelectedColor;
        
        if (self.style.isTitleScaleEnabled) {
            targetLabel.transform = CGAffineTransformMakeScale(self.style.titleMaximumScaleFactor, self.style.titleMaximumScaleFactor);
        }

        if (self.style.isShowBottomLine) {
            if (self.style.bottomLineWidth <= 0) {
                CGFloat titleInset = self.style.isTitleViewScrollEnabled ? self.style.titleInset : 0;
                CGRect frame = self.bottomLine.frame;
                frame.size.width = targetLabel.frame.size.width - titleInset;
                self.bottomLine.frame = frame;
            }
            
            CGPoint center = self.bottomLine.center;
            center.x = targetLabel.center.x;
            self.bottomLine.center = center;
        }
        
        if (self.style.isShowCoverView) {
            CGRect frame = self.coverView.frame;
            frame.size.width = self.style.isTitleViewScrollEnabled ?
                (targetLabel.frame.size.width + 2 * self.style.coverMargin) : targetLabel.frame.size.width;
            self.coverView.frame = frame;
            
            CGPoint center = self.coverView.center;
            center.x = targetLabel.center.x;
            self.coverView.center = center;
        }
    }];
}

@end
