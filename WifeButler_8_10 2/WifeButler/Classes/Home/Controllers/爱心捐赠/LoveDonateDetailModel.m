//
//  LoveDonateDetailModel.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "LoveDonateDetailModel.h"

@implementation LoveDonateDetailModel

- (void)mj_keyValuesDidFinishConvertingToObject
{
    NSString * imageFullPathStr = [KImageUrl stringByAppendingString:_banner];
    NSString * utf8Str = [imageFullPathStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.imageURL = [NSURL URLWithString:utf8Str];
}

@end
