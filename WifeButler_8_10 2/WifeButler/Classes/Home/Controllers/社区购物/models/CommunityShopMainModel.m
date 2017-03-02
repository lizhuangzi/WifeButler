//
//  CommunityShopMainModel.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/2.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CommunityShopMainModel.h"
#import "MJExtension.h"

@implementation CommunityShopMainModel

+ (instancetype)ShopMainModelWithDictionary:(NSDictionary *)dict
{
    CommunityShopMainModel * model = [CommunityShopMainModel mj_objectWithKeyValues:dict];
    
    return model;
}

- (void)setFiles:(NSString *)files
{
    _files = [KImageUrl stringByAppendingString:files];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id":@"id"};
}

@end
