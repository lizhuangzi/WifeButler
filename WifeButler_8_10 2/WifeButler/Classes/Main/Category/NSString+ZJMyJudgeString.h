//
//  NSString+ZJMyJudgeString.h
//  Fish
//
//  Created by JL on 15/7/14.
//  Copyright (c) 2015年 zjtdmac3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZJMyJudgeString)
// 判断是否为身份证
- (BOOL) validateIdentityCard;
// 判断是否为手机号
+ (BOOL) validateMobile:(NSString *)mobile;
// 判断是否为邮箱
+ (BOOL) validateEmail:(NSString *)email;
// 判断既是数字又是字母
+ (BOOL) isPureNumandCharacters:(NSString *)numChara;
// 判断字符串的长度在一个范围内
+ (BOOL) ispureNumCharaRange:(NSString *)numChara From:(int)startNum To:(int)endNum;
// 判断字符串是否为空，包括字符串是否为nil或是@""
+ (BOOL) isNull:(NSString *)string;
// 校验邮编
+ (BOOL) isValidZipcode:(NSString*)value;

// 判断密码格式是否正确
+(BOOL)judgePassWordLegal:(NSString *)pass;

// 收货人判断
+ (BOOL)isShouHuoRen:(NSString *)person;

// 身份证名字判断
// 收货人判断
+ (BOOL)isIDCardPerson:(NSString *)person;

@end
