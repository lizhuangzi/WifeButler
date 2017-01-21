//
//  ZTLaJiHuanMiModel.m
//  WifeButler
//
//  Created by ZT on 16/5/27.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTLaJiHuanMiModel.h"

@implementation ZTLaJiHuanMiModel

- (NSString *)files
{
    return [NSString stringWithFormat:@"%@%@", KImageUrl, _files];
}

- (NSString *)file
{
    return [NSString stringWithFormat:@"%@%@", KImageUrl, _file];
}

@end
