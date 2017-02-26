//
//  WifeButlerNetWorking.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/22.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerNetWorking.h"

@implementation WifeButlerNetWorking

+ (void)getHttpRequestWithURLsite:(NSString *)URLSite parameter:(NSDictionary *)parmDict success:(void(^)(NSDictionary *))success  failure:(void(^)(NSError *))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    [manager GET:URLSite parameters:parmDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)postHttpRequestWithURLsite:(NSString *)URLSite parameter:(NSDictionary *)parmDict success:(void(^)(NSDictionary *))success  failure:(void(^)(NSError *))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    [manager POST:URLSite parameters:parmDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        if (failure) {
            failure(error);
        }

    }];
}

+ (void)getPackagingHttpRequestWithURLsite:(NSString *)URLSite parameter:(NSDictionary *)parmDict success:(void(^)(id resultCode))success  failure:(void(^)(NSError * error))failure{
    
    [self getHttpRequestWithURLsite:URLSite parameter:parmDict success:^(NSDictionary *response) {
        
        if ([response[@"code"] intValue] == 10000) {
            
            NSArray * resultCode = response[@"resultCode"];
            if (success) {
                success(resultCode);
            }
        }else{
            NSError * error = [NSError errorWithDomain:NSMachErrorDomain code:20000 userInfo:@{@"msg":response[@"message"]}];
            failure(error);
        }
        
    } failure:failure];
    
}

+ (void)postPackagingHttpRequestWithURLsite:(NSString *)URLSite parameter:(NSDictionary *)parmDict success:(void(^)(id resultCode))success  failure:(void(^)(NSError * error))failure{
    
    
    [self postHttpRequestWithURLsite:URLSite parameter:parmDict success:^(NSDictionary *response) {
        
        if ([response[@"code"] intValue] == 10000) {
            
            NSArray * resultCode = response[@"resultCode"];
            if (success) {
                success(resultCode);
            }
        }else{
            NSError * error = [NSError errorWithDomain:NSMachErrorDomain code:20000 userInfo:@{@"msg":response[@"message"]}];
            failure(error);
        }
        
    } failure:failure];
    
}

@end
