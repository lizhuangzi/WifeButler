//
//  ZTYouHuiJuanModel.h
//  WifeButler
//
//  Created by ZT on 16/5/30.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTYouHuiJuanModel : NSObject

@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * money;
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * times;
@property (nonatomic, copy) NSString * end_time;
@property (nonatomic, copy) NSString * day;

// 是否已被店铺选择
@property (nonatomic, assign) BOOL isXuanZe;
//店铺id
@property (nonatomic, assign) NSInteger biaoShiWei;

@end
