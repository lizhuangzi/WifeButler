//
//  titleBottomButton.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/8.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "titleBottomButton.h"

@implementation titleBottomButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+5, self.width, 22);
}
@end
