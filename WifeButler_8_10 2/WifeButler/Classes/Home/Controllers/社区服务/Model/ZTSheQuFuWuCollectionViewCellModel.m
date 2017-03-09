//
//  ZTSheQuFuWuCollectionViewCellModel.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/9.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "ZTSheQuFuWuCollectionViewCellModel.h"
#import "MJExtension.h"

@implementation ZTSheQuFuWuCollectionViewCellModel

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    ZTSheQuFuWuCollectionViewCellModel * model = [ZTSheQuFuWuCollectionViewCellModel mj_objectWithKeyValues:dict];
    return model;
}


- (void)mj_keyValuesDidFinishConvertingToObject
{
    if (_file) {
        self.imageURLStr = [KImageUrl stringByAppendingString:_file];
    }
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id":@"id"};
}


@end
