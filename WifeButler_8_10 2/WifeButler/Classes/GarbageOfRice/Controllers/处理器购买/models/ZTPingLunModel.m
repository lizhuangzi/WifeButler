//
//  ZTPingLunModel.m
//  WifeButler
//
//  Created by ZT on 16/5/28.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTPingLunModel.h"

@implementation ZTPingLunModel

- (NSString *)avatar
{
    return [NSString stringWithFormat:@"%@%@", KImageUrl, _avatar];
}

- (NSString *)time
{
    NSDate * createdDate =[NSDate dateWithTimeIntervalSince1970:[_time doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    formatter.dateFormat = @"yyyy-MM-dd";
    return  [formatter stringFromDate:createdDate];
}

@end
