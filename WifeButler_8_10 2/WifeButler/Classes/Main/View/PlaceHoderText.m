//
//  PlaceHoderText.m
//  docClient
//
//  Created by yms on 15/12/16.
//  Copyright © 2015年 luo. All rights reserved.
//

#import "PlaceHoderText.h"
#define selfW self.bounds.size.width
#define selfH self.bounds.size.height


@interface PlaceHoderText ()<UITextViewDelegate>

@property (nonatomic,strong)UILabel *placeHoderLabel;

@end

@implementation PlaceHoderText

- (void)awakeFromNib
{
    [self setUpPlaceHoder];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpPlaceHoder];
    }
    return self;
}

- (void)setUpPlaceHoder
{
    self.delegate = self;
    self.font = [UIFont systemFontOfSize:17];
    self.textColor = [UIColor blackColor];
    
    _placeHoderLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 3, 100, self.height-5)];
    _placeHoderLabel.text = @"请输入金额";
    _placeHoderLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_placeHoderLabel];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>=11) {
        textView.text = [textView.text substringToIndex:10];
    }
    
    if (textView.text.length>0) {
        if ([self.subviews containsObject:_placeHoderLabel]) {
            [_placeHoderLabel removeFromSuperview];
        }
        
    }else{
        [self addSubview:_placeHoderLabel];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 0.5);
    [[UIColor lightGrayColor]set];
    CGContextMoveToPoint(ctx, selfW-40, 5);
    CGContextAddLineToPoint(ctx, selfW - 40, selfH - 5);
    CGContextStrokePath(ctx);
    
    [@"元" drawAtPoint:CGPointMake(selfW-30, 10) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
}


@end
