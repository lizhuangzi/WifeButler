//
//  LoveDonatePayViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "LoveDonatePayViewController.h"
#import "NetWorkPort.h"
@interface LoveDonatePayViewController ()

@end

@implementation LoveDonatePayViewController

- (void)RequestAliencryptionStrWithRequestUrlStr:(NSString *)urlStr andParmDict:(NSDictionary *)parm
{
    NSDictionary * newParm = @{@"type":@"1",@"orderid":self.order_id};
    [super RequestAliencryptionStrWithRequestUrlStr:KLoveDonatePayment andParmDict:newParm];
}

- (void)RequestWXinencryptionStrWithRequestUrlStr:(NSString *)urlStr andParmDict:(NSDictionary *)parm
{
    NSDictionary * newParm = @{@"type":@"2",@"orderid":self.order_id};
    [super RequestWXinencryptionStrWithRequestUrlStr:KLoveDonatePayment andParmDict:newParm];
}

@end
