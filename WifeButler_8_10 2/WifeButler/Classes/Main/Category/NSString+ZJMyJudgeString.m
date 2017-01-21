//
//  NSString+ZJMyJudgeString.m
//  Fish
//
//  Created by JL on 15/7/14.
//  Copyright (c) 2015年 zjtdmac3. All rights reserved.
//

#import "NSString+ZJMyJudgeString.h"

@implementation NSString (ZJMyJudgeString)

- (BOOL) validateIdentityCard
{
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}

//判断是否为密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

//判断是否为手机号
+ (BOOL) validateMobile:(NSString *)mobile
{
    if (mobile.length != 11)
    {
        return NO;
        
    }else{

        NSString *CM_NUM = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";

        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch3) {
            
            return YES;
            
        }else{
            
            return NO;
        }
    }
}

// 判断是否为邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 第二种方式是使用循环判断
+ (BOOL)isPureNumandCharacters:(NSString *)numChara
{
    if (!numChara) {
        return NO;
    }
    NSString *regex = @"[a-z][A-Z][0-9]";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:numChara];
}
+(BOOL)ispureNumCharaRange:(NSString *)numChara From:(int)startNum To:(int)endNum
{
    if (!numChara) {
        return NO;
    }
    if (![NSString isPureNumandCharacters:numChara]) {
        return NO;
    }
    if ((numChara.length>startNum)&&(numChara.length<endNum)) {
        return YES;
    }
    return NO;
}
+(BOOL)isNull:(NSString *)string
{
    if ((!string)||(string.length == 0)) {
        return YES;
    }
    return NO;
}


#pragma mark - 校验邮编
+ (BOOL) isValidZipcode:(NSString*)value
{
    const char *cvalue = [value UTF8String];
    size_t len = strlen(cvalue);
    if (len != 6) {
        return FALSE;
    }
    for (int i = 0; i < len; i++)
    {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9'))
        {
            return FALSE;
        }
    }
    return TRUE;
}

+(BOOL)judgePassWordLegal:(NSString *)pass{
    
    BOOL result = false;
    if ([pass length] >= 6){
        // 判断长度6 - 13位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,13}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
    
}

+ (BOOL)isShouHuoRen:(NSString *)person
{
//     [\u4e00-\u9fa5]
    
    NSString *passWordRegex = @"^[a-zA-Z\\u4E00-\\u9FFF\\.]{1,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:person];
    
}


+ (BOOL)isIDCardPerson:(NSString *)person
{
    NSString *passWordRegex = @"^\\u4E00-\\u9FFF]{1,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:person];
}



@end
