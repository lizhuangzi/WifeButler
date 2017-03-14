//
//  NSURL.h
//  WifeButler
//
//  Created by ZT on 16/5/17.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#ifndef NSURL_h
#define NSURL_h

//#define HTTP_BaseURL @"http://192.168.1.183:8080/index.php/"
//#define HTTP_BaseURL @"http://101.201.78.49:10085/index.php/"
//#define HTTP_BaseURL @"http://101.201.115.59/index.php/"
#define HTTP_BaseURL @"http://app.icanchubao.com/index.php/"

//#define KImageUrl    @"http://192.168.1.183:8080/"
//#define KImageUrl    @"http://101.201.78.49:10085/"
//#define KImageUrl    @"http://101.201.115.59/"
#define KImageUrl    @"http://app.icanchubao.com/"


/**
 *
 *
 *   我的模块接口
 *
 *
 */


// 注册获取验证码
#define KHuoYanZhenMa @"member/register/captcha"

// 注册
#define KRegsion @"member/register/subs"



// 找回密码
#define KZhaoHui @"member/reset/subs"

// 修改密码
#define KXiuGaiPassword @"member/reset/subs"

// 找回密码获取验证码
#define  KZhaoHuiPasswod  @"member/reset/captcha"

// 意见反馈
#define KYiJianFanKui  @"account/other/note_sub"

// 资料修改
#define KPersonInfoXiuGai  @"account/other/uinfo_update"


// 添加收货地址
#define KAddShouHuoAddress @"account/address/addaddress"

// 编辑收货地址
#define KBianJiShouHuoAddress @"account/address/editaddress"

// 删除收货地址
#define KDeleteShouHuoAddress @"account/address/deladdress"

// 获去省市区
#define KShenShiQuAddress     @"other/region/showlistall"

// 单条收货地址接口
#define KShenShiQuAddressOne     @"account/address/myaddressone"




/**
 *
 *  垃圾换米模块接口
 *
 */
// 垃圾处理器列表接口
#define    KLaJiChuLiQiList       @"goods/goods/goods_own_list"

// 垃圾处理器详情
#define    KLaJiChuLiQiXiangQin   @"goods/goods/goods_own_detail/"



// 垃圾处理器详情评价
#define    KLaJiChuLiQiPingJia    @"goods/goods/comment_rubbish"

// 我的默认收货地址接口&我的优惠劵（收货地址使用）
#define    KMoRenDiZhi            @"account/address/address_default"

// 兑换详情 - 商品简介
#define   KDuiHuanXiangQinH5       @"goods/goods/exchange_detail_h5"

// 垃圾换大米提交订单
#define   KLaJiHuanDaMiTijiao      @"account/order/order_exchange_commit/"

// 兑换订单列表
#define   KDuiHuanOrderList                     @"account/order/order_exchange_list"

// 兑换订单列表删除
#define   KDuiHuanOrderListDelete               @"account/order/order_del/"

// 兑换订单列表删除
#define   KDuiHuanOrderListQueRenShouHuo        @"account/order/order_get/"

// 兑换订单列表详情
#define   KDuiHuanOrderListXiangQin             @"account/order/exchange_detail/"



/**
 *  社区购物
 */





// 预约时间
#define     KYuYueTime          @"goods/goods/serve_time/"



/**
 *  我的
 */

// 支付宝支付
#define    KZhiFuBaoZhiFu    @"account/alipay/alipays"

// 微信支付
#define    KWeiXinZhiFu      @"account/wxpay/wx_pay"

// 订单
#define    KDingDan    @"account/order/order_list/"

// 订单删除
#define    KDingDanShanChu  @"account/order/order_del/"

// 取消订单
#define    KQuXiaoDingDan      @"account/order/order_cancel/"

// 确认收货
#define    KQueRenShouHuo      @"account/order/order_get/"

// 订单详情
#define    KDingDanXiangQing   @"account/order/order_detail/"

// 订单提交
#define    KDingDanTiJiao     @"account/order/commit/"

// 我的代金卷
#define    KWoDeDaiJinJuan    @"account/other/myvoucher/"

// 订单商品评价
#define    KPingJiaShop           @"account/order/comment/"

// 订单商品垃圾处理器评价
#define    KLaJiChuLiQiPingJiaDingDan    @"account/order/comment_rubbish/"


// 垃圾换米置换接口
#define   KLaJiHuanMiZhiHuan   @"account/order/order_exchange_commit/"

// 购物车列表
#define   KGouWuCheList         @"account/cart/cart_list/"

// 购物车选中状态
#define   KGouWuCheXuanZhong    @"account/cart/cart_sel"

// 购物车数量
#define   KGouWuCheXuanZhongShuLiang    @"account/cart/cart_num_change"


// 购物车列表删除
#define   KGouWuCheListShanChu  @"account/cart/cart_del/"

// 购物车提交
#define   KGouWuCheListTiJiao   @"account/cart/cart_commit/"

// 我的消息
#define   KWoDeXiaoXi   @"account/order/order_msg/"

// 我的个人信息
#define   KWoDeGeRenXinXi   @"/account/shop/shop1/"

// 店铺信息
#define   KWoDeDianPuXinXi   @"/account/shop/shop3"

// 店铺类型
#define   KWoDeDianPuType   @"/account/shop/type"

// 店铺地址
#define   KWoDeDianPuAddress   @"/account/shop/shop2"

// 开店查询
#define   KKaiDianChaXu   @"/account/shop/shop_see"

// 清空购物车
#define   KClearGouWuChe   @"/account/cart/clear"

// 默认地址设置
#define   KSetDefaultAddress   @"/account/address/default_set"

// 客服电话
#define   KKeFuPhone            @"/account/other/kefu"





/**
 *  社区圈子首页
 */
// 首页轮播图
#define   KHomeLunBoTu          @"goods/goods/index1"


// 圈子详情
#define   TRENDSDETAIL          @"account/chat/detail"


// 发布动态
#define ZTFaBuDongTai           @"account/chat/say"

// 更新背景
#define ZTGengXinBeiJin         @"account/chat/bg_update"

// 删除动态
#define ZTPengYouQuanDele       @"account/chat/del"

// 评论
#define ZTPengYouQuanPingLun    @"account/chat/comment"

// 他人圈子
#define ZTTaRenQuanZi           @"account/chat/hisindex"



/**
 *  健康生活
 */
// 健康生活
#define   KJianKangShenHuo          @"goods/article/health"

// 健康生活底部cell数据
#define   KJianKangShenHuoBottom          @"goods/article/health_list"

// 社区政务
#define   KSheQuZhenWu        @"goods/article/office"


#endif /* NSURL_h */
