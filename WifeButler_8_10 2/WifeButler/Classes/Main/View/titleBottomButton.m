//
//  titleBottomButton.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/8.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "titleBottomButton.h"

@interface titleBottomButton ()

@property (nonatomic,assign) CGFloat imageWidth;
@property (nonatomic,assign) CGFloat imageHegiht;
@end

@implementation titleBottomButton

- (instancetype)initWithImageWidth:(CGFloat)imageWidth andHeight:(CGFloat)height
{
    if (self = [super init]) {
        self.imageWidth = imageWidth;
        self.imageHegiht = height;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.width, 22);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - self.imageWidth)/2 , 0, self.imageWidth, self.imageHegiht);
}

@end
