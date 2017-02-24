//
//  ZTLaJiHuanMiModel.h
//  WifeButler
//
//  Created by ZT on 16/5/27.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTLaJiHuanMiModel : NSObject
/**商品id*/
@property (nonatomic,copy)NSString * commodityId;
/**商品图片*/
@property (nonatomic,copy)NSString * iconImageStr;
/**商品单位*/
@property (nonatomic,copy)NSString * danwei;
/**标题*/
@property (nonatomic,copy)NSString * title;
/**兑换量*/
@property (nonatomic,copy)NSString * sales;
/**原先价格*/
@property (nonatomic,copy)NSString * oldprice;
/**现在需要的积分*/
@property (nonatomic,copy)NSString * scale;

+ (instancetype)laJiHuanMiModelWithDictioary:(NSDictionary *)dictionary;

@end
