//
//  EPCalendarModel.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/6.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPCalendarModel : NSObject

@property (nonatomic,copy)NSString * ctime;

@property (nonatomic,copy)NSString * Id;

@property (nonatomic,copy)NSString * title;

@property (nonatomic,assign,readonly)NSUInteger day;

+ (instancetype)calendarModelWithDictionary:(NSDictionary *)dict;

@end
