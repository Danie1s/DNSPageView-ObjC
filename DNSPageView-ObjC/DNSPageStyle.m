//
//  DNSPageStyle.m
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

#import "DNSPageStyle.h"

@implementation DNSPageStyle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleViewHeight = 44;
        self.titleColor = [UIColor blackColor];
        self.titleSelectedColor = [UIColor blueColor];
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
