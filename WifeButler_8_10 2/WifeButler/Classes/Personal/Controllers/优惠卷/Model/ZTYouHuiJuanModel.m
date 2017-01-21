//
//  ZTYouHuiJuanModel.m
//  WifeButler
//
//  Created by ZT on 16/5/30.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTYouHuiJuanModel.h"

@implementation ZTYouHuiJuanModel

- (NSString *)end_time
{

    NSDate * createdDate =[NSDate dateWithTimeIntervalSince1970:[_end_time doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    formatter.dateFormat = @"yyyy-MM-dd";   //HH:mm:ss
    return  [formatter stringFromDate:createdDate];
    
}

@end
