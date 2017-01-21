//
//  ZTJieSuang11Model.h
//  WifeButler
//
//  Created by ZT on 16/5/31.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTJieSuang11Model : NSObject

@property (nonatomic, strong) NSArray * goods;
@property (nonatomic, copy) NSString * money;
@property (nonatomic, copy) NSString * num;
@property (nonatomic, copy) NSString * shop_id;
@property (nonatomic, copy) NSString * shop_name;

@property (nonatomic, copy) NSString * yunFei;
@property (nonatomic, copy) NSString * daiJinJuan;

/**
 *  优惠卷价格
 */
@property (nonatomic, copy) NSString * price_youHuiJuan;

/**
 *  优惠卷id
 */
@property (nonatomic, copy) NSString * YouHuiJuan_id;

/**
 *  临时变量
 */
@property (nonatomic, copy) NSString * temp_money;


@end
