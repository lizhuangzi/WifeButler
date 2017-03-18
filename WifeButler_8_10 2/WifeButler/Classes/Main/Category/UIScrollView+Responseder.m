//
//  UIScrollView+Responseder.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/17.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "UIScrollView+Responseder.h"

@implementation UIScrollView (Responseder)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}


@end
