//
//  ZTLaJiHuanMiModel.m
//  WifeButler
//
//  Created by ZT on 16/5/27.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTLaJiHuanMiModel.h"
#import "MJExtension.h"

@implementation ZTLaJiHuanMiModel

+ (instancetype)laJiHuanMiModelWithDictioary:(NSDictionary *)dictionary{
    
    ZTLaJiHuanMiModel * model = [ZTLaJiHuanMiModel mj_objectWithKeyValues:dictionary];
    return model;
}
- (void)setIconImageStr:(NSString *)iconImageStr
{
    _iconImageStr = [NSString stringWithFormat:@"%@%@", KImageUrl, iconImageStr];
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"commodityId":@"id",@"iconImageStr":@"file"};
}
@end
