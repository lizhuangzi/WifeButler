//
//  ZTLogoModel.h
//  WifeButler
//
//  Created by ZT on 16/5/17.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTLogoModel : NSObject

@property (nonatomic, copy) NSString * avatar;

@property (nonatomic, copy) NSString * gender;

@property (nonatomic, copy) NSString * id;

@property (nonatomic, copy) NSString * last_ip;

@property (nonatomic, copy) NSString * last_time;

@property (nonatomic, copy) NSString * login_ip;

@property (nonatomic, copy) NSString * login_time;

@property (nonatomic, copy) NSString * mechine;

@property (nonatomic, copy) NSString * mobile;

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

@end
