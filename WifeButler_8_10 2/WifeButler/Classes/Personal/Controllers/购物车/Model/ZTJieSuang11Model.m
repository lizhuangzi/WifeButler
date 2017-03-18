//
//  ZTJieSuang11Model.m
//  WifeButler
//
//  Created by ZT on 16/5/31.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTJieSuang11Model.h"
#import "MJExtension.h"

@implementation ZTJieSuang11Model

- (void)setMoney:(NSString *)money
{
    _money = money;        
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{ 
              @"goods" : @"ZTJieShuan2Model"
              };
}

@end
