//
//  NSString+Size.h
//  HaiZao
//
//  Created by akin on 15/5/24.
//  Copyright (c) 2015年 akin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

// 固定宽度下文字高度
- (NSInteger)heightWithFont:(UIFont *)font maxWidth:(NSInteger)width;

// 固定高度下文字宽度
- (NSInteger)widthWithFont:(UIFont *)font maxHeight:(NSInteger)height;

// textView固定宽度下文字高度
- (NSInteger)textViewHeightWithFont:(UIFont *)font maxWidth:(NSInteger)width;

//过滤表情
+ (NSString *)filterEmoji:(NSString *)string;

//是否含有表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

// 阿拉伯数字转中文
+ (NSString *)translation:(NSString *)arebic;
@end
