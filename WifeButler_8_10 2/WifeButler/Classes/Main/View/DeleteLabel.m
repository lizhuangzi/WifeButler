//
//  DeleteLabel.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/18.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "DeleteLabel.h"

@implementation DeleteLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setNeedsDisplay];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [HexCOLOR(@"#aaaaaa") set];
    
    CGContextMoveToPoint(ctx, 0, rect.size.height/2);
    
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height/2);
    
    CGContextStrokePath(ctx);
}

@end
