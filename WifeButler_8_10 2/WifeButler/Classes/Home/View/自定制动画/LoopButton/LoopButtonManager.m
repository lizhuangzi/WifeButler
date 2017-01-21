//
//  LoopButtonManager.m
//  LoopScrollDemo
//
//  Created by white on 16/5/18.
//  Copyright © 2016年 white. All rights reserved.
//

#import "LoopButtonManager.h"

#import "LoopLargeButton.h"
#import "LoopSmallButton.h"
#import "LoopMiddleButton.h"

#define KRoundButtonSmallSize CGSizeMake(70, 70)
#define KRoundButtomMiddleSize CGSizeMake(90, 90)
#define KRoundButtonLargeSize CGSizeMake(110, 110)
#define KWhiteScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation LoopButtonManager

+ (LoopButton *)buttonWithLoopButtonType:(LoopButtonType)loopButtonType {
    LoopButton *button = nil;
    switch (loopButtonType) {
        case KLoopButtonTypeSmall:
            button = [[LoopSmallButton alloc] initWithFrame:CGRectMake(0, 0, KWhiteScreenWidth>376?70: KWhiteScreenWidth > 321?60:50, KWhiteScreenWidth>376?70: KWhiteScreenWidth > 321?60:50)];
            break;
        case KLoopButtonTypeMiddle:
            button = [[LoopMiddleButton alloc] initWithFrame:CGRectMake(0, 0, KWhiteScreenWidth>376?90: KWhiteScreenWidth > 321?80:70, KWhiteScreenWidth>376?90: KWhiteScreenWidth > 321?80:70)];
            break;
        case KLoopBUttonTypeLarge:
            button = [[LoopLargeButton alloc] initWithFrame:CGRectMake(0, 0, KWhiteScreenWidth>376?110: KWhiteScreenWidth > 321?100:90, KWhiteScreenWidth>376?110: KWhiteScreenWidth > 321?100:90)];
            break;
    }
    return button;
}

+ (void)transButtonFromType:(LoopButtonType)fromType toType:(LoopButtonType)toType {
    
}

@end
