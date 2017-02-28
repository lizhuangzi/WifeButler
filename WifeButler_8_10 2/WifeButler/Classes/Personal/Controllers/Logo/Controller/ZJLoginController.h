//
//  ZJLoginController.h
//  BaZhou
//
//  Created by JL on 15/10/8.
//  Copyright (c) 2015年 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoginResultReturnType) {
    LoginResultReturnTypeSuccess,
    LoginResultReturnTypeFailure,
};

@interface ZJLoginController : UIViewController

/**
 *  是否登录
 */
@property (nonatomic, assign) BOOL isLogo;

/**
 *  刷新数据
 */
@property (nonatomic, copy) void (^shuaiXinShuJu)(void);

+ (void)autoLoginWithUserName:(NSString *)userName Password:(NSString *)password andfinishBlock:(void(^)(LoginResultReturnType returnType))finish;

@end
