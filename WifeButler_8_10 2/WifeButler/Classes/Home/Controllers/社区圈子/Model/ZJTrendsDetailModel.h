//
//  ZJTrendsDetailModel.h
//  WifeButler
//
//  Created by 陈振奎 on 16/6/13.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJTrendsModel.h"

@interface ZJTrendsDetailModel : NSObject
//        "myup":0, 我是否支持
//        "count":1,
//        "some":"T", xx，xx等12人
@property (nonatomic, strong) ZJTrendsModel *topic;
@property (nonatomic, copy) NSString *myup;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *some;
@property (nonatomic, strong) NSArray *comment;



@end
