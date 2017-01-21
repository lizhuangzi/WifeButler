//
//  UIColor+HexColor.m
//  CCME
//
//  Created by huangwei on 14-9-7.
//  Copyright (c) 2014年 ___beidou___. All rights reserved.
//

#import "UIColor+HexColor.h"

#define DEFAULT_VOID_COLOR [UIColor clearColor]

@implementation UIColor (HexColor)

+ (UIColor *)hexColor:(int)hex {
    return  [self hexColor:hex alpha:1.0];
}

+ (UIColor *)hexColor:(int)hex alpha:(CGFloat)alpha
{
    float red = ((float)((hex & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hex & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hex & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    return [self colorWithHexString:stringToConvert Alpha:1.0];
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert Alpha:(CGFloat)alpha
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];

}

@end
