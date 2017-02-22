//
//  NetWorkPort.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/22.
//  Copyright © 2017年 zjtd. All rights reserved.
//
#import "NSURL.h"

#ifndef NetWorkPort_h
#define NetWorkPort_h

/** 社区购物首页 分类&轮播图 */
#define  KSheQuGouWu  [HTTP_BaseURL stringByAppendingString:@"goods/goods/index1"]

/** 默认小区接口经纬度*/
#define KMoRenXiaoQuJinWeiDu  [HTTP_BaseURL stringByAppendingString: @"goods/goods/village_default"]

#endif /* NetWorkPort_h */
