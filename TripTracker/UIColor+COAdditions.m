//
//  UIColor+COAdditions.m
//  TripTracker
//
//  Created by Chris O'Neil on 11/4/14.
//
//

#import "UIColor+COAdditions.h"

static const CGFloat kMaximumColorValue = 255.0;

@implementation UIColor (COAdditions)

+ (UIColor *)co_mediumGrayColor {
    return [self co_colorWithRedValue:102.0 greenValue:100.0 blueValue:97.0 alpha:1.0];
}

+ (UIColor *)co_lightGrayColor {
    return [self co_colorWithRedValue:123.0 greenValue:120.0 blueValue:115.0 alpha:1.0];
}

+ (UIColor *)co_lyftGreenColor {
    return [self co_colorWithRedValue:0.0 greenValue:179.0 blueValue:173.0 alpha:1.0];
}

+ (UIColor *)co_cellSeparatorColor {
    return [self co_colorWithRedValue:216.0 greenValue:214.0 blueValue:211.0 alpha:1.0];
}

+ (UIColor *)co_colorWithRedValue:(CGFloat)redValue greenValue:(CGFloat)greenValue blueValue:(CGFloat)blueValue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:redValue / kMaximumColorValue green:greenValue / kMaximumColorValue blue:blueValue / kMaximumColorValue alpha:alpha];
}

@end
