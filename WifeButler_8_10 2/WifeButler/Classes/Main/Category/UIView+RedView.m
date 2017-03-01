//
//  UIView+RedView.m
//  docClient
//
//  Created by yms on 16/4/8.
//  Copyright © 2016年 luo. All rights reserved.
//

#import "UIView+RedView.h"

@implementation UIView (RedView)


- (void)showRedViewIfNeeded
{
    
    if (self.getCurrentRedView) return;
    
    CGFloat allWidth = self.bounds.size.width;
    
    CGFloat x = allWidth - 8;
    UIView * imageRed=[[UIView alloc] initWithFrame:CGRectMake(x, 2, 8, 8)];
    imageRed.backgroundColor=  [UIColor redColor];
    imageRed.layer.cornerRadius= imageRed.frame.size.width / 2;
    imageRed.tag = 1003;
    [self addSubview:imageRed];

}
// x y 是基于所添加view的右上角为(0,0)来计算的
- (void)showRedViewX:(CGFloat)redViewX redViewY:(CGFloat)redViewY
{
    
    if (self.getCurrentRedView) return;
    
    CGFloat allWidth = self.bounds.size.width;
    
    CGFloat x = allWidth + redViewX;
    UIView * imageRed=[[UIView alloc] initWithFrame:CGRectMake(x, redViewY, 8, 8)];
    imageRed.backgroundColor= [UIColor redColor];
    imageRed.layer.cornerRadius= imageRed.frame.size.width / 2;
    imageRed.tag = 1003;
    [self addSubview:imageRed];
    
}

- (void)showRedViewAbslouteX:(CGFloat)redViewX redViewY:(CGFloat)redViewY
{
     if (self.getCurrentRedView) return;
     UIView * imageRed=[[UIView alloc] initWithFrame:CGRectMake(redViewX, redViewY, 8, 8)];
    imageRed.backgroundColor= [UIColor redColor];
    imageRed.tag = 1003;
    imageRed.layer.cornerRadius= imageRed.frame.size.width / 2;
    [self addSubview:imageRed];
}

- (void)hideRedViewIfNeeded
{
    if (!self.getCurrentRedView) return;
    UIView * redView = [self viewWithTag:1003];
    [redView removeFromSuperview];
}

- (UIView *)getCurrentRedView
{
    return [self viewWithTag:1003];
}
@end
