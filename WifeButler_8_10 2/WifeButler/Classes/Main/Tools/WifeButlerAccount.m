//
//  WifeButlerAccount.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/28.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerAccount.h"
#import "WifeButlerFileManager.h"

@implementation WifeButlerAccount

HMSingletonM(Account);

static NSString * fileName = @"userParty";

- (instancetype)init
{
    if (self = [super init]) {
       _userParty =(WifeButlerUserParty *)[WifeButlerFileManager getLoginUserInformation];
    }
    return self;
}

- (void)addUserParty:(WifeButlerUserParty *)userParty
{
    _isLogin = YES;
    _userParty = userParty;
    [WifeButlerFileManager saveLoginUserInformation:userParty];
}

- (void)synchronize{
    
    [WifeButlerFileManager saveLoginUserInformation:_userParty];
}

@end
