//
//  CommunityShopMainModel.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/2.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityShopMainModel : NSObject
/**图片*/
@property (nonatomic,copy)NSString * files;
/**图片全路径*/
@property (nonatomic,copy)NSString * imageURLStr;
/**名字*/
@property (nonatomic,copy)NSString * title;
/**现价*/
@property (nonatomic,copy)NSString * money;
/**原价*/
@property (nonatomic,copy)NSString * oldprice;
/**库存*/
@property (nonatomic,copy)NSString * store;
/**单位*/
@property (nonatomic,copy)NSString * unit;

@property (nonatomic,copy)NSString * sales;

@property (nonatomic,copy)NSString * Id;


+ (instancetype)ShopMainModelWithDictionary:(NSDictionary *)dict;

@end
