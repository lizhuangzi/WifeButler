//
//  LoopButtonManager.h
//  LoopScrollDemo
//
//  Created by white on 16/5/18.
//  Copyright © 2016年 white. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LoopButton.h"

@interface LoopButtonManager : NSObject

/**
 *  根据类型创建button
 *
 *  @param loopButtonType   类型
 *
 *  @return button instance
 */
+ (LoopButton *)buttonWithLoopButtonType:(LoopButtonType)loopButtonType;

/**
 *  转换button类型
 *
 *  @param fromType  原始类型
 *  @param toType   要转换的类型
 */
+ (void)transButtonFromType:(LoopButtonType)fromType toType:(LoopButtonType)toType;

@end
