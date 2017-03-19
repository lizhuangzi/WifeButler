//
//  PersonalPort.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/28.
//  Copyright © 2017年 zjtd. All rights reserved.
//
#import "NSURL.h"

#ifndef PersonalPort_h
#define PersonalPort_h

#define  KUserLogin  [HTTP_BaseURL stringByAppendingString:@"member/login/subs"]

/**获取用户积分信息*/
#define  KUserPocket [HTTP_BaseURL stringByAppendingString:@"e_wallet/E_wallet/myasset"]

/**获取用户二维码*/
#define KUserGetQRCode [HTTP_BaseURL stringByAppendingString:@"integrals/Exchange/getuserqr"]

/**银行卡列表*/
#define KBankCardList [HTTP_BaseURL stringByAppendingString:@"e_wallet/E_wallet/bankcardlist"]

/**银行卡归属*/
#define KBankCardAffiliate [HTTP_BaseURL stringByAppendingString:@"e_wallet/E_wallet/bankname"]

/**用户余额*/
#define KUserBalance [HTTP_BaseURL stringByAppendingString:@"e_wallet/E_wallet/getbalance"]

/**充值后台生成订单串接口*/
#define KRecharge [HTTP_BaseURL stringByAppendingString:@"e_wallet/Walletpay/pay"]

/**提现最后的接口*/
#define Kdeposit  [HTTP_BaseURL stringByAppendingString:@"e_wallet/Walletdraw/draw"]

/**充值提现订单*/
#define KPayAndRechargeOrder [HTTP_BaseURL stringByAppendingString:@"e_wallet/Walletpay/create"]

/**交易记录*/
#define  KTransactionRecord [HTTP_BaseURL stringByAppendingString:@"e_wallet/E_wallet/walletlist"]


// 添加收货地址
#define KAddShouHuoAddress [HTTP_BaseURL stringByAppendingString:@"account/address/addaddress"]

// 编辑收货地址
#define KBianJiShouHuoAddress [HTTP_BaseURL stringByAppendingString:@"account/address/editaddress"]

// 删除收货地址
#define KDeleteShouHuoAddress [HTTP_BaseURL stringByAppendingString:@"account/address/deladdress"]

// 默认地址设置
#define   KSetDefaultAddress   [HTTP_BaseURL stringByAppendingString:@"/account/address/default_set"]

// 单条收货地址接口
#define KShenShiQuAddressOne      [HTTP_BaseURL stringByAppendingString:@"account/address/myaddressone"]

//获取搜索的小区列表
#define KGetSearchVillageList [HTTP_BaseURL stringByAppendingString:@"account/address/getvillagelist"]
#endif /* PersonalPort_h */
