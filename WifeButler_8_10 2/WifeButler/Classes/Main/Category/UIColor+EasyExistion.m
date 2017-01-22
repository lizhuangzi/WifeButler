//
//  UIColor+EasyExistion.m
//  docClient
//
//  Created by yms on 16/2/25.
//  Copyright © 2016年 luo. All rights reserved.
//

#import "UIColor+EasyExistion.h"

@implementation UIColor (EasyExistion)

+ (UIColor *)setR:(CGFloat)R G:(CGFloat)G B:(CGFloat)B alp:(CGFloat)alp
{
    return [self colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:alp];
}
+ (UIColor *)setR:(CGFloat)R G:(CGFloat)G B:(CGFloat)B
{
    return [self colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}

@end
