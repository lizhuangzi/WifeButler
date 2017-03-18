//
//  WifeButlerNetWorking.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/22.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface WifeButlerNetWorking : NSObject

+ (void)getHttpRequestWithURLsite:(NSString *)URLSite parameter:(NSDictionary *)parmDict success:(void(^)(NSDictionary * response))success  failure:(void(^)(NSError * error))failure;

+ (void)postHttpRequestWithURLsite:(NSString *)URLSite parameter:(NSDictionary *)parmDict success:(void(^)(NSDictionary * response))success  failure:(void(^)(NSError * error))failure;

+ (void)getPackagingHttpRequestWithURLsite:(NSString *)URLSite parameter:(NSDictionary *)parmDict success:(void(^)(id resultCode))success  failure:(void(^)(NSError * error))failure;

+ (void)postPackagingHttpRequestWithURLsite:(NSString *)URLSite parameter:(NSDictionary *)parmDict success:(void(^)(id resultCode))success  failure:(void(^)(NSError * error))failure;

/**上传图片*/
+ (void)postPackagingHttpRequestWithURLsite:(NSString *)URLSite parameter:(NSDictionary *)parmDict andFormData:(void(^)(id<AFMultipartFormData> formData))formDataBlock success:(void(^)(id resultCode))success  failure:(void(^)(NSError * error))failure;

@end
