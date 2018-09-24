//
//  DNSPageCollectionViewFlowLayout.m
//  DNSPageView-ObjC
//
//  Created by Daniels on 2018/9/24.
//  Copyright © 2018年 Daniels. All rights reserved.
//

#import "DNSPageCollectionViewFlowLayout.h"

@implementation DNSPageCollectionViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    if (self.offset) {
        self.collectionView.contentOffset = CGPointMake(self.offset, 0);
    }
}

@end
