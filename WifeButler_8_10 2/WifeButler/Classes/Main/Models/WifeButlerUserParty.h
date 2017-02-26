//
//  WifeButlerUserParty.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/25.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMSingleton.h"

@interface WifeButlerUserParty : NSObject

HMSingletonH(userParty)

/**登录账号*/
@property (nonatomic,copy)NSString * userLoginName;
/**用户姓名*/
@property (nonatomic,copy)NSString * userName;
/**用户头像*/
@property (nonatomic,copy)NSString * userHeaderIcon;
/**余额*/
@property (nonatomic,copy)NSString * userBlance;
/**积分*/
@property (nonatomic,copy)NSString * userNumber;
/**卡包*/
@property (nonatomic,copy)NSString * userCardWalletCount;
/**优惠券*/
@property (nonatomic,copy)NSString * userDiscountCouponCount;



@end
