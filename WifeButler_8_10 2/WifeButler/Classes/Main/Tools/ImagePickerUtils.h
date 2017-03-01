//
//  ImagePickerUtils.h
//  docClient
//
//  Created by GDXL2012 on 15/10/13.
//  Copyright (c) 2015年 luo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBImagePickerController.h"

typedef enum ImagePickerMode{
    kImagePickerModePhoto = 0,
    kImagePickerModeVideo
}ImagePickerMode;

@interface ImagePickerUtils : NSObject

extern void ((^ImagePickerUtilsQBSettingBlock)(UINavigationController* qbvc));
/**
 *  选择照片，用于除头像、学术圈背景等单张图片选择页面
 *
 *  @param viewController 相册选择页面弹出页面
 *  @param multip         是否多选
 *  @param type           视频/照片
 *  @param minNumber      最小图片数, =0时不限制
 *  @param maxNumber      最大图片数, =0时不限制
 *  @param delegate       选择完成协议回调
 */
+(void)customPhotoSelect:(UIViewController *)viewController multip:(BOOL)multip filterType:(QBImagePickerControllerFilterType)type minNumber:(NSUInteger)minNumber maxNumber:(NSUInteger)maxNumber delegate:(id<QBImagePickerControllerDelegate>)delegate;

/**
 *  选择一张图片文件
 *  主要用于头像、学术圈背景等单张图片设置
 *
 *  @param viewController
 *  @param allowsEditing
 *  @param delegate
 */
+ (void)selectPhotoFromViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing withDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>) delegate;

/**
 *  拍照或拍摄视频
 *
 *  @param vc
 *  @param mode
 *  @param allowsEditing
 *  @param delegate
 */
+(void)takePhotoFromVC:(UIViewController *)vc imgMode:(ImagePickerMode)mode allowsEditing:(BOOL)allowsEditing withDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>) delegate;
@end
