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

/**充值*/
#define KRecharge [HTTP_BaseURL stringByAppendingString:@"e_wallet/Walletpay/pay"]

/**充值支付订单*/
#define KPayAndRechargeOrder [HTTP_BaseURL stringByAppendingString:@"e_wallet/Walletpay/create"]

/**交易记录*/
#define  KTransactionRecord [HTTP_BaseURL stringByAppendingString:@"e_wallet/E_wallet/walletlist"]

#endif /* PersonalPort_h */
