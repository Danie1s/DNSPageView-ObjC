//
//  DNSPageTitleView.h
//  DNSPageView-ObjC
//
//  Created by Daniels Lau on 2018/9/21.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNSPageStyle.h"

NS_ASSUME_NONNULL_BEGIN

@class DNSPageTitleView;
@protocol DNSPageTitleViewDelegate <NSObject>

- (void)titleView:(DNSPageTitleView *)titleView currentIndex:(NSInteger)currentIndex;

- (void)titleViewDidSelectedSameTitle;

- (void)contentViewDidEndScroll;

@end

typedef void (^TitleClickHandler)(DNSPageTitleView *titleView, NSInteger currentIndex);

@interface DNSPageTitleView : UIView

@property (nonatomic, weak) id delegate;

@property (nonatomic, copy) TitleClickHandler clickHandler;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong, readonly) NSArray<UILabel *> *titleLabels;

@property (nonatomic, strong) DNSPageStyle *style;

@property (nonatomic, strong) NSArray<NSString *> *titles;

@property (nonatomic, strong) UIView *coverView;

@end

NS_ASSUME_NONNULL_END
