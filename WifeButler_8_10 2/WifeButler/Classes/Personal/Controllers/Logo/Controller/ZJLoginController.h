//
//  ZJLoginController.h
//  BaZhou
//
//  Created by JL on 15/10/8.
//  Copyright (c) 2015年 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJLoginController : UIViewController

/**
 *  是否登录
 */
@property (nonatomic, assign) BOOL isLogo;

/**
 *  刷新数据
 */
@property (nonatomic, copy) void (^shuaiXinShuJu)(void);

@end
