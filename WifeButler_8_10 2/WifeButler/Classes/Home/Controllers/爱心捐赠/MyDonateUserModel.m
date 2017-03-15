//
//  MyDonateUserModel.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "MyDonateUserModel.h"
#import "MJExtension.h"
@implementation MyDonateUserModel

+ (instancetype)userWithDictionary:(NSDictionary *)dict
{
    MyDonateUserModel * model = [MyDonateUserModel mj_objectWithKeyValues:dict];
    
    return model;
}


- (void)mj_keyValuesDidFinishConvertingToObject
{
    NSString * str = [KImageUrl stringByAppendingString:self.avatar];
    NSString * utf8Str =  [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _iconFullPath = [NSURL URLWithString:utf8Str];
}
@end
