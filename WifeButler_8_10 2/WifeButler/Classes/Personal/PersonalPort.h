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
#endif /* PersonalPort_h */
