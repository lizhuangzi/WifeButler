//
//  EPCalendarModel.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/6.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "EPCalendarModel.h"
#import "MJExtension.h"

@implementation EPCalendarModel

- (void)mj_keyValuesDidFinishConvertingToObject
{
    NSArray * tempArray = [self.ctime componentsSeparatedByString:@" "];
    NSString * str1 = tempArray.firstObject;
    
    NSArray * array2 = [str1 componentsSeparatedByString:@"-"];
    NSString * Str2 = array2.lastObject;
    
    _day = Str2.integerValue;
}

+ (instancetype)calendarModelWithDictionary:(NSDictionary *)dict
{
    EPCalendarModel * model = [EPCalendarModel mj_objectWithKeyValues:dict];
    return model;
}

@end
