//
//  WifeButlerDefine2.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/7.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#ifndef WifeButlerDefine2_h
#define WifeButlerDefine2_h

#define PlaceHolderImage_Person [UIImage imageNamed:@"placeHolderIcon"]
#define PlaceHolderImage_Other [UIImage imageNamed:@"ZTZhanWeiTu11"]

#define WEAKSELF typeof(self) __weak weakSelf = self;
#import "WifeButlerAccount.h"
#define KToken  ([WifeButlerAccount sharedAccount].userParty.token_app ? [WifeButlerAccount sharedAccount].userParty.token_app : @"")
#define KUserId [WifeButlerAccount sharedAccount].userParty.Id ? [WifeButlerAccount sharedAccount].userParty.Id :@""

#endif /* WifeButlerDefine2_h */
