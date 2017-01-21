//
//  UIBarButtonItem+Extension.h
//
//
//  Created by teacher on 15/3/2.
//  Copyright (c) 2015年 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
/**
 *  快速创建item
 *
 *  @param title    需要显示的标题
 *  @param norImage 默认状态显示的图片
 *  @param higImage 高亮状态显示的图片
 */
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title norImage:(NSString *)norImage higImage:(NSString *)higImage tagert:(id)tagert action:(SEL)action;
@end
