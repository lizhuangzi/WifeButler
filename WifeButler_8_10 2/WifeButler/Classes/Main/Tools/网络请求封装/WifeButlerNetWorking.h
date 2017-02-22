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

+ (void)getHttpRequestWithURLsite:(NSString *)URLSite parameter:(NSDictionary *)parmDict success:(void(^)(NSDictionary *))success  failure:(void(^)(NSError *))failure;

+ (void)postHttpRequestWithURLsite:(NSString *)URLSite parameter:(NSDictionary *)parmDict success:(void(^)(NSDictionary *))success  failure:(void(^)(NSError *))failure;
@end
