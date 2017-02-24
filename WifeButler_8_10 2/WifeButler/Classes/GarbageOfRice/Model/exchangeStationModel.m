//
//  exchangeStationModel.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/24.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "exchangeStationModel.h"
#import "MJExtension.h"

@implementation exchangeStationModel

+ (instancetype)exchangeStationModelWithDict:(NSDictionary *)dictionary{
    
    exchangeStationModel * model = [exchangeStationModel mj_objectWithKeyValues:dictionary];
    
    return model;
}

- (void)setShop_pic:(NSString *)shop_pic
{
    _shop_pic = [NSString stringWithFormat:@"%@%@",KImageUrl,shop_pic];
}

@end
