//
//  UIColor+DNSDynamic.m
//  DNSPageView-ObjC
//
//  Created by Daniels on 2020/6/16.
//  Copyright © 2020 Daniels. All rights reserved.
//

#import "UIColor+DNSDynamic.h"

@implementation UIColor (DNSDynamic)

+ (instancetype)dns_dynamicColorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
    return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            return lightColor;
        } else {
            return darkColor;
        }
    }];
}

@end
