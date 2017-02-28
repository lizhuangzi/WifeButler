//
//  WifeButlerFileManager.h
//  WifeButler
//
//  Created by 李庄子 on 2017/2/28.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>

//DocumentPath
#define F_DocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject
#define F_WifeButlerRootPath [F_DocumentPath stringByAppendingPathComponent:@"WifeButler"]
#define F_UserPath [F_WifeButlerRootPath stringByAppendingPathComponent:@"user"]
//library路径
#define F_LibraryPath NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject

#define F_CachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

@interface WifeButlerFileManager : NSObject

/**保存登录用户模型*/
+ (void)saveLoginUserInformation:(id<NSCoding>)user;
/**获取用户模型*/
+ (id<NSCoding>)getLoginUserInformation;

@end
