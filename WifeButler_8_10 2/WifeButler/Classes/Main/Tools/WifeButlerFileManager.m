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
    NSLog(@"%@",userPath);
    [NSKeyedArchiver archiveRootObject:user toFile:userPath];
}



+ (id<NSCoding>)getLoginUserInformation
{
    NSString * userPath = [F_UserPath stringByAppendingPathComponent:_name];
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:userPath];
}

+ (void)removeLoginUserInformation
{
    NSString * userPath = [F_UserPath stringByAppendingPathComponent:_name];
    [[NSFileManager defaultManager]removeItemAtPath:userPath error:nil];
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

+ (NSString *)getCacheSize
{
    unsigned long long size = 0;
    NSFileManager* manager = [NSFileManager defaultManager];
    NSString * filePath = [F_LibraryPath stringByAppendingPathComponent:@"Caches"];
    BOOL isDir = NO;
    BOOL exist = [manager fileExistsAtPath:filePath isDirectory:&isDir];
    
    // 判断路径是否存在
    if (!exist) return @"0";
    if (isDir) { // 是文件夹
        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:filePath];
        
        for (NSString *subPath in enumerator) {
            NSString *fullPath = [filePath stringByAppendingPathComponent:subPath];
            size += [manager attributesOfItemAtPath:fullPath error:nil].fileSize;
            
        }
    }else{ // 是文件
        size += [manager attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    CGFloat C = size /pow(1024, 2);
    
    return [NSString stringWithFormat:@"%.2fMB",C];

}

+ (void)cleanCache
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSString * filePath = [F_LibraryPath stringByAppendingPathComponent:@"Caches"];
    NSArray * contents = [manager contentsOfDirectoryAtPath:filePath error:nil];
    
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [manager removeItemAtPath:[filePath stringByAppendingPathComponent:filename] error:NULL];
    }
}

@end
