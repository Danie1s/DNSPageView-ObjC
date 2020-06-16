//
//  UIColor+DNSDynamic.h
//  DNSPageView-ObjC
//
//  Created by Daniels on 2020/6/16.
//  Copyright © 2020 Daniels. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DNSDynamic)

+ (instancetype)dns_dynamicColorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
