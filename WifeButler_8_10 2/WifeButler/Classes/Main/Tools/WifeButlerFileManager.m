//
//  WifeButlerFileManager.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/28.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerFileManager.h"

@implementation WifeButlerFileManager

static NSString * _name = @"userParty";

+ (void)load
{
    [self createPath];
}

+ (void)saveLoginUserInformation:(id<NSCoding>)user
{
    NSString * userPath = [F_UserPath stringByAppendingPathComponent:_name];
    [NSKeyedArchiver archiveRootObject:user toFile:userPath];
}

+ (id<NSCoding>)getLoginUserInformation
{
    NSString * userPath = [F_UserPath stringByAppendingPathComponent:_name];
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:userPath];
}

+ (void)createPath
{
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:F_WifeButlerRootPath];
    
    if (!isExist) {
        
        [[NSFileManager defaultManager]createDirectoryAtPath:F_WifeButlerRootPath withIntermediateDirectories:NO attributes:nil error:nil];

        [[NSFileManager defaultManager]createDirectoryAtPath:F_UserPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    ZJLog(@"%@",F_DocumentPath);
}

@end
