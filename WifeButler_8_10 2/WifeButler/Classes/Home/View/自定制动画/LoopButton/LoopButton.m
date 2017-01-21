//
//  LoopButton.m
//  LoopScrollDemo
//
//  Created by white on 16/5/18.
//  Copyright © 2016年 white. All rights reserved.
//

#import "LoopButton.h"
#define KWhiteScreenWidth [UIScreen mainScreen].bounds.size.width
@implementation LoopButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.opaque = NO;
        self.layer.cornerRadius = self.frame.size.width / 2;
        [self setupAttributtes];
    }
    return self;
}


- (void)setTitleColor:(UIColor *)titleColor {
    
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setupAttributtes {
    
    self.layer.masksToBounds = YES;
//    self.layer.borderColor  = [UIColor colorWithRed:0.133 green:0.714 blue:0.620 alpha:1.000].CGColor;
//    self.layer.borderWidth = 1.0f;
    self.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

//- (CGRect)imageRectForContentRect:(CGRect)contentRect {
//    CGFloat width = KWhiteScreenWidth>376?50: KWhiteScreenWidth > 321?40:30; // 30 40 50
//    CGFloat imageX = (self.frame.size.width-width)/2.0;
//    CGFloat imageY = 6;
//    CGFloat height = KWhiteScreenWidth>376?50: KWhiteScreenWidth > 321?40:30;
//    return CGRectMake(imageX, imageY, width, height);
//}
//
//- (CGRect)titleRectForContentRect:(CGRect)contentRect {
//    CGFloat imageX = 10;
//    CGFloat imageY = KWhiteScreenWidth>376?62: KWhiteScreenWidth > 321?52:42;
//    CGFloat width = self.frame.size.width - 20;
//    CGFloat height = KWhiteScreenWidth>376?25: KWhiteScreenWidth > 321?15:5;
//    return CGRectMake(imageX, imageY, width, height);
//}

@end
