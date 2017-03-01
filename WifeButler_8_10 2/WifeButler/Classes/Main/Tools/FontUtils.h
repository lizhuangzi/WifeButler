//
//  FontUtils.h
//  docClient
//
//  Created by USER on 15-3-16.
//  Copyright (c) 2015年 luo. All rights reserved.
//

#import <Foundation/Foundation.h>

static CGFloat adaptiveHeight(CGFloat i6_h,CGFloat i6p_h,CGFloat h) {
    CGFloat height;
    static CGFloat screenHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        screenHeight = [UIScreen mainScreen].bounds.size.height;
    });
    if (screenHeight == 667) {
        height = i6_h;
    }else if (screenHeight == 736) {
        height = i6p_h;
    }else {
        height = h;
    }
    return height;
};

#define AdaptiveHeight(i6,i6p,i)  adaptiveHeight(i6,i6p,i)

#define AttributedStrHIG   AdaptiveHeight(118,121,111)
#define AttributedStrSize  AdaptiveHeight(15,15.5,14)

@interface FontUtils : NSObject

/**
 *  特定空间内，文字所占空间大小
 *
 *  @param text
 *  @param size
 *  @param font
 *
 *  @return
 */
+ (CGSize)stringSize:(NSString *)text  withSize:(CGSize)size font:(UIFont*) font;

/**
 * 特定空间内，文字所占空间大小
 *  @param text
 *  @param size
 *  @param attrs
 *  @return
 */
+(CGSize) stringSize:(NSString *)text withSize:(CGSize)size withAttrsDic:(NSDictionary *) attrs;
/**
 根据一段文字返回一个类似于微信学术圈样式的文本
 */
+ (NSAttributedString *)stringWithWeChatFriendCircleStyleString:(NSString *)string;


/**
 根据一段文字返回一个类似于微信学术圈样式的文本 
 显示省略号时调用 类似患教内容
 @param isGetHig 计算高度时传YES 设置attributed时传NO
 */
+ (NSAttributedString *)stringWithWeChatFriendCircleStyleString:(NSString *)string isGetHig:(BOOL)isGetHig;

@end
