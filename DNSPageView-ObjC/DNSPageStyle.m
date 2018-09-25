//
//  DNSPageStyle.m
//  DNSPageView-ObjC
//
//  Created by Daniels Lau on 2018/9/21.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import "DNSPageStyle.h"

@implementation DNSPageStyle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleViewHeight = 44;
        self.titleColor = [UIColor blackColor];
        self.titleSelectedColor = [UIColor blackColor];
        self.titleFont = [UIFont systemFontOfSize:15];
        self.titleViewBackgroundColor = [UIColor whiteColor];
        self.titleMargin = 30;
        
        self.titleViewScrollEnabled = NO;
        
        self.showBottomLine = NO;
        self.bottomLineColor = [UIColor blueColor];
        self.bottomLineHeight = 2;
        self.bottomLineRadius = 1;
        
        self.titleScaleEnabled = NO;
        self.titleMaximumScaleFactor = 1.2;
        
        self.showCoverView = NO;
        self.coverViewBackgroundColor = [UIColor blackColor];
        self.coverViewAlpha = 0.4;
        self.coverMargin = 8;
        self.coverViewHeight = 25;
        self.coverViewRadius = 12;
        
        self.contentScrollEnabled = YES;
        self.contentViewBackgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
