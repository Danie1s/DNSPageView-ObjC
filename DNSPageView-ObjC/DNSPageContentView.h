//
//  DNSPageContentView.h
//  DNSPageView-ObjC
//
//  Created by Daniels on 2018/9/24.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNSPageStyle.h"

NS_ASSUME_NONNULL_BEGIN
@class DNSPageContentView;

@protocol DNSPageContentViewDelegate <NSObject>

- (void)contentView:(DNSPageContentView *)contentView inIndex:(NSInteger)inIndex;

- (void)contentView:(DNSPageContentView *)contentView sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex progress:(CGFloat)progress;

@end

@interface DNSPageContentView : UIView

@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) DNSPageStyle *style;

@property (nonatomic, strong) NSArray<UIViewController *> *childViewControllers;

@property (nonatomic, assign) NSInteger startIndex;

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
