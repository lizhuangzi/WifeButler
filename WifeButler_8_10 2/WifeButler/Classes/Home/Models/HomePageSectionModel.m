//
//  HomePageSectionModel.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/22.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "HomePageSectionModel.h"
#import "HomePageCellModel.h"
#import  "MJExtension.h"

@implementation HomePageSectionModel

+ (instancetype)SectionModelWithDictionary:(NSDictionary *)dict{
    
    HomePageSectionModel * model = [HomePageSectionModel mj_objectWithKeyValues:dict];
    
    return model;
}

- (void)setType:(NSInteger)type
{
    _type = type;
    for (HomePageCellModel * model in self.list) {
        model.type = _type;
    }
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"HomePageCellModel"};
}

@end
