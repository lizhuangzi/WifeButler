//
//  ImageUtils.m
//  docClient
//
//  Created by guokang on 15/4/12.
//  Copyright (c) 2015年 luo. All rights reserved.
//

#import "ImageUtils.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation ImageUtils

#define UploadImageMaxSize  1.5f        // 上传图片默认大小限制
#define UploadImageMaxWidth  1280.0f     // 上传图片默认最大宽度限制
#define UploadImageCompressionQualityDefault  0.7 // 上传图片默认压缩比

#define UploadImageForHeadMaxSize  1.0f        // 上传图片默认大小限制
#define UploadImageForHeadMaxWidth  240.0f     // 上传图片默认最大宽度限制

+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef){
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    }
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    return thumbnailImage;
}

/**
 *  图片压缩
 */
+ (UIImage *)comparessImageFromOriginalImage:(UIImage *)originalImage {
    NSData *data = nil;
    CGSize size = originalImage.size;
    CGFloat maxLength = MAX(size.width, size.height);
    if (maxLength > UploadImageMaxWidth) { // 宽度超出限制，计算压缩比例，并进行压缩
        CGFloat scale = UploadImageMaxWidth / maxLength;
        originalImage = [ImageUtils imageWithOriginalImage:originalImage scale:scale];
    }
    data = UIImageJPEGRepresentation(originalImage, 1.0);
    long maxSizeF = UploadImageMaxSize * 1024;
    CGFloat press = UploadImageCompressionQualityDefault;
    int sizeTmp = (int)(data.length / maxSizeF);
    if (sizeTmp >= 3 && sizeTmp <= 4) {
        press = 0.5;
    } else if (sizeTmp >= 4) {
        press = 0.3;
    }
    int count = 0;
    if (data.length > maxSizeF) {
        while (YES) {
            if (count > 3) {
                break;
            }
            count++;
            data = UIImageJPEGRepresentation([UIImage imageWithData:data], press);
            if (data.length <= maxSizeF) {
                break;
            }
        }
    }
    return [UIImage imageWithData:data];
}



/**
 *  等比压缩图片
 */
+ (UIImage *)imageWithOriginalImage:(UIImage *)originalImage scale:(CGFloat)scale {
    CGSize orginalSize = originalImage.size;
    CGSize newSize = CGSizeMake(orginalSize.width * scale, orginalSize.height * scale);
    UIGraphicsBeginImageContext(newSize);
    [originalImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  获取彩色图片的灰度图片
 */
+ (UIImage*)getGrayImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    CGImageRef grayImageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:grayImageRef];
    CGContextRelease(context);
    CGImageRelease(grayImageRef);
    
    return grayImage;
}

/**
 *  采用drawinrect截取图片的一部分
 */
+ (UIImage *) image: (UIImage *) image fillSize: (CGSize) viewsize {
    CGSize size = image.size;
    CGFloat scalex = viewsize.width / size.width;
    CGFloat scaley = viewsize.height / size.height;
    CGFloat scale = MAX(scalex, scaley);
    UIGraphicsBeginImageContext(viewsize);
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    float dwidth = ((viewsize.width - width) / 2.0f);
    float dheight = ((viewsize.height - height) / 2.0f);
    CGRect rect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

/**
 *  根据宽高比，采用drawinrect截取图片的一部分
 */
+ (UIImage *) image: (UIImage *) image aspectRatio: (float) aspectRatio{
    CGSize size = image.size;
    float imgAspectRatio = size.width / size.height;
    CGFloat width = size.width;
    CGFloat height = size.height;
    if (imgAspectRatio > aspectRatio) { // 宽需要剪切
        width = height * aspectRatio;
    } else { // 高度需要剪切
        height = width / aspectRatio;
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    float dwidth = ((width - size.width) / 2.0f);
    float dheight = ((height - size.height) / 2.0f);
    CGRect rect = CGRectMake(dwidth, dheight, size.width, size.height);
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

// 生成纯色image
+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    if (nil == UIGraphicsGetCurrentContext()) {
        return nil;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    [cornerPath addClip];
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 *  截屏
 *
 *  @param view 需要截屏内容的view
 *
 *  @return 截屏图片
 */
+(UIImage *)screenCaptureFromView:(UIView*)view {
    CGRect rect = view.frame;
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 2.将控制器view的layer渲染到上下文
    [view.layer renderInContext:context];
    // 3.取出图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    // 4.结束上下文
    UIGraphicsEndImageContext();
    return img;
}



@end
