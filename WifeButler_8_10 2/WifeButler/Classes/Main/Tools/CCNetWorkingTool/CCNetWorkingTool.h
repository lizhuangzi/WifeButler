//
//  CCNetWorkingTool.h
//  UIStackView
//
//  Created by 陈振奎 on 15/12/25.
//  Copyright © 2015年 Mr.chen. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface CCNetWorkingTool : AFHTTPSessionManager

+(instancetype)sharedTool;

#pragma mark - 请求数据
+(NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task , id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error ))failure;


#pragma mark - 上传图片
+(NSURLSessionUploadTask *)upLoadImageWithURLString:(NSString *)URLString parameters:(id)parameters andImageDic:(NSDictionary *)imageDic progress:(void (^)(NSProgress *progress))uploadProgressBlock success:(void (^)(NSURLSessionDataTask *task ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;


#pragma mark - 上传视频
+(NSURLSessionUploadTask *)upLoadVideoWithURLString:(NSString *)URLString parameters:(id)parameters andVideoDic:(NSDictionary *)videoDic progress:(void (^)(NSProgress *progress))uploadProgressBlock success:(void (^)(NSURLSessionDataTask *task ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;

#pragma mark - 下载
//1.下载任务默认关闭 必须开启 resume
//2.任务暂停 suspend 任务取消 cancel
//3.如果想在 progressBlock 中更新 UI ，可在progressBlock中，设置 kvo 监听，在监听代理方法中 *主线程* 更新 UI。
// [downloadProgress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
//代理方法中，NSProgress *progressStr = object;     dispatch_async(dispatch_get_main_queue(), ^{

//double progress =  progressStr.completedUnitCount/progressStr.totalUnitCount;
//更新 UI
//});

+(NSURLSessionDownloadTask *)downloadTaskWithURLString:(NSString *)URLString progress:(void (^)(NSProgress * progress))downloadProgressBlock completionHandler:(void (^)(NSURLResponse * response, NSURL * url, NSError * error))completionHandler;



+(BOOL)success:(NSDictionary *)responseObject;


@end
