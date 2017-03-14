//
//  LoveDonateListModel.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/14.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "LoveDonateListModel.h"

@implementation LoveDonateListModel

- (void)mj_keyValuesDidFinishConvertingToObject
{
    NSString * imageFullPathStr = [KImageUrl stringByAppendingString:_banner];
    NSString * utf8Str = [imageFullPathStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.imageURL = [NSURL URLWithString:utf8Str];
}

@end
