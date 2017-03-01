//
//  UIView+RedView.h
//  docClient
//
//  Created by yms on 16/4/8.
//  Copyright © 2016年 luo. All rights reserved.
//

#import <UIKit/UIKit.h>


#ifdef NeedRedView

@interface UIView (RedView)


- (void)showRedViewIfNeeded;
- (void)hideRedViewIfNeeded;
// x y 是基于所添加view的右上角为(0,0)来计算的
- (void)showRedViewX:(CGFloat)redViewX redViewY:(CGFloat)redViewY;

- (void)showRedViewAbslouteX:(CGFloat)redViewX redViewY:(CGFloat)redViewY;

- (UIView *)getCurrentRedView;

@end

#endif