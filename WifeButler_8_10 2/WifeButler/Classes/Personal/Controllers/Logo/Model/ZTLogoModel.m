//
//  ZTLogoModel.m
//  WifeButler
//
//  Created by ZT on 16/5/17.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTLogoModel.h"

@implementation ZTLogoModel

- (NSString *)avatar
{
    return [NSString stringWithFormat:@"%@%@", KImageUrl, _avatar];
}

@end
