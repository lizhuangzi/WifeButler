//
//  FontUtils.m
//  docClient
//
//  Created by USER on 15-3-16.
//  Copyright (c) 2015年 luo. All rights reserved.
//

#import "FontUtils.h"
#import <CoreText/CoreText.h>

// 判断是否为ios7
#define IOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)

@implementation FontUtils

/**
 *  特定空间内，文字所占空间大小
 *
 *  @param text
 *  @param size
 *  @param font
 *  @return
 */
+ (CGSize)stringSize:(NSString *)text withSize:(CGSize)size font:(UIFont*) font{
    CGSize stringSize;
    if (![text isKindOfClass:[NSString class]])
        return CGSizeMake(0, 0);

    // 系统不支持6.0以下系统，故不考虑6.0以下获取文字控件大小方法
    if (!IOS7) {
        NSDictionary *attrs = @{NSFontAttributeName: font};
        NSAttributedString *attribStr = [[NSAttributedString alloc] initWithString:text attributes:attrs];
        stringSize = [attribStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine context:nil].size;
    } else {
        NSDictionary *attribute = @{NSFontAttributeName:font};
        stringSize = [text boundingRectWithSize:size
                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    }
    return stringSize;
}

/**
 * 特定空间内，文字所占空间大小
 *  @param text
 *  @param size
 *  @param attrs
 *  @return
 */
+(CGSize) stringSize:(NSString *)text withSize:(CGSize)size withAttrsDic:(NSDictionary *) attrs{
    CGSize stringSize;
    if (!IOS7) {
        NSAttributedString *attribStr = [[NSAttributedString alloc] initWithString:text attributes:attrs];
        stringSize = [attribStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading context:nil].size;
    } else {
        stringSize = [text boundingRectWithSize:size
                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attrs
                                        context:nil].size;
    }
    return stringSize;
}


+ (NSAttributedString *)stringWithWeChatFriendCircleStyleString:(NSString *)string
{
    if (!string) {
        return nil;
    }
    NSMutableAttributedString *attrStr =[[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:2];
    
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.length)];
    
    CGFloat sizeValue = AttributedStrSize;
    
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:sizeValue] range:NSMakeRange(0, attrStr.length)];
    
//    long number = 1;
//    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
//    
//    [attrStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attrStr length])];
//    
//    CFRelease(num);
    
    return attrStr;
}

+ (NSAttributedString *)stringWithWeChatFriendCircleStyleString:(NSString *)string isGetHig:(BOOL)isGetHig
{
    NSMutableAttributedString *attrStr =[[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:2];
    
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.length)];
    
    CGFloat sizeValue = AttributedStrSize;
    
    if (!isGetHig) {
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;  // 计算高度时不执行 显示时执行
    }
    
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:sizeValue] range:NSMakeRange(0, attrStr.length)];
    
    return attrStr;
}

@end
