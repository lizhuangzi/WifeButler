//
//  NSDate+NowTime.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/19.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "NSDate+NowTime.h"

@implementation NSDate (NowTime)

+ (NSString *)getdateStrWithCurrentTime:(NSString *)str
{
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:str.longLongValue];
    NSDateFormatter * fo = [[NSDateFormatter alloc]init];
    fo.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSString * A = [fo stringFromDate:date];
    return A;
}

@end
