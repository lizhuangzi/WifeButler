//
//  UIImage+ColorExistion.h
//  docClient
//
//  Created by yms on 15/12/14.
//  Copyright © 2015年 luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color;
@end