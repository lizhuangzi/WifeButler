//
//  WifeButlerUserParty.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/25.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WifeButlerUserParty : NSObject<NSCoding>
/**登录账号*/
@property (nonatomic,copy)NSString * userLoginAccount;
/**密码*/
@property (nonatomic,copy)NSString * userLoginPassWord;
/**头像*/
@property (nonatomic, copy) NSString * avatar;
/**性别*/
@property (nonatomic, copy) NSString * gender;

@property (nonatomic, copy) NSString * Id;

@property (nonatomic, copy) NSString * last_ip;

@property (nonatomic, copy) NSString * last_time;

@property (nonatomic, copy) NSString * login_ip;

@property (nonatomic, copy) NSString * login_time;

@property (nonatomic, copy) NSString * mechine;
/**手机号*/
@property (nonatomic, copy) NSString * mobile;
/**昵称*/
@property (nonatomic, copy) NSString * nickname;

@property (nonatomic, copy) NSString * passwd;

@property (nonatomic, copy) NSString * salts;

@property (nonatomic, copy) NSString * token_app;

@property (nonatomic, copy) NSString * user_agent;

/**
 *  经度
 */
@property (nonatomic, copy) NSString * jing;
/**
 *  小区
 */
@property (nonatomic, copy) NSString * village;
/**
 *  纬度
 */
@property (nonatomic, copy) NSString * wei;


+ (instancetype)UserPartyWithDictionary:(NSDictionary *)dictionary;

//
///**登录账号*/
//@property (nonatomic,copy)NSString * userLoginName;
///**用户姓名*/
//@property (nonatomic,copy)NSString * userName;
///**用户头像*/
//@property (nonatomic,copy)NSString * userHeaderIcon;
///**余额*/
//@property (nonatomic,copy)NSString * userBlance;
///**积分*/
//@property (nonatomic,copy)NSString * userNumber;
///**卡包*/
//@property (nonatomic,copy)NSString * userCardWalletCount;
///**优惠券*/
//@property (nonatomic,copy)NSString * userDiscountCouponCount;



@end
