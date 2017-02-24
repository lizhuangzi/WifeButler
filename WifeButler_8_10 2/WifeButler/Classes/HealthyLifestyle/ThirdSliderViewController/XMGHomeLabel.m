//
//  XMGHomeLabel.m
//  02-网易新闻首页
//
//  Created by xiaomage on 15/7/6.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGHomeLabel.h"
#import "XMGConst.h"

//static const CGFloat XMGRed = 0.4;
//static const CGFloat XMGGreen = 0.6;
//static const CGFloat XMGBlue = 0.7;

//#define XMGRed 0.4
//#define XMGGreen 0.6
//#define XMGBlue 0.7
//#define XMGName @"jack"

@implementation XMGHomeLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:15];
        self.textColor = [UIColor colorWithRed:XMGRed green:XMGGreen blue:XMGBlue alpha:1.0];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    //      R G B
    // 默认：0.4 0.6 0.7
    // 红色：1   0   0
    
    CGFloat red = XMGRed + (1 - XMGRed) * scale;
    CGFloat green = XMGGreen + (0 - XMGGreen) * scale;
    CGFloat blue = XMGBlue + (0 - XMGBlue) * scale;
    self.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    // 大小缩放比例
    CGFloat transformScale = 1 + scale * 0.3; // [1, 1.3]
    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
}
@end