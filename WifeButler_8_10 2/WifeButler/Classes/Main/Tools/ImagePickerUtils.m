//
//  ImagePickerUtils.m
//  docClient
//
//  Created by GDXL2012 on 15/10/13.
//  Copyright (c) 2015年 luo. All rights reserved.
//

#import "ImagePickerUtils.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "HomeNavgationController.h"

@implementation ImagePickerUtils

void ((^ImagePickerUtilsQBSettingBlock)(UINavigationController * vc));
/**
 *  选择照片，用于除头像、学术圈背景等单张图片选择页面
 *
 *  @param viewController 相册选择页面弹出页面
 *  @param multip         是否多选
 *  @param type           视频/照片
 *  @param minNumber      最小图片数, <=0时不限制
 *  @param maxNumber      最大图片数，<=0时不限制
 *  @param delegate       选择完成协议回调
 */
+(void)customPhotoSelect:(UIViewController *)viewController multip:(BOOL)multip filterType:(QBImagePickerControllerFilterType)type minNumber:(NSUInteger)minNumber maxNumber:(NSUInteger)maxNumber delegate:(id<QBImagePickerControllerDelegate>)delegate{
    //相片权限
    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc] init];
    __block BOOL isStop=NO;
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (!isStop) {
            if (*stop) {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [DOCutils showNotifitationInWindowOffset:@"医学参考没有访问相册的权限。请在设置->隐私->照片权限中开启访问权限。"];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    QBImagePickerController *qbViewController = [[QBImagePickerController alloc] init];
                    qbViewController.allowsMultipleSelection = multip;
                    qbViewController.filterType = type;
                    qbViewController.maximumNumberOfSelection = maxNumber;
                    qbViewController.minimumNumberOfSelection = minNumber;
                    qbViewController.delegate = delegate;
                    
                    UINavigationController *nv = [[HomeNavgationController alloc] initWithRootViewController:qbViewController];
                    [viewController presentViewController:nv animated:YES completion:nil];
                    
                    if (ImagePickerUtilsQBSettingBlock) {
                        ImagePickerUtilsQBSettingBlock(nv);
                    }
                    
                });
                isStop=YES;
            }
        }
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [DOCutils showNotifitationInWindowOffset:@"医学参考没有访问相册的权限。请在设置->隐私->照片权限中开启访问权限。"];
        });
    }];
}

/**
 *  选择一张图片文件
 *  主要用于头像、学术圈背景等单张图片设置
 *
 *  @param viewController
 *  @param allowsEditing
 *  @param delegate
 */
+ (void)selectPhotoFromViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing withDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>) delegate {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = allowsEditing;
    imagePickerController.delegate = delegate;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [viewController presentViewController:imagePickerController animated:YES completion:nil];
}

/**
 *  拍照或拍摄视频
 *
 *  @param vc
 *  @param mode
 *  @param allowsEditing
 *  @param delegate
 */
+(void)takePhotoFromVC:(UIViewController *)vc imgMode:(ImagePickerMode)mode allowsEditing:(BOOL)allowsEditing withDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>) delegate{
  
        //拍照仅仅涉及相机权限
        if (mode == kImagePickerModePhoto) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL videoGranted) {
                if (videoGranted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ImagePickerUtils commonTakePhotoFromViewController:vc ImagePickerMode:mode allowsEditing:allowsEditing withDelegate:delegate];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [DOCutils showNotifitationInWindowOffset:@"医学参考没有访问相机的权限，无法进行拍照。请在设置->隐私->相机权限中开启访问权限。"];
                    });
                }
            }];
        }
        //摄像涉及的权限
        else {
            //相机权限
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL videoGranted) {
                if (videoGranted) {
                    //麦克风权限
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL audioGranted) {
                        if (audioGranted) {
                            //相片权限
                            ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc] init];
                            __block BOOL isStop=NO;
                            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                if (!isStop) {
                                    if (*stop) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                            [DOCutils showNotifitationInWindowOffset:@"医学参考没有访问照片的权限，无法进行拍摄。请在设置->隐私->照片权限中开启访问权限。"];
                                        });
                                    }
                                    else
                                    {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [ImagePickerUtils commonTakePhotoFromViewController:vc ImagePickerMode:mode allowsEditing:allowsEditing withDelegate:delegate];
                                        });
                                        isStop=YES;
                                    }
                                }
                            } failureBlock:^(NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    [DOCutils showNotifitationInWindowOffset:@"医学参考没有访问照片的权限，无法进行拍摄。请在设置->隐私->照片权限中开启访问权限。"];
                                });
                            }];
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [DOCutils showNotifitationInWindowOffset:@"医学参考没有访问麦克风的权限，无法进行拍摄。请在设置->隐私->麦克风权限中开启访问权限。"];
                            });
                        }
                    }];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //[AlertUtil showAlertWithText:@"请在隐私设置中开启可视的拍照权限"];
//                        [DOCutils showNotifitationInWindow:@"请在隐私设置中开启医学参考的相机权限"];
                    });
                }
            }];
        }
    
    
}

+(void)commonTakePhotoFromViewController:(UIViewController *)viewController ImagePickerMode:(ImagePickerMode)mode allowsEditing:(BOOL)allowsEditing
  withDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>) delegate{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.allowsEditing = allowsEditing;
        imagePickerController.delegate = delegate;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        
        NSString *requiredMediaType = (NSString *)kUTTypeImage;
        if (mode == kImagePickerModeVideo) {
            requiredMediaType = (NSString *)kUTTypeMovie;
            // 设置录制视频的质量
            [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeMedium];
            //设置最长摄像时间
//            [imagePickerController setVideoMaximumDuration:60.f];
        }
        NSArray *arrMediaTypes = [NSArray arrayWithObjects:requiredMediaType, nil];
        [imagePickerController setMediaTypes:arrMediaTypes];
        
        imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        imagePickerController.showsCameraControls = YES;
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            viewController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        }
        [viewController presentViewController:imagePickerController animated:YES completion:nil];
    } else {
      //  [DOCutils showNotifitationInWindow:@"设备不支持拍照功能"];
    }
}
@end
