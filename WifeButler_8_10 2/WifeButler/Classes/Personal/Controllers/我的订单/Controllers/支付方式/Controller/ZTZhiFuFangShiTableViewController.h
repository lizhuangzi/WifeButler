//
//  ZTZhiFuFangShiTableViewController.h
//  WifeButler
//
//  Created by ZT on 16/5/29.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    zhifuBaoZhiFuFangShi,   // 支付宝
    weiXinZhiFuFangShi,     // 微信
    
}ZhiFuFangShi;


@interface ZTZhiFuFangShiTableViewController : UITableViewController

@property (nonatomic, copy) NSString * order_id;

@property (nonatomic, copy) void (^shuaiXinBlack)(void);

- (void)RequestAliencryptionStrWithRequestUrlStr:(NSString *)urlStr andParmDict:(NSDictionary *)parm;

- (void)RequestWXinencryptionStrWithRequestUrlStr:(NSString *)urlStr andParmDict:(NSDictionary *)parm;


@end
