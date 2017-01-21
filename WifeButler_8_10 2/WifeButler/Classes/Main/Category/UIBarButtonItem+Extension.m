//
//  UIBarButtonItem+Extension.m
//
//
//  Created by teacher on 15/3/2.
//  Copyright (c) 2015年 All rights reserved.
//



@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title norImage:(NSString *)norImage higImage:(NSString *)higImage tagert:(id)tagert action:(SEL)action
{
    UIButton *btn = [[UIButton alloc] init];
    
    // 2.设置图片
    // CUICatalog: Invalid asset name supplied: (null)
    // 如果图片不存在(nil @""), 那么就会报如下错误, Xcode5开始
    if (norImage != nil && ![norImage isEqualToString:@""]) {
        
        [btn setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
    }
    if (higImage != nil && ![higImage isEqualToString:@""]) {
        [btn setImage:[UIImage imageNamed:higImage] forState:UIControlStateHighlighted];
    }
    // 3.设置标题
    if (title != nil && ![title isEqualToString:@""]) {
        
        [btn setTitle:title forState:UIControlStateNormal];
    }
    // 4.自动调整控件以及子控件的frame
    [btn sizeToFit];
    // 5.监听按钮的点击事件
    [btn addTarget:tagert action:action forControlEvents:UIControlEventTouchUpInside];
    // 6.创建item
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
