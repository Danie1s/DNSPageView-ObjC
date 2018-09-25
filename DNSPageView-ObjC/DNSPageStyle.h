//
//  DNSPageStyle.h
//  DNSPageView-ObjC
//
//  Created by Daniels Lau on 2018/9/21.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNSPageStyle : NSObject


@property (nonatomic, assign) CGFloat titleViewHeight;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleViewBackgroundColor;
@property (nonatomic, assign) CGFloat titleMargin;
@property (nullable, nonatomic, strong) UIColor *titleViewSelectedColor;

@property (nonatomic, assign, getter = isTitleViewScrollEnabled) BOOL titleViewScrollEnabled;

@property (nonatomic, assign, getter = isShowBottomLine) BOOL showBottomLine;
@property (nonatomic, strong) UIColor *bottomLineColor;
@property (nonatomic, assign) CGFloat bottomLineHeight;
@property (nonatomic, assign) CGFloat bottomLineRadius;


@property (nonatomic, assign, getter = isTitleScaleEnabled) BOOL titleScaleEnabled;
@property (nonatomic, assign) CGFloat titleMaximumScaleFactor;

@property (nonatomic, assign, getter = isShowCoverView) BOOL showCoverView;
@property (nonatomic, strong) UIColor *coverViewBackgroundColor;
@property (nonatomic, assign) CGFloat coverViewAlpha;
@property (nonatomic, assign) CGFloat coverMargin;
@property (nonatomic, assign) CGFloat coverViewHeight;
@property (nonatomic, assign) CGFloat coverViewRadius;


@property (nonatomic, assign, getter = isContentScrollEnabled) BOOL contentScrollEnabled;
@property (nonatomic, strong) UIColor *contentViewBackgroundColor;

NS_ASSUME_NONNULL_END

@end


