//
//  WifeButlerUserParty.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/25.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerUserParty.h"
#import "MJExtension.h"

@implementation WifeButlerUserParty

+ (instancetype)UserPartyWithDictionary:(NSDictionary *)dictionary
{
    WifeButlerUserParty * party = [WifeButlerUserParty mj_objectWithKeyValues:dictionary];
    
    return party;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{};
}

MJCodingImplementation

@end
