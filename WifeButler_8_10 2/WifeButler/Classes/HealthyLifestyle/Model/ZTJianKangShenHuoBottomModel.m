//
//  ZTJianKangShenHuoBottomModel.m
//  WifeButler
//
//  Created by ZT on 16/6/13.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTJianKangShenHuoBottomModel.h"
#import "MJExtension.h"

@implementation ZTJianKangShenHuoBottomModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id":@"id"};
}

- (NSMutableArray *)imageURLStrs
{
    if (!_imageURLStrs) {
        _imageURLStrs = [NSMutableArray array];
    }
    return _imageURLStrs;
}

- (void)mj_keyValuesDidFinishConvertingToObject
{
    NSString * files = self.file;
    if (files.length <=1) {
        return;
    }
    
    NSArray * fileArray = [files componentsSeparatedByString:@","];
    //用于记录
    int t = 0;
    for (NSString * urlStr in fileArray) {
      
        if ([urlStr isEqualToString:@""]) {
            continue;
        }
        NSString * newUrlStr = [KImageUrl stringByAppendingString:urlStr];
        [self.imageURLStrs addObject:newUrlStr];
        t++;
        if (t>4) { //图片数最多4张
            break;
        }
    }
}

@end
