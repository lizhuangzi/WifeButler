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

- (void)loginUserParty:(WifeButlerUserParty *)userParty
{
    _isLogin = YES;
    _userParty = userParty;
    [WifeButlerFileManager saveLoginUserInformation:userParty];
}

- (void)loginOffCurrentUser
{
    _isLogin = NO;
    _userParty = nil;
    [WifeButlerFileManager removeLoginUserInformation];
}

- (void)synchronize{
    
    [WifeButlerFileManager saveLoginUserInformation:_userParty];
}

@end
