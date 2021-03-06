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

// 我的默认收货地址接口&我的优惠劵（收货地址使用）
#define  KMoRenDiZhi         [HTTP_BaseURL stringByAppendingString:@"account/address/address_default"]

/**精品请求*/
#define KBoutiqueData [HTTP_BaseURL stringByAppendingString: @"homepage/Homepage/getJP"]

/**社区圈子  1.token 2.pageindex*/
#define KSheQuQuanZi [HTTP_BaseURL stringByAppendingString: @"account/chat/index"]

/**社区圈子点赞 1.topic_id 2.token */
#define KSheQuQuanZiDianZhan  [HTTP_BaseURL stringByAppendingString: @"account/chat/support"]

/**我的圈子*/
#define KTRENDSLIST [HTTP_BaseURL stringByAppendingString:@"account/chat/myindex"]

/**发布圈子*/
#define KPublicQuanZi [HTTP_BaseURL stringByAppendingString:@"account/chat/say"]

/**圈子点赞 */
#define KQuanZiDianZan [HTTP_BaseURL stringByAppendingString:@"account/chat/support"]
/**圈子删除*/
#define KQuanZiShanChu [HTTP_BaseURL stringByAppendingString:@"account/chat/del"]
/**更新背景*/
#define KQuanZiUpdateBG [HTTP_BaseURL stringByAppendingString:@"account/chat/bg_update"]
/**圈子评论*/
#define KQuanZiPingLun [HTTP_BaseURL stringByAppendingString:@"account/chat/comment"]

/**社区购物左侧选择列表 1.jing 2.wei 3.cat_id 4.serve_id 5.pagesize 6.pageindex*/
#define KCommunityShopLeftList [HTTP_BaseURL stringByAppendingString:@"goods/goods/goods_index"]

/**社区购物右侧展示列表*/
#define KCommunityShopRightList [HTTP_BaseURL stringByAppendingString:@"goods/goods/cat_goods"]

/**环保日历  userid */
#define KEPCalenderRequest [HTTP_BaseURL stringByAppendingString:@"integrals/Garbagecollection/usergarbagelist"]

/**社区服务 社区物流*/
#define KCommunityService [HTTP_BaseURL stringByAppendingString:@"goods/goods/serve_index"]

/**服务分类*/
#define ServiceCategory [HTTP_BaseURL stringByAppendingString:@"goods/goods/cat_goods"]

/**我的收获地址*/
#define KMyDeliveryLocation [HTTP_BaseURL stringByAppendingString:@"account/address/myaddress"]

/**小区列表*/
#define KvillageList [HTTP_BaseURL stringByAppendingString:@"account/address/village"]



//社区购物搜索
#define  KSheQuGouWuSearch        @"goods/goods/search/"

//物品详情
#define  KSheQuGouWuGoodDetail        @"goods/goods/goods_detail/"

//商品详情评价列表
#define  KGoodEvaluationList        @"goods/goods/goods_comment/"

//加入购物车
#define  KAddBusURL        @"account/cart/add_cart/"

//商品详情webView
#define  KGoodDetailWebViewURL        @"goods/goods/goods_desc/"

/**获取爱心个数*/
#define  KLoveDonateCount [HTTP_BaseURL stringByAppendingString:@"loveproject/Loveproject/getcount"]

/**爱心项目列表*/
#define KLoveDonateProjectList [HTTP_BaseURL stringByAppendingString:@"loveproject/Loveproject/getlist"]

/**爱心捐赠详情*/
#define KLoveDonateProjectDetail [HTTP_BaseURL stringByAppendingString:@"loveproject/Loveproject/details?id=%@"]

/**爱心用户个人信息*/
#define KLoveDonateUserInfo [HTTP_BaseURL stringByAppendingString:@"loveproject/Loveproject/getuserinfo"]

/**用户捐赠的爱心列表*/
#define KLoveDonateUserDonateList [HTTP_BaseURL stringByAppendingString:@"loveproject/Loveproject/getuserorder"]

/**用户捐赠记录*/
#define KLoveDonateUserRecordlist [HTTP_BaseURL stringByAppendingString:@"loveproject/Loveproject/getrecord?userid=%@&page=%@"]
/**生成爱心捐赠订单*/
#define KLoveDonateGenerateOrder [HTTP_BaseURL stringByAppendingString:@"loveproject/Loveproject/createorder"]
/**爱心捐赠详情内容h5*/
#define KLoveDonateHtml [HTTP_BaseURL stringByAppendingString:@"loveproject/Loveproject/pro_desc?pro_id=%@"]

/**爱心请求后台支付加密字符串*/
#define KLoveDonatePayment [HTTP_BaseURL stringByAppendingString:@"loveproject/Loveproject/pay"]


/**酵素回收是否交押金*/
#define KEnzymesRecycleisPaycashPledge [HTTP_BaseURL stringByAppendingString:@"integrals/Deposit/ishave"]

/**酵素回收押金支付*/
#define KCashpledgePay [HTTP_BaseURL stringByAppendingString:@"integrals/Deposit/createpay"]

/**获取社区回收电话*/
#define KGetSocialTelePhone [HTTP_BaseURL stringByAppendingString:@"integrals/Admin/getgarbagecollectionservice"]

/**获取回收时间*/
#define KGetAppointmentTime  [HTTP_BaseURL stringByAppendingString:@"integrals/Garbagecollection/serve_time"]

/**预约回收*/
#define KMakeAppointment [HTTP_BaseURL stringByAppendingString:@"integrals/Admin/sendmsggarbagecollection"]

#endif/* NetWorkPort_h */
