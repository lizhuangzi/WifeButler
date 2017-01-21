//
//  CCNetWorkingTool.m
//  UIStackView
//
//  Created by 陈振奎 on 15/12/25.
//  Copyright © 2015年 Mr.chen. All rights reserved.
//

#import "CCNetWorkingTool.h"
#import "ZJLoginController.h"
@implementation CCNetWorkingTool

+(instancetype)sharedTool{
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self manager];
    });
    
    return instance;
    
}

+(NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task , id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    CCNetWorkingTool *tool = [CCNetWorkingTool sharedTool];
    tool.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
      [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
    
   NSURLSessionDataTask *task = [tool GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       
       if (success) {
           success(task,responseObject);
       }
       if ([self success:responseObject]) {
           [SVProgressHUD dismiss];
       }else{
           
           [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
           if ([responseObject[@"message"] rangeOfString:@"当前登录状态已失效"].location != NSNotFound) {
               
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   
                   [[UIApplication sharedApplication].keyWindow setRootViewController:[ZJLoginController new]];
               });
               
           }

       }
       
   } failure:^(NSURLSessionDataTask *task, NSError *error) {
       if (failure) {
           failure(task,error);
           [SVProgressHUD showInfoWithStatus:@"服务器连接错误"];
       }
   }];
    return task;
    
}

+(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    CCNetWorkingTool *tool = [CCNetWorkingTool sharedTool];
    tool.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
      [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
    NSURLSessionDataTask *task = [tool POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task,responseObject);
        }
        if ([self success:responseObject]) {
            [SVProgressHUD dismiss];
        }else{
            
             [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
            
            if ([responseObject[@"message"] rangeOfString:@"当前登录状态已失效"].location != NSNotFound) {
             
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [[UIApplication sharedApplication].keyWindow setRootViewController:[ZJLoginController new]];
                });
 
            }
 
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
            [SVProgressHUD showInfoWithStatus:@"服务器连接错误"];
        }

    }];
    return task;
    
}



+(NSURLSessionDataTask *)upLoadImageWithURLString:(NSString *)URLString parameters:(id)parameters andImageDic:(NSDictionary *)imageDic progress:(void (^)(NSProgress *progress))uploadProgressBlock success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure{
    
    CCNetWorkingTool *tool = [CCNetWorkingTool sharedTool];
     tool.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    
   NSURLSessionDataTask *task = [tool POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
      
       NSLog(@"formData == %@",formData);
           for (int i = 0; i < imageDic.allKeys.count; i++) {
               
               /*
                imaData: 需要上传的数据
                name: 服务器参数的名称
                fileName: 文件名称
                mimeType: 文件的类型
                */
               
               NSString *key = imageDic.allKeys[i];
               NSData *imaData = UIImageJPEGRepresentation([imageDic objectForKey:key], 0.5);
               
               [formData appendPartWithFileData:imaData name:[NSString stringWithFormat:@"%@",key] fileName:[NSString stringWithFormat:@"%@.png",key] mimeType:@"application/octet-stream"];
               //application/octet-stream 任意的二进制数据
               //@"multipart/form-data 文本数据，文件上传
           }

       
   } progress:^(NSProgress *progress){
     
       if (uploadProgressBlock) {
               
               uploadProgressBlock(progress);
               
               //主线程修改 ui
               dispatch_sync(dispatch_get_main_queue(), ^{
                   [SVProgressHUD showProgress:(float)(progress.completedUnitCount/progress.totalUnitCount) status:@"上传中..." maskType:SVProgressHUDMaskTypeBlack];
               });
               
           }

    
   }success:^(NSURLSessionDataTask *task, id responseObject) {
      
       if (success) {
           success(task,responseObject);
       }
       if ([self success:responseObject]) {
           
         [SVProgressHUD showSuccessWithStatus:@"上传成功"];
           
       }else{
           
           [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
           
           if ([responseObject[@"message"] rangeOfString:@"当前登录状态已失效"].location != NSNotFound) {
               
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   
                   [[UIApplication sharedApplication].keyWindow setRootViewController:[ZJLoginController new]];
               });
               
           }

       }

   } failure:^(NSURLSessionDataTask *task, NSError *error) {
       if (failure) {
           failure(task,error);
           [SVProgressHUD showInfoWithStatus:@"服务器连接错误"];
       }
   }];
    
    return task;

}
+(NSURLSessionDataTask *)upLoadVideoWithURLString:(NSString *)URLString parameters:(id)parameters andVideoDic:(NSDictionary *)videoDic progress:(void (^)(NSProgress *progress))uploadProgressBlock success:(void (^)(NSURLSessionDataTask *task ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure{
    
    CCNetWorkingTool *tool = [CCNetWorkingTool sharedTool];
    tool.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    
    NSURLSessionDataTask *task = [tool POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSLog(@"formData == %@",formData);
        for (int i = 0; i < videoDic.allKeys.count; i++) {
            
            /*
             imaData: 需要上传的数据
             name: 服务器参数的名称
             fileName: 文件名称
             mimeType: 文件的类型
             */
            
            NSString *key = videoDic.allKeys[i];
            NSData *videoData = [NSData dataWithContentsOfURL:[videoDic objectForKey:key]];
            
            [formData appendPartWithFileData:videoData name:key fileName:[NSString stringWithFormat:@"%@.mp4",key] mimeType:@"application/octet-stream"];
            //application/octet-stream 任意的二进制数据
            //@"multipart/form-data 文本数据，文件上传
        }
        
        
    } progress:^(NSProgress *progress){
        
        if (uploadProgressBlock) {
            
            uploadProgressBlock(progress);
            
            //主线程修改 ui
            dispatch_sync(dispatch_get_main_queue(), ^{
                [SVProgressHUD showProgress:(float)(progress.completedUnitCount/progress.totalUnitCount) status:@"上传中..." maskType:SVProgressHUDMaskTypeBlack];
            });
            
        }
        
        
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            success(task,responseObject);
        }
        if ([self success:responseObject]) {
            
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            
        }else{
            
            [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
         
            if ([responseObject[@"message"] rangeOfString:@"当前登录状态已失效"].location != NSNotFound) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [[UIApplication sharedApplication].keyWindow setRootViewController:[ZJLoginController new]];
                });
                
            }

        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
            NSLog(@"%@",error);
            [SVProgressHUD showInfoWithStatus:@"服务器连接错误"];
        }
    }];
    
    return task;
}

+(NSURLSessionDownloadTask *)downloadTaskWithURLString:(NSString *)URLString progress:(void (^)(NSProgress *progress))downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *url, NSError *))completionHandler{
    
    CCNetWorkingTool *tool = [CCNetWorkingTool sharedTool];
    tool.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    
    NSURLSessionDownloadTask *task = [tool downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]] progress:^(NSProgress *progress){
        if (downloadProgressBlock) {
          
            downloadProgressBlock(progress);
       
        }
        
    }destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *cachesURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [cachesURL URLByAppendingPathComponent:[response suggestedFilename]];
        
        //或    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //    NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        //    return [NSURL fileURLWithPath:path];

    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"下载成功"];
            NSLog(@"filePath == %@",filePath.absoluteString);
        }else{
            
            NSLog(@"error == %@",error);
        }
        
        
    }];
    
    return task;
}



+(BOOL)success:(NSDictionary *)responseObject{
   
    if ([[responseObject objectForKey:@"code"] intValue]==10000) {
        return YES;
    }
    
    
    return NO;
}



@end
