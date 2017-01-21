//
//  LoopButton.h
//  LoopScrollDemo
//
//  Created by white on 16/5/18.
//  Copyright © 2016年 white. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoopButtonType) {
    KLoopButtonTypeSmall = 0,
    KLoopButtonTypeMiddle,
    KLoopBUttonTypeLarge,
};

@interface LoopButton : UIButton

/**
 *   字体颜色
 */
@property (nonatomic,strong) UIColor *titleColor;

@property (nonatomic,readonly) LoopButtonType type;


@end
