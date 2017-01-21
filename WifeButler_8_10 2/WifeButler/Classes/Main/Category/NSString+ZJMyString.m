//
//  NSString+ZJMyString.m
//  Fish
//
//  Created by JL on 15/6/10.
//  Copyright (c) 2015年 zjtdmac3. All rights reserved.
//

#import "NSString+ZJMyString.h"

@implementation NSString (ZJMyString)

- (CGFloat)getMyStringHeightWithFont:(UIFont *)font andSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize StringSize= [self boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return StringSize.height;
}
- (CGFloat)getMyStringWidthWidthWithFont:(UIFont *)font andSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize StringSize= [self boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return StringSize.width;
}
- (CGSize)getMyStringSizeWithFont:(UIFont *)font andSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize StringSize= [self boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return StringSize;
}
@end
