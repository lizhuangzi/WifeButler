//
//  WifeButlerCommonBaseModel.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/9.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerCommonBaseModel.h"


@implementation WifeButlerCommonBaseModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict
{
    WifeButlerCommonBaseModel * model = [self mj_objectWithKeyValues:dict];
    return model;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id":@"id"};
}

- (void)mj_keyValuesDidFinishConvertingToObject
{
    if (_files.length>0) {
        NSString * imageFullPathStr = [KImageUrl stringByAppendingString:_files];
        NSString * utf8Str = [imageFullPathStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.imageURL = [NSURL URLWithString:utf8Str];
        
    }else if (_file.length>0){
        NSString * imageFullPathStr = [KImageUrl stringByAppendingString:_file];
        NSString * utf8Str = [imageFullPathStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.imageURL = [NSURL URLWithString:utf8Str];
    }
}

@end
