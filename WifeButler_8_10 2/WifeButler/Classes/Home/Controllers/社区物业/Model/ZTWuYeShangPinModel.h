//
//  ZTWuYeShangPinModel.h
//  WifeButler
//
//  Created by ZT on 16/6/6.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTWuYeShopsModel.h"
@interface ZTWuYeShangPinModel : NSObject

@property (nonatomic, copy) NSString * file;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * level;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * serve_id;
@property (nonatomic, copy) NSString * ship_time;
@property (nonatomic, copy) NSString * sort;
@property (nonatomic, copy) NSString * time_kind;
@property (nonatomic, copy) NSString * upid;
@property (nonatomic, copy) NSString * upname;

@property (nonatomic, strong) NSArray * child;
@property (nonatomic, strong) NSArray * shops;

@end
