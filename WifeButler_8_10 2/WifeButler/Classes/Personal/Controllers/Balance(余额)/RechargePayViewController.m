//
//  RechargePayViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/14.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "RechargePayViewController.h"
#import "PersonalPort.h"

@interface RechargePayViewController ()

@end

@implementation RechargePayViewController


- (void)RequestAliencryptionStrWithRequestUrlStr:(NSString *)urlStr andParmDict:(NSDictionary *)parm
{
    NSDictionary * newParm = @{@"type":@"1",@"ordernum":self.order_id};
    [super RequestAliencryptionStrWithRequestUrlStr:KRecharge andParmDict:newParm];
}

- (void)RequestWXinencryptionStrWithRequestUrlStr:(NSString *)urlStr andParmDict:(NSDictionary *)parm
{
    NSDictionary * newParm = @{@"type":@"2",@"ordernum":self.order_id};
    [super RequestWXinencryptionStrWithRequestUrlStr:urlStr andParmDict:newParm];
}



@end
