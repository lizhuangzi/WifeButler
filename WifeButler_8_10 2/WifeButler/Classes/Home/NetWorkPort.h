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

/**精品请求*/
#define KBoutiqueData [HTTP_BaseURL stringByAppendingString: @"homepage/Homepage/getJP"]

/**社区圈子  1.token 2.pageindex*/
#define KSheQuQuanZi [HTTP_BaseURL stringByAppendingString: @"account/chat/index"]

/**社区圈子点赞 1.topic_id 2.token */
#define KSheQuQuanZiDianZhan  [HTTP_BaseURL stringByAppendingString: @"account/chat/support"]

/**我的圈子*/
#define TRENDSLIST [HTTP_BaseURL stringByAppendingString: @"account/chat/myindex"]

/**社区购物左侧选择列表 1.jing 2.wei 3.cat_id 4.serve_id 5.pagesize 6.pageindex*/
#define KCommunityShopLeftList [HTTP_BaseURL stringByAppendingString:@"goods/goods/goods_index"]

/**社区购物右侧展示列表*/
#define KCommunityShopRightList [HTTP_BaseURL stringByAppendingString:@"goods/goods/cat_goods"]

#endif /* NetWorkPort_h */
