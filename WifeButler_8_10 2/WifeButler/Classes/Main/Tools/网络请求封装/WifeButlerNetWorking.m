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
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.securityPolicy.validatesDomainName = NO;
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
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json",@"application/json",nil];
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
            if ([response[@"code"] intValue] == 20000) { //请求接口错误
                NSError * error = [NSError errorWithDomain:NSMachErrorDomain code:20000 userInfo:@{@"msg":response[@"message"]}];
                failure(error);
                
            }else if ([response[@"code"] intValue] == 40000){//登录失效
                NSError * error = [NSError errorWithDomain:NSMachErrorDomain code:40000 userInfo:@{@"msg":response[@"message"]}];
                failure(error);
            }
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
            if ([response[@"code"] intValue] == 20000) { //请求接口错误
                NSError * error = [NSError errorWithDomain:NSMachErrorDomain code:20000 userInfo:@{@"msg":response[@"message"]}];
                failure(error);

            }else if ([response[@"code"] intValue] == 30000){
                NSError * error = [NSError errorWithDomain:NSMachErrorDomain code:30000 userInfo:@{@"msg":response[@"message"]}];
                failure(error);
            }
            else if ([response[@"code"] intValue] == 40000){//登录失效
                NSError * error = [NSError errorWithDomain:NSMachErrorDomain code:40000 userInfo:@{@"msg":response[@"message"]}];
                failure(error);
            }
        }
        
    } failure:failure];
    
}

@end
