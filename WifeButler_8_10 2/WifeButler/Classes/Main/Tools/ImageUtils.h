//
//  ImageUtils.h
//  docClient
//
//  Created by guokang on 15/4/12.
//  Copyright (c) 2015年 luo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageUtils : NSObject

typedef void (^ImageUtilReponseBlock)(NSArray *urlArray,NSDictionary *responseData);

// 获取视频缩略图
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

/**
 *  图片压缩
 */
+ (UIImage *)comparessImageFromOriginalImage:(UIImage *)originalImage;

+ (NSData *)comparessImageReturnDataWithOriginalImage:(UIImage *)originalImage;
/**
 *  等比压缩图片
 */
+ (UIImage *)imageWithOriginalImage:(UIImage *)originalImage scale:(CGFloat)scale;

/**
 *  获取彩色图片的灰度图片
 */
+ (UIImage*)getGrayImage:(UIImage*)sourceImage;

/**
 *  采用drawinrect截取图片的一部分
 */
+ (UIImage *)image: (UIImage *) image fillSize: (CGSize) viewsize;

/**
 *  根据宽高比，采用drawinrect截取图片的一部分
 */
+ (UIImage *)image: (UIImage *) image aspectRatio: (float) aspectRatio;

// 生成纯色image
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
 *  生成纯色的圆角图片
 *
 *  @param color          图片颜色
 *  @param size           图片大小
 *  @param cornerRadius   圆角弧度
 *  @param rectCornerType
 *
 *  @return 
 */
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;
/**
 *  截屏
 *
 *  @param view 需要截屏内容的view
 *
 *  @return 截屏图片
 */
+(UIImage *)screenCaptureFromView:(UIView*)view;



@end
