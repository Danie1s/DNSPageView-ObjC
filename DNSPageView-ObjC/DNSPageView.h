//
//  DNSPageView.h
//  DNSPageView-ObjC
//
//  Created by Daniels Lau on 2018/9/25.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNSPageStyle.h"

@class DNSPageTitleView, DNSPageContentView;
NS_ASSUME_NONNULL_BEGIN

@interface DNSPageView : UIView

@property (nonatomic, strong, readonly) DNSPageStyle *style;

@property (nonatomic, strong, readonly) NSArray<NSString *> *titles;

@property (nonatomic, strong, readonly) NSArray<UIViewController *> *childViewControllers;

@property (nonatomic, strong, readonly) DNSPageTitleView *titleView;

@property (nonatomic, strong, readonly) DNSPageContentView *contentView;

- (instancetype)initWithFrame:(CGRect)frame style:(DNSPageStyle *)style titles:(NSArray<NSString *> *)titles childViewControllers:(NSArray<UIViewController *> *)childViewControllers;

@end

NS_ASSUME_NONNULL_END
