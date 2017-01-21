//
//  ZTGouWuCheModel.h
//  WifeButler
//
//  Created by ZT on 16/5/31.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTGouWuCheModel : NSObject

@property (nonatomic, assign) BOOL  isSelect;
@property (nonatomic, assign) int  AllNum;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * files;
@property (nonatomic, copy) NSString * money;
@property (nonatomic, copy) NSString * num;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, copy) NSString * shop_id;
@property (nonatomic, copy) NSString * ship_fee;
@property (nonatomic, copy) NSString * status;

@end
