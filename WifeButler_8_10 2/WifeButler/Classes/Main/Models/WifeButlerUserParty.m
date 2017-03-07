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
    return @{@"Id":@"id"};
}


- (void)mj_keyValuesDidFinishConvertingToObject
{
    NSString * str = [KImageUrl stringByAppendingString:self.avatar];
    NSString * utf8Str =  [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _iconFullPath = [NSURL URLWithString:utf8Str];
}
MJCodingImplementation

@end
