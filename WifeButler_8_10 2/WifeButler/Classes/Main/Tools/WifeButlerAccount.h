//
//  WifeButlerAccount.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/28.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMSingleton.h"
#import "WifeButlerUserParty.h"

@interface WifeButlerAccount : NSObject

HMSingletonH(Account);

@property (nonatomic,strong,readonly) WifeButlerUserParty * userParty;


@property (nonatomic,assign,readonly) BOOL isLogin;

- (void)addUserParty:(WifeButlerUserParty *)userParty;

- (void)synchronize;


@end
