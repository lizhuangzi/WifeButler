//
//  ZTGouWuCheModel.m
//  WifeButler
//
//  Created by ZT on 16/5/31.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTGouWuCheModel.h"

@implementation ZTGouWuCheModel

- (NSString *)files
{
    return [NSString stringWithFormat:@"%@%@", KImageUrl, _files];
}

- (void)setStatus:(NSString *)status
{
    _status = status;
    
    _isSelect = [status boolValue];
}


@end
