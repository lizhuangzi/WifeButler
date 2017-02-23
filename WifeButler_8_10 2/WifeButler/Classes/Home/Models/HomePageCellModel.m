//
//  HomePageCellModel.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/22.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "HomePageCellModel.h"

@implementation HomePageCellModel

+ (instancetype)cellModelWithDictionary:(NSDictionary *)dict{
    
    HomePageCellModel * model =[HomePageCellModel mj_objectWithKeyValues:dict];
    NSString * file = dict[@"files"];
    model.imageURLstr = [KImageUrl stringByAppendingString:file];
    return model;
}

- (void)setImageURLstr:(NSString *)imageURLstr
{
    _imageURLstr = [KImageUrl stringByAppendingString:imageURLstr];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"commodityId":@"id",@"imageURLstr":@"files"};
}


@end
