//
//  ZTTimeTopModel.h
//  WifeButler
//
//  Created by ZT on 16/6/16.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTTimeBottonModel.h"

@interface ZTTimeTopModel : NSObject

@property (nonatomic, copy) NSString * week;

@property (nonatomic, copy) NSString * date;

@property (nonatomic, strong) NSArray * time;


@property (nonatomic, assign) BOOL  isSelectTop;

@end
