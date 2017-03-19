//
//  EnzyCashPledgeViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/19.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "EnzyCashPledgeViewController.h"
#import "NetWorkPort.h"

@interface EnzyCashPledgeViewController ()

@end

@implementation EnzyCashPledgeViewController

- (void)RequestAliencryptionStrWithRequestUrlStr:(NSString *)urlStr andParmDict:(NSDictionary *)parm
{
    NSDictionary * newParm = @{@"type":@"1",@"userid":KUserId};
    [super RequestAliencryptionStrWithRequestUrlStr:KCashpledgePay andParmDict:newParm];
}

- (void)RequestWXinencryptionStrWithRequestUrlStr:(NSString *)urlStr andParmDict:(NSDictionary *)parm
{
    NSDictionary * newParm = @{@"type":@"2",@"userid":KUserId};
    [super RequestWXinencryptionStrWithRequestUrlStr:KCashpledgePay andParmDict:newParm];
}



@end
